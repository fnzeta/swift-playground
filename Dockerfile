FROM swift:4.2 as builder
ARG env
RUN apt-get -qq update && apt-get -q -y install \
  tzdata \
  && rm -r /var/lib/apt/lists/*

WORKDIR /playground
COPY . .
RUN swift build -c release && mv `swift build -c release --show-bin-path` /build/bin


FROM swift:4.2
ARG env
WORKDIR /playground
COPY --from=builder /build/bin/Playground .
ENV ENVIRONMENT=$env
ENTRYPOINT ./Playground serve --env $ENVIRONMENT --hostname 0.0.0.0 --port 80