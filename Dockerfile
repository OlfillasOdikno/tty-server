FROM golang:alpine as builder

ARG build_deps="make dep npm git"

COPY . /go/src/github.com/elisescu/tty-server

RUN apk update && \
    apk add -u $build_deps && \
    cd /go/src/github.com/elisescu/tty-server && \
    GOPATH=/go dep ensure && \
    GOPATH=/go CGO_ENABLED=0 GOOS=linux make all
    

FROM scratch as base

ENV TTY_SERVER_URL=http://localhost:5000

COPY --from=builder /go/src/github.com/elisescu/tty-server/tty-server /tty-server

EXPOSE 5000
EXPOSE 6543

ENTRYPOINT [ "/tty-server" ]
CMD [ "-web_address", ":5000", "--sender_address", ":6543" ]