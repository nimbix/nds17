# Nimbix Developer Summit 2017
# https://github.com/nimbix/nds17-pushtocompute-workshop
#
# Dockerfile

# We recommend to inherit from NIMBIX or NVIDIA docker base images, but it is
# not required. You can import any docker image into JARVICE.
#
# Images are available on DockerHub: https://hub.docker.com/u/nimbix/
#  * nimbix/ubuntu-base
#  * nimbix/ubuntu-desktop
#  * nimbix/ubuntu-cuda
#  * nimbix/base-ubuntu-nvidia
#  * jarvice/ubuntu-ibm-mldl-ppc64le (for IBM POWER machines)
# https://hub.docker.com/u/nvidia/
# For NVIDIA base images, please use:
# * nimbix/base-ubuntu-nvidia and associated tags, or follow this pattern
FROM jarvice/base-nds17

# Perform build steps as root
USER root

# Install an application to display an image
# NB: apt-get clean is an image layer size optimization
RUN apt-get update && \
    apt-get install -y pinta curl && \
    apt-get clean

# AppDef.json defines the workflow in the portal. See the JARVICE
# Application Definition Guide:
# * https://www.nimbix.net/jarvice-application-deployment-guide/
COPY ./NAE/AppDef.json /etc/NAE/AppDef.json

# Validate the AppDef - if it is invalid, the build will fail
# You don't have to do this, but it helps prevent mistakes
RUN curl --fail -X POST "https://api.jarvice.com/jarvice/validate" -d@/etc/NAE/AppDef.json

# Provides a preview screenshot in the application catalog
COPY ./NAE/screenshot.png /etc/NAE/screenshot.png

# This is an entrypoint wrapper script, which will be referenced in AppDef.json as the command
COPY ./scripts/stylize.sh /usr/local/scripts/stylize.sh

COPY ./styles/starry_night.png /usr/local/styles/starry_night.png
COPY ./styles/picasso.png /usr/local/styles/picasso.png
COPY ./styles/jarvice.png /usr/local/styles/jarvice.png

USER nimbix
