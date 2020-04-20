const fs = require("fs");
const { spawn } = require("child_process");
const { inlineSource } = require("inline-source");
const statusCodes = {
  415: "Unsupported Media Type",
  500: "Internal Server Error"
};

const send = (statusCode, contentType, body) => {
  return {
    statusCode,
    headers: { "Content-Type": contentType },
    isBase64Encoded: false,
    body
  };
};

const send_html = body => {
  return send(200, "text/html", body);
};

const send_error = (statusCode, message) => {
  return send(
    statusCode,
    "application/json",
    JSON.stringify({ statusCode, error: statusCodes[statusCode], message })
  );
};

const inlineImages = async path => {
  return inlineSource(path, {
    compress: true,
    attribute: false,
    rootpath: "/tmp"
  });
};

const convertRtf = async rtf => {
  fs.writeFileSync("/tmp/temp.rtf", rtf);
  let out = "";
  let error = "";
  return new Promise((resolve, reject) => {
    const converter = spawn(
      "/opt/bin/perl",
      ["./rtf2html.pl", "/tmp/temp.rtf", "/tmp/temp.html"],
      {
        cwd: "./perl"
      }
    );
    converter.stderr.on("data", data => (error += data));
    converter.stdout.on("data", data => (out += data));
    converter.on("close", code => {
      if (out !== "") console.log(out);
      let html = inlineImages("/tmp/temp.html");
      code !== 0 ? reject(error) : resolve(html);
    });
  });
};

const convert = async event => {
  const contentType =
    event.headers["content-type"] || event.headers["Content-Type"];
  if (contentType !== "application/rtf")
    return send_error(415, "Content type is not RTF");

  const rtf = event.body;
  try {
    const html = await convertRtf(rtf);
    return send_html(html);
  } catch (err) {
    console.log(err);
    return send_error(500, err);
  }
};

const form = () => {
  const formDoc = fs.readFileSync("./form.html", "utf8");
  return send_html(formDoc);
};

module.exports.handler = async event => {
  if (event.httpMethod === "GET") return form(event);
  if (event.httpMethod === "POST") return await convert(event);
};
