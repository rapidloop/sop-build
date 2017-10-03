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

FROM debian:stretch-slim AS builder

RUN mkdir /build
COPY install-build-deps.bash /build
COPY Makefile /build
WORKDIR /build

RUN apt-get update
RUN /bin/bash install-build-deps.bash
RUN /usr/bin/make

FROM alpine:3.6
COPY --from=builder /build/bin/sop /sop
ENTRYPOINT ["/sop"]
EXPOSE 9095 9096
