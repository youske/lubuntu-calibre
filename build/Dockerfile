# Lubuntu Linux with calibre
# ubuntu:16.04

FROM ubuntu:16.04
MAINTAINER youske miyakoshi <youske@gmail.com>

LABEL com.geeplus.description="lubuntu calibre image" \
      com.geeplus.role="calibreimage"

#----- common -----

# entrykit
ENV ENTRYKIT_VERSION=0.4.0
ENV ENTRYKIT_FILE=entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz
ENV ENTRYKIT_DOWNLOAD=https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/${ENTRYKIT_FILE}

ENV GOSU_VERSION=1.7
ENV GOSU_DOWNLOAD=https://github.com/tianon/gosu/releases/download/${GOSU_VERSION}/gosu-amd64

ENV LANG=C.UTF-8 \
    PORT=22 \
    WORK_DIR=/

ENV COMMONPACKAGE='locales bash vim-tiny logrotate supervisor git bzip2 curl wget ca-certificates' \
    LUBUNTUPACKAGE='xorg xterm lxde-core lxappearance lxsession-data lxterminal lxinput lubuntu-icon-theme lubuntu-artwork-16-04 lubuntu-lxpanel-icons lubuntu-artwork xfonts-100dpi xfonts-100dpi-transcoded xfonts-75dpi xfonts-75dpi-transcoded xfonts-base ' \
    FONTPACKAGE='fonts-ipafont-mincho fonts-ipafont-gothic' \
    LANGPACKAGE='language-pack-ja language-pack-ja ibus-mozc'

# apt-get install
RUN apt-get update && apt-get -y upgrade
RUN DEBIAN_FRONTEND=nointeractive apt-get install -y ${LUBUNTUPACKAGE}
RUN DEBIAN_FRONTEND=nointeractive apt-get install -y ${COMMONPACKAGE}
RUN DEBIAN_FRONTEND=nointeractive apt-get install -y ${FONTPACKAGE}
RUN DEBIAN_FRONTEND=nointeractive apt-get install -y ${LANGPACKAGE}
RUN update-locale LANG=${LANGUAGE:-ja_JP.UTF-8}

#    RUN apt-get update && apt-get -y upgrade && \

# entrykit install
RUN wget -q --no-check-certificate ${ENTRYKIT_DOWNLOAD} -O- | tar zx && \
    chmod +x /entrykit && mv /entrykit /usr/bin && /usr/bin/entrykit --symlink

# gosu
RUN wget -q --no-check-certificate ${GOSU_DOWNLOAD} -O /usr/bin/gosu && chmod +x /usr/bin/gosu

#------ calibre ------

ENV CALIBRE_LIBRARY=/calibre_library \
    CALIBRE_URL=https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py
ENV USER=vnc \
    PASSWORD=vncpass \
    MAX_COVER=300x400

ENV CALIBREPACKAGE='imagemagick python-pip python-dev build-essential' \
    PIPPACKAGE='dateutil pil pyqt pygments' \
    BUILD_PACKAGE='wget git build-base linux-headers' \
    VNCPORT=5901-5999

RUN apt-get install -y  ${CALIBREPACKAGE}
#&& pip install -U ${PIPPACKAGE}

# calibre install
RUN wget -q --no-check-certificate ${CALIBRE_URL} -O- | python -c "import sys; main=lambda:sys.stderr.write('Download Failed\n'); exec(sys.stdin.read()); main()"

# calibre setup
RUN mkdir ${CALIBRE_LIBRARY} && mkdir ${CALIBRE_LIBRARY}/import

#----- vnc -----

ENV VNC_USER="${VNC_USER:-vnc}" \
    VNC_PASSWORD="${VNC_PASSWORD:-vncpass}" \
    VNC_PORT="${VNC_PORT:-5901}" \
    VNC_DEPTH="${VNC_DEPTH:-24}" \
    VNC_DISPLAY="${VNC_DISPLAY:-1}" \
    VNC_GEOMETRY="${VNC_GEOMETRY:-1280x768}"

ENV VNC_OPTIONS="-depth ${VNC_DEPTH} -geometry ${VNC_GEOMETRY}  -rfbport ${VNC_PORT} :${VNC_DISPLAY}" \
    VNC_HOME="/home/${VNC_USER}"

COPY install_vnc /tmp/install_vnc
RUN . /tmp/install_vnc

# remove build package
#RUN apt-get autoremove -y python-dev build-essential && rm -rf /tmp/* /var/cache/apk/*

COPY start.sh /tmp/start.sh
EXPOSE ${PORT} ${VNCPORT}

#USER vnc
WORKDIR ${WORK_DIR}
ENTRYPOINT ["switch","shell=/bin/bash","--","bash","/tmp/start.sh"]
#CMD ["bash"]
