#!/bin/bash

# vnc setting
ENV VNC_USER=vnc \
    VNC_PASSWORD=vnc \
    VNC_DISPLAY=vnc \
ENV VNC_HOME=/home/${VNC_USER}

RUN echo "${VNC_USER} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    useradd --create-home --user-group  -s /usr/bin/bash ${VNC_USER} && \
    chown -R ${VNC_USER}:${VNC_USER} ${VNC_HOME}
