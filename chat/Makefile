
IMGNAME     := samstav/chat
IMGID       := $(shell docker images $(IMGNAME) --format "{{.ID}}" | head -n 1)
REVISION    := $(shell git rev-parse --short --verify HEAD)

cwd ?= $(shell pwd)
user ?= root
container_workdir ?= /usr/src/app
chat_server_port := $(or ${CHAT_SERVER_PORT},${CHAT_SERVER_PORT},1119)
chat_server_host := $(or ${CHAT_SERVER_HOST},${CHAT_SERVER_HOST}, 0.0.0.0)

.PHONY: run-shell
run-shell:
	docker run \
	  --tty \
	  --interactive \
	  --user $(user) \
	  $(IMGNAME):$(REVISION) \
	  /bin/bash

.PHONY: run-live
run-live:
	docker run \
	  --tty \
	  --interactive \
	  --env CHAT_SERVER_PORT=$(chat_server_port) \
	  --env CHAT_SERVER_HOST=$(chat_server_host) \
	  --volume $(shell realpath $(cwd)):$(container_workdir) \
	  --publish $(chat_server_port):$(chat_server_port)/tcp \
	  --user $(user) \
	  $(IMGNAME):$(REVISION)

.PHONY: build
build:
	docker build --tag $(IMGNAME):$(REVISION) .


