## Buildstage ##
FROM ghcr.io/linuxserver/baseimage-alpine:3.13 as buildstage

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache bash git curl automake autoconf libtool pkgconf gcc g++ popt-dev libidn-dev make file

RUN \
 echo "**** clone echoping ****" && \
 git clone -b docker-alpine 'https://github.com/na4ma4/echoping.git' /build

WORKDIR /build/SRC

RUN \
 echo "**** build echoping ****" && \
 ./recreate-autofiles && \
 CFLAGS="-fcommon" ./configure --enable-static --prefix=/root-layer/usr/local && \
 mkdir -p /root-layer && \
 make install

## Single layer deployed image ##
FROM scratch

# Add files from buildstage
COPY --from=buildstage /root-layer/ /
