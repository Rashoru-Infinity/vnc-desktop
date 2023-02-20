FROM ubuntu:jammy-20230126

LABEL maintainer "rashoru-infinity <65536toaru@gmail.com>"

ENV WALLPAPERURL="https://images.pexels.com/photos/13586724/pexels-photo-13586724.jpeg?cs=srgb&dl=pexels-david-n-13586724.jpg&fm=jpg&w=1920&h=1399"
ENV USERNAME user
ENV GROUPNAME user
ENV PASSWORD default
ENV DISPLAY :0

# setup desktop environment
RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates \
    curl \
    gosu \
    sudo \
    libxv1 \
    libegl1-mesa \
    libglu1-mesa \
    libxtst6 \
    libxkbfile1 \
    xkb-data \
    python3 \
    libxmuu1 \
    xauth \
    x11-xkb-utils \
    lxde \
    xvfb \
    && curl -OL https://jaist.dl.sourceforge.net/project/virtualgl/3.0.2/virtualgl_3.0.2_amd64.deb \
    && curl -OL https://jaist.dl.sourceforge.net/project/turbovnc/3.0.2/turbovnc_3.0.2_amd64.deb \
    && dpkg -i ./virtualgl_3.0.2_amd64.deb \
    && dpkg -i ./turbovnc_3.0.2_amd64.deb \
    && vglserver_config +glx -s -f -t \
    && rm -rf *.deb \
    /var/lib/apt/lists/* \
    /var/cache/apt/archives/*

# install firefox
RUN apt-get update \
    && apt-get install -y --no-install-recommends gpg-agent \
    software-properties-common \
    && DEBIAN_FRONTEND=noninteractive add-apt-repository ppa:mozillateam/ppa \
    && apt-get install -y firefox-esr \
    fonts-ipafont \
    && rm -rf /var/lib/apt/lists/* \
    /var/cache/apt/archives/*

COPY desktop-items-0.conf /opt/
COPY start.sh /

CMD ["bash", "start.sh"]