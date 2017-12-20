FROM golang:1.9-alpine

RUN apk update && apk add \
	make \
	git \
	protobuf \
	protobuf-dev \
	openssh \
	rsync

ENV INCLUDE=.:/usr/include

RUN go get github.com/golang/protobuf/protoc-gen-go
