const fs = require('fs');
const fetch = require('node-fetch');
const HtmlDiffer = require('html-differ').HtmlDiffer;
const headers = {
  rtf: 'application/rtf',
  html: 'text/html'
};

const fileList = type => fs.readdirSync(`./test/${type}`);
const rtfFiles = fileList('rtf');

const readFixture = (type, name) =>
  fs.readFileSync(`./test/${type}/${name}`).toString('utf8');

const convertFile = async (inType, outType, name) => {
  const body = readFixture(inType, name);
  return await fetch('http://localhost:4000/', {
    method: 'POST',
    body,
    headers: {
      'Content-Type': headers[inType],
      Accept: headers[outType]
    }
  }).then(res => res.text());
};

const diff = (file1, file2) => {
  const htmlDiffer = new HtmlDiffer();
  const result = htmlDiffer.isEqual(file1, file2);
  if (!result) console.log(htmlDiffer.diffHtml(file1, file2));
  return result;
};

describe('Converting RTF to HTML', () => {
  for (let rtfFile of rtfFiles) {
    const htmlFile = rtfFile.replace('.rtf', '.html');
    it(`renders file ${rtfFile} to ${htmlFile}`, async function() {
      const convertedFile = await convertFile('rtf', 'html', rtfFile);
      const expectedFile = readFixture('html', htmlFile);
      expect(diff(convertedFile, expectedFile)).toBe(true);
    });
  }
});
