#!/bin/bash -eu

su -c "vncserver -depth ${VNC_DEPTH} -geometry ${VNC_GEOMETRY} -rfbport ${VNC_PORT} :${VNC_DISPLAY}" vnc
gosu ${VNC_USER} /bin/bash -c "calibre-server --auto-reload --with-library ${CALIBRE_LIBRARY} --max-cover ${VNC_MAXCOVER} --user ${CALIBRE_USER} --password ${CALIBRE_PASSWORD} --port ${CALIBRE_PORT}"
