FROM ubuntu
MAINTAINER Brandon R. Stoner <monokrome@monokro.me>

ENV DEBIAN_FRONTEND noninteractive
ENV HOME /root

# RUN dpkg --add-architecture i386
# no Upstart or DBus
# https://github.com/dotcloud/docker/issues/1724#issuecomment-26294856
RUN apt-mark hold initscripts udev plymouth mountall
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -sf /bin/true /sbin/initctl

RUN apt-get update -y
RUN apt-get install -y software-properties-common && add-apt-repository -y ppa:ubuntu-wine/ppa
RUN apt-get update -y
RUN apt-get install -y wine1.7 winetricks xvfb

RUN apt-get install -y --force-yes --no-install-recommends supervisor \
        openssh-server pwgen sudo vim-tiny \
        net-tools \
        lxde x11vnc \
        firefox \
    && apt-get autoclean -y \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

ADD noVNC /noVNC/

ADD startup.sh /
ADD supervisord.conf /
EXPOSE 6080
EXPOSE 5900
EXPOSE 22
WORKDIR /
ENTRYPOINT ["/startup.sh"]
