FROM lambci/lambda:build-nodejs12.x


RUN cd /opt && \
  curl -sSL https://shogo82148-lambda-perl-runtime-us-east-1.s3.amazonaws.com/perl-5-30-runtime.zip -o runtime.zip && \
  unzip runtime.zip && rm runtime.zip && \
  npm install -g serverless && \
  ln -s /usr/include/locale.h /usr/include/xlocale.h

COPY . /var/task/

RUN npm install --only=prod && \
  cp -ar /var/task/perl_layer/* /opt/ && \
  cp -ar /var/task/image_layer/* /opt/
