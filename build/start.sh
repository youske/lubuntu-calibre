#!/bin/bash -eu

gosu vnc bash -c "vncserver ${VNC_OPTIONS} && tail -f /dev/null"
