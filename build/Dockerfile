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

ENV COMMONPACKAGE='locate locales bash logrotate supervisor git curl wget ca-certificates' \
    LUBUNTUPACKAGE='xorg lxde-core lxappearance lxterminal lubuntu-icon-theme lubuntu-artwork-16-04 lubuntu-lxpanel-icons lubuntu-artwork xfonts-100dpi xfonts-100dpi-transcoded xfonts-75dpi xfonts-75dpi-transcoded xfonts-base'

ENV LANG=C.UTF-8 \
    PORT=22 \
#   PATH=${CALIBRE_BASE}/bin:$PATH \
    WORK_DIR=/

# apt-get install
RUN apt-get update && apt-get -y upgrade && DEBIAN_FRONTEND=nointeractive apt-get install -y ${LUBUNTUPACKAGE} ${COMMONPACKAGE} && \
    echo "inst"

#    RUN apt-get update && apt-get -y upgrade && \
#        apt-get install -y wget language-pack-ja && \
#        update-locale LANG=${LANGUAGE}

# entrykit install
RUN wget -q --no-check-certificate ${ENTRYKIT_DOWNLOAD} -O- | tar zx && \
    chmod +x /entrykit && mv /entrykit /usr/bin && /usr/bin/entrykit --symlink

# gosu
RUN wget -q --no-check-certificate ${GOSU_DOWNLOAD} -O /usr/bin/gosu && chmod +x /usr/bin/gosu

#----- vnc -----

RUN apt-get install -y openssh-server tightvncserver

ENV VNC_PORT="${VNC_PORT:-5901}" \
    VNC_PASSWORD="${VNC_PASSWORD:-0qwertyuiop}" \
    VNC_DEPTH="${VNC_DEPTH:-24}" \
    VNC_DISPLAY="${VNC_DISPLAY:-1}" \
    VNC_GEOMETRY="${VNC_GEOMETRY:-1280x768}"

ENV VNC_OPTIONS="-depth ${VNC_DEPTH} -geometry ${VNC_GEOMETRY}  -rfbport ${VNC_PORT} :${VNC_DISPLAY}"
RUN useradd -m -U -s /bin/bash vnc && \
    echo "vnc ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    chown -R vnc:vnc /home/vnc

RUN su vnc -c " mkdir /home/vnc/.vnc " && \
    su vnc -c "echo 'hoge' | vncpasswd -f > /home/vnc/.vnc/passwd" && \
    su vnc -c "chmod 600 /home/vnc/.vnc/passwd"


#------ calibre ------

ENV CALIBRE_LIBRARY=/calibre_library \
    CALIBRE_URL=https://raw.githubusercontent.com/kovidgoyal/calibre/master/setup/linux-installer.py
ENV USER=vnc \
    PASSWORD=vncpass \
    MAX_COVER=300x400

ENV CALIBREPACKAGE='python-pip python-dev build-exxential openssh-client poppler mesa-gl xdg-utils imagemagick' \
    PIPPACKAGE='dateutil pil pyqt pygments' \
    BUILD_PACKAGE='wget git build-base linux-headers' \
    VNCPORT=5901-5999

RUN apt-get install -y  ${CALIBREPACKAGE} && pip install -y ${PIPPACKAGE}

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
