XUNIT=

.SUFFIXES:
MAKEFLAGS += --no-builtin-rules

IMAGE_NAME := wyoming/whisper
IMAGE_BRANCH := $(shell git branch --show-current)
IMAGE_HASH := $(shell git describe --always --dirty)

.PHONY = docker docker-tags

docker: whisper/Dockerfile
	cd whisper && BUILDAH_FORMAT=docker buildah bud --build-arg BASE=docker.io/nvidia/cuda:12.3.2-cudnn9-runtime-ubuntu22.04 -t $(IMAGE_NAME) .
	[ "$(IMAGE_BRANCH)" != "" ] || exit 0 ; cd whisper && buildah tag $(IMAGE_NAME) $(IMAGE_NAME):$(IMAGE_BRANCH)
	[ "$(IMAGE_BRANCH)" != "" ] || exit 0 ; cd whisper && buildah tag $(IMAGE_NAME) $(IMAGE_NAME):$(IMAGE_BRANCH)-$(IMAGE_HASH)

docker-tags:
	if [ -z "$(IMAGE_BRANCH)" ] ; then echo No empty branch name containers allowed '('$(IMAGE_BRANCH)')'. >&2 ; exit 1 ; fi
	echo $(IMAGE_NAME):$(IMAGE_BRANCH)-$(IMAGE_HASH)
	echo $(IMAGE_NAME):$(IMAGE_BRANCH)
