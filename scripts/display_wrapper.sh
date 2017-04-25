#!/bin/bash

# Sets VNC_GEOMETRY
. /etc/JARVICE/vglinfo.sh

# Display an image with dimensions of the desktop
display -geometry $VNC_GEOMETRY -resize $VNC_GEOMETRY -size $VNC_GEOMETRY $@
