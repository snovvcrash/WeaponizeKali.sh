# Author: Charlie BROMBERG (Shutdown - @_nwodtuhs)

FROM kalilinux/kali-rolling

# version
ARG TAG="local"
ARG VERSION="local"
ARG BUILD_DATE="n/a"
LABEL org.exegol.tag="${TAG}"
LABEL org.exegol.version="${VERSION}"
LABEL org.exegol.build_date="${BUILD_DATE}"
LABEL org.exegol.app="Exegol"
LABEL org.exegol.src_repository="https://github.com/ShutdownRepo/Exegol-images"
RUN echo "${TAG}-${VERSION}" > /opt/.exegol_version

# general
RUN rm /etc/localtime && ln -sv /usr/share/zoneinfo/Europe/Moscow /etc/localtime
RUN sed -i 's/http:\/\//https:\/\//g' /etc/apt/sources.list
RUN apt update && apt upgrade -y

# exegol
ADD sources /root/sources
RUN chmod +x /root/sources/install.sh
RUN /root/sources/install.sh install_base
RUN /root/sources/install.sh install_cloud_tools
RUN /root/sources/install.sh install_clean
RUN rm -rf /root/sources

# ssh
RUN echo 'root:WeaponizeD0cker!' | chpasswd
RUN echo 'PermitRootLogin yes' >> /etc/sshd_config
RUN /etc/init.d/ssh start

# WeaponizeDocker
ADD WeaponizeDocker.sh /data/WeaponizeDocker.sh
RUN chmod +x /data/WeaponizeDocker.sh
RUN /data/WeaponizeDocker.sh

WORKDIR /data
CMD ["/bin/zsh"]
