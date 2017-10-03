These are build scripts for github.com/rapidloop/sop.

There are various ways to build sop:

**1. Using the Makefile in the sop-build repo:**

```
$ git clone https://github.com/rapidloop/sop-build
$ cd sop-build
$ sudo bash install-build-deps.bash
$ make
```

The install-build-deps.bash installs (1) RocksDB build dependencies,
(2) Go, and (3) [dep](https://github.com/golang/dep). The Makefile will
download and compile RockDB, then fetch sop's Go dependencies and then build
sop itself.

The final sop binary is statically linked.

The scripts assume they're running on Debian, and have been tested on
only on Debian 9 so far. Note that the final binary should work on other
distros and versions.

**2. Using "go get":**

You can `go get github.com/rapidloop/sop`, iff:

1. github.com/tecbot/gorockdb has been "go install"-ed.
2. The git repo $GOPATH/github.com/prometheus/prometheus is checked out on
   the branch "dev-2.0".

This should work on Linux and MacOS. For MacOS, you can "brew install rocksdb"
to get a recent version of RocksDB.

**3. Build as a Docker image:**

Use `make image` from the Makefile to do a
[multi-stage](https://docs.docker.com/engine/userguide/eng-image/multistage-build/)
Docker build and create an image. Currently there is no official Docker image
for sop. You can/should modify the Dockerfile to include a custom sop.cfg file
and create your custom Docker images.

