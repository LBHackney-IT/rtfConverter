FROM lambci/lambda:build-nodejs12.x

RUN cd /opt && \
  curl -sSL https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-30-runtime.zip -o runtime.zip && \
  unzip runtime.zip && rm runtime.zip && \
  npm install -g serverless && \
  curl -L -o expat-2.2.9.tar.gz https://github.com/libexpat/libexpat/releases/download/R_2_2_9/expat-2.2.9.tar.gz && \
  tar -xzf expat-2.2.9.tar.gz && \
  cd expat-2.2.9 && \
  ./configure && \
  make install && \
  ln -s /usr/include/locale.h /usr/include/xlocale.h



