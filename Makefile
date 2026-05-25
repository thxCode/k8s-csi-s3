# Copyright 2017 The Kubernetes Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
.PHONY: test build container push clean

PACKAGE_NAMESPACE ?= thxcode
PACKAGE_NAME ?= csi-s3-driver
PACKAGE_VERSION ?= 0.43.7
PACKAGE_ARCH ?= $(shell uname -m | sed 's/aarch64/arm64/' | sed 's/x86_64/amd64/')
PACKAGE_IMAGE_TAG ?= $(PACKAGE_NAMESPACE)/$(PACKAGE_NAME):$(PACKAGE_VERSION)
PACKAGE_TEST_IMAGE_TAG ?= $(PACKAGE_NAMESPACE)/$(PACKAGE_NAME):test

build:
	CGO_ENABLED=0 GOOS=linux go build -trimpath -a -ldflags '-extldflags "-static"' -o _output/s3driver ./cmd/s3driver
test:
	docker build -t $(PACKAGE_TEST_IMAGE_TAG) -f test/Dockerfile .
	docker run --rm --privileged -v $(PWD):/build --device /dev/fuse $(PACKAGE_TEST_IMAGE_TAG)
container:
	docker build -t $(PACKAGE_IMAGE_TAG) --platform linux/$(PACKAGE_ARCH) .
push: container
	docker push $(PACKAGE_IMAGE_TAG)
clean:
	go clean -r -x
	rm -rf _output
