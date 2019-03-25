FROM swift:4.2 as builder
ARG env
RUN apt-get -qq update && apt-get -q -y install \
  tzdata \
  && rm -r /var/lib/apt/lists/*

WORKDIR /playground
COPY . .
RUN mkdir -p /build/lib && cp -R /usr/lib/swift/linux/*.so /build/lib
RUN swift build -c release && mv `swift build -c release --show-bin-path` /build/bin


FROM ubuntu:16.04
ARG env
RUN apt-get -qq update && apt-get install -y \
  libicu55 libxml2 libbsd0 libcurl3 libatomic1 \
  tzdata \
  && rm -r /var/lib/apt/lists/*
WORKDIR /playground
COPY --from=builder /build/bin/Playground .
COPY --from=builder /build/lib/* /usr/lib/

ENV ENVIRONMENT=$env
ENTRYPOINT ./Playground serve --env $ENVIRONMENT --hostname 0.0.0.0 --port 80