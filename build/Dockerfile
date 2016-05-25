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

ENV COMMONPACKAGE='locales bash logrotate supervisor git bzip2 curl wget ca-certificates' \
    LUBUNTUPACKAGE='xorg lxde-core lxappearance lxterminal lubuntu-icon-theme lubuntu-artwork-16-04 lubuntu-lxpanel-icons lubuntu-artwork xfonts-100dpi xfonts-100dpi-transcoded xfonts-75dpi xfonts-75dpi-transcoded xfonts-base' \
    FONTPACKAGE='fonts-noto-cjk fonts-takao-mincho fonts-takao-gothic fonts-takao-pgothic fonts-stix' \
    FCITXPACKAGE='fcitx fcitx-mozc fcitx-libs-qt5 fcitx-frontend-qt5'

# apt-get install
RUN apt-get update && apt-get -y upgrade
RUN DEBIAN_FRONTEND=nointeractive apt-get install -y ${LUBUNTUPACKAGE}
RUN DEBIAN_FRONTEND=nointeractive apt-get install -y ${COMMONPACKAGE}
#RUN DEBIAN_FRONTEND=nointeractive apt-get install -y ${FONTPACKAGE}
#RUN DEBIAN_FRONTEND=nointeractive apt-get install -y ${FCITXPACKAGE}
RUN apt-get install -y wget language-pack-ja && \
    update-locale LANG=${LANGUAGE:-ja_JP.UTF-8}

#    RUN apt-get update && apt-get -y upgrade && \

# entrykit install
RUN wget -q --no-check-certificate ${ENTRYKIT_DOWNLOAD} -O- | tar zx && \
    chmod +x /entrykit && mv /entrykit /usr/bin && /usr/bin/entrykit --symlink

# gosu
RUN wget -q --no-check-certificate ${GOSU_DOWNLOAD} -O /usr/bin/gosu && chmod +x /usr/bin/gosu

#----- vnc -----

COPY install_vnc /tmp/install_vnc
RUN /bin/bash /tmp/install_vnc

#------ calibre ------

ENV CALIBRE_LIBRARY=/calibre_library \
    CALIBRE_URL=https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py
ENV USER=vnc \
    PASSWORD=vncpass \
    MAX_COVER=300x400

#openssh-client poppler mesa-gl xdg-utils
ENV CALIBREPACKAGE='python-pip python-dev build-essential imagemagick' \
    PIPPACKAGE='dateutil pil pyqt pygments' \
    BUILD_PACKAGE='wget git build-base linux-headers' \
    VNCPORT=5901-5999

RUN apt-get install -y  ${CALIBREPACKAGE}
#&& pip install -U ${PIPPACKAGE}

# calibre install
RUN wget -q --no-check-certificate ${CALIBRE_URL} -O- | python -c "import sys; main=lambda:sys.stderr.write('Download Failed\n'); exec(sys.stdin.read()); main()"

# calibre setup
RUN mkdir ${CALIBRE_LIBRARY} && mkdir ${CALIBRE_LIBRARY}/import

# remove build package
#RUN apt-get autoremove -y python-dev build-essential && rm -rf /tmp/* /var/cache/apk/*

EXPOSE ${PORT} ${VNCPORT}

WORKDIR ${WORK_DIR}
#ENTRYPOINT ["switch","shell=/bin/bash","--","calibre-server","--auto-reload","--with-library","${CALIBRE_LIBRARY}","--username","${USER}","--password","${PASSWORD}","--max-cover","${MAX_COVER}","--port","${PORT}"]
CMD ["bash"]
