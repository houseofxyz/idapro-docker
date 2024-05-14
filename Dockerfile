FROM ubuntu:22.04
MAINTAINER userunknown <userunknown@userunknown>

ENV TZ=Asia/Singapore
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set Wine to 64-bit architecture and set the prefix (it's good to specify where your Wine environment lives)
ENV WINEARCH=win64
ENV WINEPREFIX=/root/.wine64

# Set the DISPLAY environment variable
ENV DISPLAY=host.docker.internal:0

# Install necessary Windows components and Python via Wine
RUN dpkg --add-architecture i386 \
    && apt update \
    && apt install -y openssh-server xauth wine32 wine64 winetricks x11-apps software-properties-common wget cabextract \
    && wget https://www.python.org/ftp/python/3.10.0/python-3.10.0-amd64.exe -O /root/python-3.10.0-amd64.exe \
    && wget -qO - https://dl.winehq.org/wine-builds/winehq.key | apt-key add - \
    && apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ focal main' \
    && add-apt-repository ppa:cybermax-dexter/sdl2-backport -y \
    && apt update -y \
    && apt install --install-recommends winehq-stable winbind libvulkan1 libvulkan-dev mono-complete -y \
    #&& winetricks --force -q dotnet452 corefonts \
    #&& winetricks -q win10 \
    #&& wine /root/python-3.10.0-amd64.exe /quiet InstallAllUsers=1 PrependPath=1 \
    && mkdir /var/run/sshd \
    && mkdir -p /root/.ssh \
    && chmod 700 /root/.ssh \
    && ssh-keygen -A \
    && sed -i "s/^.*PasswordAuthentication.*$/PasswordAuthentication no/" /etc/ssh/sshd_config \
    && sed -i "s/^.*X11Forwarding.*$/X11Forwarding yes/" /etc/ssh/sshd_config \
    && sed -i "s/^.*X11UseLocalhost.*$/X11UseLocalhost no/" /etc/ssh/sshd_config \
    && grep "^X11UseLocalhost" /etc/ssh/sshd_config || echo "X11UseLocalhost no" >> /etc/ssh/sshd_config

WORKDIR /root
ADD id_rsa.pub /root/client.pub
ADD IDA /root/IDA
RUN cat /root/client.pub >> /root/.ssh/authorized_keys

ENTRYPOINT ["sh", "-c", "/usr/sbin/sshd && tail -f /dev/null"]
