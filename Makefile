VERSION := v0.12.6

all:

build:
	podman build \
		-t pixelfed:$(VERSION) \
		--label=VERSION=$(VERSION) \
		--build-arg=VERSION=$(VERSION) \
		.
