#!/bin/bash

# Copyright 2017 RapidLoop, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -eEo pipefail
trap 'exit 1' ERR

GOVER=1.9
GODEPVER=v0.3.1

# Note: This currently works / has been tested only on Debian 9.
# Ideally, it should detect the platform and install the appropriate
# packages using platform-specific commands.

if [ ! -f /etc/debian_version ]; then
	echo "This script currently works only on Debian. Patches welcome!"
	exit 1
fi

apt-get -yq update

# install deps available via standard apt
apt-get -yq install gcc g++ make libgflags-dev libsnappy-dev \
	zlib1g-dev libbz2-dev liblz4-dev libzstd-dev git wget

# install go
rm -f /tmp/go.tar.gz
wget --no-verbose -t 3 -T 30 -O /tmp/go.tar.gz \
	https://storage.googleapis.com/golang/go${GOVER}.linux-amd64.tar.gz
tar xvf /tmp/go.tar.gz -C /usr/local
rm /tmp/go.tar.gz

# install go dep
rm -f dep-linux-amd64
wget --no-verbose -t 3 -T 30 \
	https://github.com/golang/dep/releases/download/${GODEPVER}/dep-linux-amd64
chmod +x dep-linux-amd64
mv dep-linux-amd64 /usr/local/go/bin/dep

exit 0

