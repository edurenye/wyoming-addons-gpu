BUILDAH_FLAGS :=
WHISPER_IMAGE_NAME := wyoming/whisper
PIPER_IMAGE_NAME := wyoming/piper
IMAGE_BRANCH := $(shell git branch --show-current)
IMAGE_HASH := $(shell git describe --always --dirty)

.PHONY: whisper piper docker docker-tags

docker: piper whisper

docker-tags:
	if [ -z "$(IMAGE_BRANCH)" ] ; then echo No empty branch name containers allowed '('$(IMAGE_BRANCH)')'. >&2 ; exit 1 ; fi
	echo $(WHISPER_IMAGE_NAME):$(IMAGE_BRANCH)-$(IMAGE_HASH)
	echo $(WHISPER_IMAGE_NAME):$(IMAGE_BRANCH)
	echo $(PIPER_IMAGE_NAME):$(IMAGE_BRANCH)-$(IMAGE_HASH)
	echo $(PIPER_IMAGE_NAME):$(IMAGE_BRANCH)

whisper: whisper/Dockerfile
	cd whisper && BUILDAH_FORMAT=docker buildah bud $(BUILDAH_FLAGS) --build-arg BASE=docker.io/nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04 -t $(WHISPER_IMAGE_NAME) .
	[ "$(IMAGE_BRANCH)" != "" ] || exit 0 ; cd whisper && buildah tag $(WHISPER_IMAGE_NAME) $(WHISPER_IMAGE_NAME):$(IMAGE_BRANCH)
	[ "$(IMAGE_BRANCH)" != "" ] || exit 0 ; cd whisper && buildah tag $(WHISPER_IMAGE_NAME) $(WHISPER_IMAGE_NAME):$(IMAGE_BRANCH)-$(IMAGE_HASH)

piper: piper/GPU.Dockerfile
	cd piper && BUILDAH_FORMAT=docker buildah bud -f GPU.Dockerfile $(BUILDAH_FLAGS) --build-arg BASE=docker.io/nvidia/cuda:12.6.3-cudnn-devel-ubuntu24.04 --build-arg EXTRA_DEPENDENCIES=onnxruntime-gpu -t $(PIPER_IMAGE_NAME) .
	[ "$(IMAGE_BRANCH)" != "" ] || exit 0 ; cd piper && buildah tag $(PIPER_IMAGE_NAME) $(PIPER_IMAGE_NAME):$(IMAGE_BRANCH)
	[ "$(IMAGE_BRANCH)" != "" ] || exit 0 ; cd piper && buildah tag $(PIPER_IMAGE_NAME) $(PIPER_IMAGE_NAME):$(IMAGE_BRANCH)-$(IMAGE_HASH)
