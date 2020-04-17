.PHONY: build
build: perl-layer image-layer
	docker build --tag rtf_converter:latest .

perl-layer: perl_layer/lib/libcrypt.so.1

perl_layer/lib/libcrypt.so.1:
	rm -rf perl_layer
	mkdir -p perl_layer/lib/perl5/
	-docker rm build
	docker run --name build shogo82148/p5-aws-lambda:build-5.30 cpanm --notest --no-man-pages Image::Info XML::DOM RTF::HTMLConverter
	docker cp build:/opt/lib/perl5/site_perl/ ./perl_layer/lib/perl5/
	docker cp build:/lib64/libcrypt-2.17.so ./perl_layer/lib/libcrypt.so.1
	docker cp build:/lib64/libexpat.so.1.6.0 ./perl_layer/lib/libexpat.so.1
	docker rm build

image-layer: image_layer/bin/convert

image_layer/bin/convert:
	rm -rf image_layer
	-docker rm image
	docker run --name image lambci/yumda:2 yum install -y ImageMagick libwmf ghostscript-fonts
	docker cp image:/lambda/opt ./image_layer
	rm -rf ./image_layer/etc/fonts ./image_layer/etc/X11
	docker rm image

clean:
	rm -rf perl_layer
	rm -rf image_layer

.PHONY: start
start: build
	docker run -it -v $(PWD):/var/task -p 3000:3000 --workdir /var/task rtf_converter:latest serverless -s dev offline start
