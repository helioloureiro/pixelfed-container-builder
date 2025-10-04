VERSION := v0.12.6

all:

build:
	podman build \
		-t pixelfed-php-fpm:$(VERSION) \
		--label=VERSION=$(VERSION) \
		--build-arg=VERSION=$(VERSION) \
		.

	podman build \
		-t pixelfed-nginx:$(VERSION) \
		--label=VERSION=$(VERSION) \
		--build-arg=VERSION=$(VERSION) \
		--file=Containerfile-nginx \
		.

