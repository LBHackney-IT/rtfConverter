.PHONY: build
build: image_layer/bin/convert
	docker build --tag rtf_converter:latest .

.PHONY: build-perl-layer
build-perl-layer: build
	rm -rf perl_layer
	mkdir -p perl_layer/lib/perl5/
	docker run --name build rtf_converter:latest /bin/true
	docker cp build:/opt/lib/perl5/site_perl/ ./perl_layer/lib/perl5/
	docker cp build:/usr/lib64/libcrypt-2.26.so ./perl_layer/lib/libcrypt.so.1
	docker cp build:/usr/lib64/libexpat.so.1.6.0 ./perl_layer/lib/libexpat.so.1
	docker rm build

image_layer/bin/convert:
	docker run --rm -v $(PWD)/image_layer:/lambda/opt lambci/yumda:2 yum install -y ImageMagick libwmf ghostscript-fonts
	# rm -rf image_layer/share

.PHONY: start
start: build-perl-layer
	docker run -it -v $(PWD):/var/task -p 3000:3000 --workdir /var/task rtf_converter:latest serverless -s dev offline start
