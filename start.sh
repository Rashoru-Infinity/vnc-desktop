#!/bin/bash

set -ex
# add user
if [ $(getent passwd $USERNAME | wc -l ) = "0" ]; then
    groupadd $GROUPNAME
    useradd -m -s /bin/bash -g $GROUPNAME -G sudo,vglusers $USERNAME
    echo $USERNAME:$PASSWORD | chpasswd
fi
# allows the user to use sudo without password
echo '%sudo ALL=(ALL) NOPASSWD:ALL'  >> /etc/sudoers
# setup Xauthority
gosu $USERNAME touch /home/$USERNAME/.Xauthority
# setup vnc password
gosu $USERNAME mkdir -p /home/$USERNAME/.vnc
gosu $USERNAME chmod 700 /home/$USERNAME/.vnc
gosu $USERNAME touch /home/$USERNAME/.vnc/passwd
gosu $USERNAME chmod 600 /home/$USERNAME/.vnc/passwd
# setup wallpaper
if [ -n "$WALLPAPERURL" ]; then
    gosu $USERNAME bash -c "mkdir -p /home/$USERNAME/Templates \
    && cd /home/$USERNAME/Templates \
    && curl -JLo wallpaper $WALLPAPERURL \
    && mkdir -p /home/$USERNAME/.config/pcmanfm/LXDE \
    && sed 's/@/$USERNAME/' /opt/desktop-items-0.conf > \
    /home/$USERNAME/.config/pcmanfm/LXDE/desktop-items-0.conf"
fi

# start vnc server
gosu $USERNAME /opt/TurboVNC/bin/vncpasswd -f <<< $PASSWORD > /home/$USERNAME/.vnc/passwd
gosu $USERNAME /opt/TurboVNC/bin/vncserver :0 -fg -vgl -wm startlxde
