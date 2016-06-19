# Lubuntu Linux with calibre
# ubuntu:16.04

FROM ubuntu:16.04
MAINTAINER youske miyakoshi <youske@gmail.com>

LABEL com.geeplus.description="lubuntu calibre image" \
      com.geeplus.role="calibre"

#----- common -----

# s6-overlay
ENV S6OVERLAY_VERSION="v1.11.0.1"
ENV S6OVERLAY_URL="https://github.com/just-containers/s6-overlay/releases/download/${S6OVERLAY_VERSION}/s6-overlay-amd64.tar.gz"

ADD ${S6OVERLAY_URL} /tmp/

# entrykit
ENV ENTRYKIT_VERSION=0.4.0
ENV ENTRYKIT_FILE=entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
ENV ENTRYKIT_DOWNLOAD=https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/${ENTRYKIT_FILE}

ENV GOSU_VERSION=1.7
ENV GOSU_DOWNLOAD=https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64

ENV COMMONPACKAGE='bash vim-tiny logrotate supervisor git bzip2 curl wget ca-certificates' \
    LUBUNTUPACKAGE='xorg xterm lxde-core lxappearance lxsession-data lxterminal lxinput lubuntu-icon-theme lubuntu-artwork-16-04 lubuntu-lxpanel-icons lubuntu-artwork xfonts-100dpi xfonts-100dpi-transcoded xfonts-75dpi xfonts-75dpi-transcoded xfonts-base ' \
    FONTPACKAGE='fonts-ipafont-mincho fonts-ipafont-gothic' \
    LANGPACKAGE='locales language-pack-ja language-pack-ja ibus-mozc'

# apt-get install
RUN apt-get update && apt-get -y upgrade && \
    DEBIAN_FRONTEND=nointeractive apt-get install -y ${COMMONPACKAGE} ${LUBUNTUPACKAGE} ${FONTPACKAGE} ${LANGPACKAGE} && \
    update-locale LANG=${LANGUAGE:-ja_JP.UTF-8}

# entrykit install
RUN wget -q --no-check-certificate ${ENTRYKIT_DOWNLOAD} -O- | tar zx && \
    chmod +x /entrykit && mv /entrykit /usr/bin && /usr/bin/entrykit --symlink

# gosu
RUN wget -q --no-check-certificate ${GOSU_DOWNLOAD} -O /usr/bin/gosu && chmod +x /usr/bin/gosu

# s6-overlay
RUN tar zxf /tmp/s6-overlay-amd64.tar.gz -C /


#------ calibre ------

ENV CALIBRE_USER='calibre' \
    CALIBRE_PASSWORD='calibreadmin' \
    CALIBRE_MAXCOVER="300x280" \
    CALIBRE_PORT=8088 \
    CALIBRE_LIBRARY="/Calibre_Library" \
    CALIBRE_URL=https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py \
    CALIBRE_PACKAGE='imagemagick python-pip python-dev build-essential'

# calibre install
RUN apt-get install -y  ${CALIBRE_PACKAGE} && \
    wget -q --no-check-certificate ${CALIBRE_URL} -O- | python -c "import sys; main=lambda:sys.stderr.write('Download Failed\n'); exec(sys.stdin.read()); main()"
RUN mkdir -p "${CALIBRE_LIBRARY}" && mkdir -p "${CALIBRE_LIBRARY}/import" && \
    chown -R ${VNC_USER}:${VNC_USER} "${CALIBRE_LIBRARY}"

#----- vnc -----

ENV VNC_USER="${VNC_USER:-vnc}" \
    VNC_PASSWORD="${VNC_PASSWORD:-vncpass}" \
    VNC_PORT="${VNC_PORT:-5901}" \
    VNC_DEPTH="${VNC_DEPTH:-24}" \
    VNC_DISPLAY="${VNC_DISPLAY:-1}" \
    VNC_GEOMETRY="${VNC_GEOMETRY:-1280x800}"

ENV VNC_HOME="/home/${VNC_USER}"

COPY install_vnc /tmp/install_vnc
RUN . /tmp/install_vnc
COPY start.sh ${VNC_HOME}/start.sh
RUN chmod +x ${VNC_HOME}/start.sh && chown -R ${VNC_USER}:${VNC_USER} ${VNC_HOME}

#
COPY xstartup ${VNC_HOME}/.vnc/
RUN chmod +x ${VNC_HOME}/.vnc/xstartup

# remove build package
RUN apt-get autoremove -y python-dev build-essential && rm -rf /tmp/* /var/cache/apk/*


EXPOSE ${CALIBRE_PORT} ${VNC_PORT}
WORKDIR ${VNC_HOME}
ENTRYPOINT ["switch","shell=/bin/bash","--","/init"]
CMD ["gosu","vnc","vncserver",":${VNC_DISPLAY}","-fg","-geometry","${VNC_GEOMETRY}"]
