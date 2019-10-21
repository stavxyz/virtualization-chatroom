
IMGNAME     := samstav/chat
IMGID       := $(shell docker images $(IMGNAME) --format "{{.ID}}" | head -n 1)
REVISION    := $(shell git rev-parse --short --verify HEAD)
user ?= root

.PHONY: run
run:
	docker run \
	  --tty \
	  --user $(user) \
	  --workdir /$(user) \
	  --interactive \
	  $(IMGID) \
	  /bin/bash

.PHONY: build
build:
	docker build --tag $(IMGNAME):$(REVISION) .


