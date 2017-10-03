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

REPO_GO = github.com/rapidloop/sop
REPO_URL = https://github.com//rapidloop/sop
ROCKSDB_VER = 5.8
GO = /usr/local/go/bin/go
DEP = /usr/local/go/bin/dep

default: build

v$(ROCKSDB_VER).tar.gz:
	wget https://github.com/facebook/rocksdb/archive/v$(ROCKSDB_VER).tar.gz

rocksdb-$(ROCKSDB_VER): v$(ROCKSDB_VER).tar.gz
	tar xvf v$(ROCKSDB_VER).tar.gz

rocksdb-$(ROCKSDB_VER)/librocksdb.a: rocksdb-$(ROCKSDB_VER)
	PORTABLE=1 make -j`grep -c processor /proc/cpuinfo` -C rocksdb-$(ROCKSDB_VER) static_lib

src:
	mkdir src
	git clone $(REPO_URL) src/$(REPO_GO)

deps: src
	export GOPATH=`pwd`; cd src/$(REPO_GO); $(DEP) ensure -v -vendor-only

build: rocksdb-$(ROCKSDB_VER)/librocksdb.a deps
	GOPATH=`pwd` CGO_CFLAGS="-I`pwd`/rocksdb-$(ROCKSDB_VER)/include" \
	       CGO_LDFLAGS="-L`pwd`/rocksdb-$(ROCKSDB_VER) -lrocksdb -lstdc++ -lm -lz -lbz2 -lsnappy -llz4 -lzstd" \
	       $(GO) install -v --ldflags '-extldflags "-static"' $(REPO_GO)/...

clean:
	rm -rf bin pkg

clobber: clean
	rm -rf src rocksdb-$(ROCKSDB_VER) v$(ROCKSDB_VER).tar.gz

image:
	rm -rf sop
	mkdir sop
	cp Dockerfile Makefile install-build-deps.bash sop
	sudo docker build --tag sop:latest sop

