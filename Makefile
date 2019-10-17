
PROGRAM_NAME := $(shell basename `git rev-parse --show-toplevel`)

GIT_BRANCH := $(shell git rev-parse --abbrev-ref HEAD)
GIT_REPOSITORY_NAME := $(shell basename `git rev-parse --show-toplevel`)
GIT_SHA := $(shell git log --pretty=format:'%H' -n 1)
GIT_TAG ?= $(shell git describe --always --tags | awk -F "-" '{print $$1}')
GIT_TAG_END ?= HEAD
GIT_VERSION := $(shell git describe --always --tags --long --dirty | sed -e 's/\-0//' -e 's/\-g.......//')
GIT_VERSION_LONG := $(shell git describe --always --tags --long --dirty)

TARGET_DIRECTORY := ./target
PARENT_DIR := ../../
xPARENT_TARGET := $(PARENT_DIR)/target
DOCKER_CONTAINER_NAME := $(PROGRAM_NAME)
DOCKER_IMAGE_NAME := local/$(DOCKER_CONTAINER_NAME)

BUILD_VERSION := $(shell git describe --always --tags --abbrev=0 --dirty)
BUILD_TAG := $(shell git describe --always --tags --abbrev=0)
BUILD_ITERATION := $(shell git log $(BUILD_TAG)..HEAD --oneline | wc -l)

# The first "make" target runs as default.
.PHONY: default
default: help

.PHONY: build
build:
	
	docker build \
	  --build-arg PROGRAM_NAME=$(PROGRAM_NAME) \
	  --build-arg BUILD_VERSION=$(BUILD_VERSION) \
	  --build-arg BUILD_ITERATION=$(BUILD_ITERATION) \
	  --tag $(DOCKER_IMAGE_NAME) \
	  .

	mkdir -p $(TARGET_DIRECTORY) || true
	docker rm --force $(DOCKER_CONTAINER_NAME) || true
	
	# Extract files from docker image into "./target" directory
	docker create \
	  --name $(DOCKER_CONTAINER_NAME) \
	  $(DOCKER_IMAGE_NAME)
	docker cp $(DOCKER_CONTAINER_NAME):/output/. $(TARGET_DIRECTORY)

	# Cleanup
	docker rm  --force $(DOCKER_CONTAINER_NAME) || true	


.PHONY: clean
clean:
	docker rm --force $(DOCKER_CONTAINER_NAME) || true
	rm -rf $(TARGET_DIRECTORY)


.PHONY: help
help:
	@echo "Build $(PROGRAM_NAME) version $(BUILD_VERSION)-$(BUILD_ITERATION)".
	@echo "To build, run 'sudo make build'"
	@echo "All targets:"
	@$(MAKE) -pRrq -f $(lastword $(MAKEFILE_LIST)) : 2>/dev/null | awk -v RS= -F: '/^# File/,/^# Finished Make data base/ {if ($$1 !~ "^[#.]") {print $$1}}' | sort | egrep -v -e '^[^[:alnum:]]' -e '^$@$$' | xargs