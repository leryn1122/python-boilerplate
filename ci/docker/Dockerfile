FROM python:3.11-alpine AS build

ARG MIRRORS_SOURCE="dl-cdn.alpinelinux.org"
ARG PYPI_SOURCE="pypi.org"

RUN sed -i "s/dl-cdn.alpinelinux.org/${MIRRORS_SOURCE}/g" /etc/apk/repositories \
 && apk add --update --no-cache \
      binutils \
      bash \
      git \
      make \
      zlib \
 && pip3 install pipenv

WORKDIR /tmp/project

ADD . /tmp/project

RUN sed -i "s/pypi.org/${PYPI_SOURCE}/g" Pipfile \
 && sed -i "s/pypi.org/${PYPI_SOURCE}/g" Pipfile.lock \
 && make install

RUN make build

FROM alpine:3.18 AS runtime

LABEL maintainers="Leryn <leryn1122@gmail.com>"
LABEL description="helloworld"

ARG MIRRORS_SOURCE="dl-cdn.alpinelinux.org"

RUN sed -i "s/dl-cdn.alpinelinux.org/${MIRRORS_SOURCE}/g" /etc/apk/repositories \
 && apk add --update --no-cache \
      bash

COPY --from=build /tmp/project/dist/binary /usr/local/bin/binary

WORKDIR /tmp

ENTRYPOINT [ "/usr/local/bin/binary" ]
