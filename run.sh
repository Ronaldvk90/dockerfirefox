#!/bin/bash

if [ -d "/home/$USERNAME" ]; then

# Set your timezone
ln -sf /usr/share/zoneinfo/$TZ /etc/localtime

# Continue without parts of the user creation
echo "Not the first time the container runs. Skipping parts of the user creation"
useradd -M $USERNAME
echo "$USERNAME:$PASSWORD" | chpasswd
chsh -s /bin/bash $USERNAME

rm /etc/xrdp/startwm.sh
cat >> /etc/xrdp/startwm.sh <<EOF
#!/bin/sh
startfluxbox
EOF
chmod +x /etc/xrdp/startwm.sh

# Make sure DBUS and xrdp-sesman run
if [ -f "/run/dbus/pid" ]; then
    rm /run/dbus/pid
fi

if [ ! -d "/run/dbus" ]; then
  mkdir -p /run/dbus
fi

dbus-daemon --system

if [ -f "/var/run/xrdp-sesman.pid" ]; then
    rm /var/run/xrdp-sesman.pid
fi

xrdp-sesman
xrdp --nodaemon

else

echo "First time the container is run. Arrange some stuff for you."

# Set your timezone
ln -sf /usr/share/zoneinfo/$TZ /etc/localtime

# Prepare a user for the server
useradd  -m $USERNAME
echo "$USERNAME:$PASSWORD" | chpasswd
chsh -s /bin/bash $USERNAME

rm /etc/xrdp/startwm.sh
cat >> /etc/xrdp/startwm.sh <<EOF2
#!/bin/sh
startfluxbox
EOF2
chmod +x /etc/xrdp/startwm.sh

# Make sure DBUS and xrdp-sesman run
if [ -f "/run/dbus/pid" ]; then
rm /run/dbus/pid
fi

if [ ! -d "/run/dbus" ]; then
mkdir -p /run/dbus
fi

dbus-daemon --system

if [ -f "/var/run/xrdp-sesman.pid" ]; then
rm /var/run/xrdp-sesman.pid
fi

xrdp-sesman
xrdp --nodaemon
fi
