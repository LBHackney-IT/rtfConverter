.PHONY: build
build:
	docker build --tag rtf_converter:latest - < Dockerfile

.PHONY: build-layer
build-layer: build
	rm -rf perl_layer
	mkdir -p perl_layer/lib/perl5/
	docker run --name build rtf_converter:latest /bin/true
	docker cp build:/opt/lib/perl5/site_perl/ ./perl_layer/lib/perl5/
	docker cp build:/usr/lib64/libcrypt-2.26.so ./perl_layer/lib/libcrypt.so.1
	docker cp build:/usr/lib64/libexpat.so.1.6.0 ./perl_layer/lib/libexpat.so.1
	docker rm build

.PHONY: start
start: build-layer
	docker run -it -v $(PWD):/var/task -v $(PWD)/perl_layer/lib/perl5/site_perl:/opt/lib/perl5/site_perl -v $(PWD):/var/task -p 3000:3000 --workdir /var/task rtf_converter:latest serverless -s dev offline start
