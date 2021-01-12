FROM innovanon/xorg-base:latest as builder-01
COPY --from=innovanon/freetype    /tmp/freetype2.txz   /tmp/
RUN cat   /tmp/*.txz  \
  | tar Jxf - -i -C / \
 && rm -v /tmp/*.txz

# TODO
RUN apt update && apt full-upgrade && apt install gperf

ARG LFS=/mnt/lfs
WORKDIR $LFS/sources
USER lfs
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
 && tar acf        ../fontconfig.txz .                                                       \
 && cd ..                                                                                    \
 && rm -rf       /tmp/fontconfig

