FROM lambci/lambda:build-nodejs12.x

RUN cd /opt && \
  curl -sSL https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-30-runtime.zip -o runtime.zip && \
  unzip runtime.zip && rm runtime.zip && \
  npm install -g serverless && \
  curl -sSL https://github.com/libexpat/libexpat/releases/download/R_2_2_9/expat-2.2.9.tar.gz -o expat-2.2.9.tar.gz && \
  tar -xzf expat-2.2.9.tar.gz && pushd expat-2.2.9 && \
  ./configure && make install && \
  popd && rm -rf expat-2.2.9 && rm expat-2.2.9.tar.gz && \
  ln -s /usr/include/locale.h /usr/include/xlocale.h
