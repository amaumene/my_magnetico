FROM golang:alpine AS builder

ENV CGO_ENABLED=0
ENV CGO_CFLAGS=-D_LARGEFILE64_SOURCE
ENV CC=clang

WORKDIR /workspace

RUN apk add --no-cache clang lld libsodium-dev zeromq-dev czmq-dev git

RUN git clone https://github.com/tgragnato/magnetico .

RUN rm go.mod && rm go.sum && go mod init tgragnato.it/magnetico && go mod tidy && go build --tags fts5 .

FROM gcr.io/distroless/base

WORKDIR /tmp

COPY --from=builder /workspace/magnetico /usr/bin/

ENTRYPOINT ["/usr/bin/magnetico", "$@", "--daemon" ]
