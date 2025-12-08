#!/usr/bin/bash
set -euxo pipefail

cd /tmp/build-scripts

BUILD_SCRIPTS=(
  ./00-base.sh
  ./10-extras.sh
  ./20-setup-periphery.sh
)

for script in "${BUILD_SCRIPTS[@]}"; do
  "${script}"
done
