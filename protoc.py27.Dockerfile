FROM python:2.7-alpine3.6

RUN apk update && apk add \
    build-base \
    linux-headers \
    make \
    git \
    protobuf \
    protobuf-dev \
    openssh \
    rsync

ENV INCLUDE=.:/usr/include

RUN pip install grpcio-tools
