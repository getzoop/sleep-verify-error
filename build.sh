#!/usr/bin/env bash

# Just build a new docker image when it does't exist
if [[ "$(sudo docker images -q getzoop/zooppos:0.1 2> /dev/null)" == "" ]]; then
  sudo docker build -t getzoop/zooppos:0.1 .
fi

rm -rf ./pkg; mkdir -p ./pkg
# add selinux rule to the build artifacts directory
if [[ "$(getenforce)" == "Enforcing" ]]; then
  chcon -Rt svirt_sandbox_file_t $(pwd)/pkg
  chcon -Rt svirt_sandbox_file_t $(pwd)/third_party/toolchain
fi
# Run the builder container
sudo docker run -v $(pwd)/pkg:/app/pkg -v $(pwd)/third_party/toolchain:/app/third_party/toolchain -it --rm --name zooppos-build getzoop/zooppos:0.1

echo Done.
echo The package is on ./pkg directory
