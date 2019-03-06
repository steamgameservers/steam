FROM centos:7

# Perform a system update and ensure all packages are at latest versions.
RUN /usr/bin/yum -y update

# Install glibc dependancy on the system.
RUN /usr/bin/yum -y install \
    glibc libstdc++ glibc.i686 libstdc++.i686 ncurses-libs ncurses-libs.i686 wget

# Download the Steam application from from Steam's website.
RUN /usr/bin/wget -c -O /tmp/steamcmd_linux.tar.gz \
    https://steamcdn-a.akamaihd.net/client/installer/steamcmd_linux.tar.gz

# Install the Steam application on the system.
RUN /usr/bin/mkdir /steam && \
    cd /steam && \
    /usr/bin/tar xzf /tmp/steamcmd_linux.tar.gz && \
    /usr/bin/ln -s /steam/steamcmd.sh /steam/steamcmd

# Set the new PATH environment variable.
ENV PATH="${PATH}:/steam"

# Create the Steam user on the container and use it.
RUN /usr/sbin/adduser --home-dir=/home/steam --create-home steam && \
    /usr/bin/chown -R steam:steam /steam
USER steam
WORKDIR /home/steam

# Run a Steam update.
RUN /steam/steamcmd.sh +quiet

# Set user selectable environment variables.
ENV STEAM_LOGIN="anonymous"

# Setup the LD_LIBRARY_PATH path properly for the srcds_linux command.
ENV LD_LIBRARY_PATH=".:bin:${LD_LIBRARY_PATH}"
