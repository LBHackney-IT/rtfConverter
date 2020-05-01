# RTF Converter

Build Status: [![CircleCI](https://circleci.com/gh/LBHackney-IT/rtfConverter.svg?style=svg)](https://app.circleci.com/pipelines/github/LBHackney-IT/rtfConverter)


At Hackney we use lots of RTFs for letters to people. We would like to be able to convert these into more web-friendly formats so that they can be viewed over the internet more easily. After looking at a number of RTF conversion libraries we found that the most consistent was a Perl module called [RTF::HTMLConverter](https://metacpan.org/pod/RTF::HTMLConverter).

This repo wraps uses serverless to deploy this library to AWS lambda.

## Using locally

Run `npm install` to install all of the node.js dependencies and then `make start` which will run serverless offline inside a docker container with all of the Perl dependencies installed.

You should then be able to open [](http://localhost:3000) to try out the service.
