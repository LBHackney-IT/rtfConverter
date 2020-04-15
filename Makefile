.PHONY: build
build:
	docker build --tag rtf_converter:latest - < Dockerfile

.PHONY: build-layer
build-layer: build
	docker run --rm \
    -v $(PWD):/var/task \
    -v $(PWD)/perl_layer/lib/perl5/site_perl:/opt/lib/perl5/site_perl \
    rtf_converter:latest \
    cpanm --notest --no-man-pages XML::DOM RTF::HTMLConverter
	docker run --rm \
    -v $(PWD):/var/task \
    -v $(PWD)/perl_layer/lib/perl5/site_perl:/opt/lib/perl5/site_perl \
    rtf_converter:latest \
    cp /usr/lib64/libcrypt.so.1 /usr/lib64/libexpat.so.1 /var/task/perl_layer/lib

.PHONY: start
start: build-layer
	docker run -it -v $(PWD):/var/task -v $(PWD)/perl_layer/lib/perl5/site_perl:/opt/lib/perl5/site_perl -v $(PWD):/var/task -p 3000:3000 --workdir /var/task rtf_converter:latest ./docker_run.sh
