FROM innovanon/xorg-base:latest as builder-01
USER root
COPY --from=innovanon/freetype    /tmp/freetype2.txz   /tmp/
RUN extract.sh

# TODO
RUN sleep 91 && apt update && apt full-upgrade && apt install gperf

ARG LFS=/mnt/lfs
WORKDIR $LFS/sources
USER lfs
RUN env
RUN sleep 31                                                                                 \
 && git clone --depth=1 --recursive https://gitlab.freedesktop.org/fontconfig/fontconfig.git \
 && cd                                                                        fontconfig     \
 && ./autogen.sh                                                                             \
 && rm -f src/fcobjshash.h                                                                   \
 && ./configure --prefix=/usr/local --disable-docs --disable-shared --enable-static          \
 && make                                                                                     \
 && make DESTDIR=/tmp/fontconfig install                                                     \
 && rm -rf                                                                    fontconfig     \
 && cd           /tmp/fontconfig                                                             \
 && strip.sh .                                                                               \
 && tar  pacf      ../fontconfig.txz .                                                       \
 && cd ..                                                                                    \
 && rm -rf       /tmp/fontconfig || { env ; ls -ltra /usr/local/lib ; exit 2 ; }

FROM scratch as final
COPY --from=builder-01 /tmp/fontconfig.txz /tmp/

