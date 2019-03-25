# FROM swift:4.2 as builder
# ARG env
# RUN apt-get -qq update && apt-get -q -y install \
#   tzdata \
#   && rm -r /var/lib/apt/lists/*

# WORKDIR /playground
# COPY . .
# RUN mkdir -p /build/lib
# RUN swift build -c release && mv `swift build -c release --show-bin-path` /build/bin


# FROM swift:4.2
# WORKDIR /playground
# COPY --from=builder /build/bin/Playground .
# ENTRYPOINT ./Playground serve --env prod --hostname 0.0.0.0 --port 80

FROM swift
WORKDIR /app
ADD . ./
RUN swift package clean
RUN swift build -c release
RUN mkdir /app/bin
RUN mv `swift build -c release --show-bin-path` /app/bin
EXPOSE 8080
ENTRYPOINT ./bin/release/Playground serve -e prod -b 0.0.0.0