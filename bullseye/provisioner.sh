#!/bin/bash
#
# Shell script to provision the Debian Vagrant box.
#
# Copyright 2020-2022, Frederico Martins
#   Author: Frederico Martins <http://github.com/fscm>
#
# SPDX-License-Identifier: MIT
#
# This program is free software. You can use it and/or modify it under the
# terms of the MIT License.
#

set -e

# ----- Clear history

echo "[INFO ] Disabling 'history'."

unset HISTFILE
history -cw


# ----- Check permissions

if [[ "$(id -u)" -ne 0 ]]; then
  echo >&2 "[ERROR] This script requires privileged access to system files"
  exit 99
fi


# ----- Set environment

echo "[INFO ] Setting environment vars."

export DEBIAN_FRONTEND="noninteractive"
export DEBCONF_NONINTERACTIVE_SEEN="true"


# ----- Configure apt

echo "[INFO ] Configuring apt."

for srv in apt-daily apt-daily-upgrade; do
    systemctl stop ${srv}.timer
    systemctl disable ${srv}.timer
    systemctl mask ${srv}.service
done

systemctl daemon-reload

cat <<'EOF' >/etc/apt/apt.conf.d/20auto-upgrades
APT::Periodic::Enable "0";
APT::Periodic::AutocleanInterval "0";
APT::Periodic::Download-Upgradeable-Packages "0";
APT::Periodic::Update-Package-Lists "0";
APT::Periodic::Unattended-Upgrade "0";
EOF

cat <<'EOF' >/etc/apt/apt.conf.d/90gzip-indexes
Acquire::GzipIndexes "true";
Acquire::CompressionTypes::Order:: "gz";
EOF

cat <<'EOF' >/etc/apt/apt.conf.d/90autoremove-suggests
APT::AutoRemove::SuggestsImportant "false";
EOF

cat <<'EOF' >/etc/apt/apt.conf.d/90no-language
Acquire::Languages "none";
EOF

sed -i -e '/^#/d;/^deb-src/s/^/#/;/^[[:space:]]*$/d' /etc/apt/sources.list


# ----- Retrieve new lists of packages

echo "[INFO ] Updating apt packages lists."

apt-get -qq update


# ----- Install virtualization tools

if lspci | grep --quiet --ignore-case virtualbox; then
    echo "[INFO ] Installing tools for the VirtualBox hypervisor."
    dpkg-query --show --showformat='${Package}\n' > /tmp/dependencies.pre
    apt-get -y -qq install --no-install-recommends \
        linux-headers-"$(dpkg --print-architecture)" \
        dkms \
        make \
        gcc \
        > /dev/null 2>&1
    dpkg-query --show --showformat='${Package}\n' > /tmp/dependencies.post
    mkdir -p /media/guest_additions_cd
    mount -r VBoxGuestAdditions.iso /media/guest_additions_cd
    /media/guest_additions_cd/VBoxLinuxAdditions.run --nox11 || true
    if ! modinfo vboxsf > /dev/null 2>&1; then
        echo >&2 "[ERROR] Virtualization tools installation failled."
        exit 10
    fi
    apt-get -y -qq purge \
        $(diff --changed-group-format='%>' --unchanged-group-format='' /tmp/dependencies.pre /tmp/dependencies.post | xargs) \
        > /dev/null 2>&1
    umount /media/guest_additions_cd
    rm -rf /media/guest_additions_cd
    #rm -rf /etc/kernel/prerm.d/*
    rm -rf /tmp/dependencies.*
elif lspci | grep --quiet --ignore-case vmware; then
    echo "[INFO ] Installing tools for the VMWare hypervisor."
    apt-get -y -qq install --no-install-recommends open-vm-tools > /dev/null 2>&1
    systemctl enable open-vm-tools
else
    echo "[INFO ] UNKNOWN hypervisor, no tools will be installed."
fi


# ----- Configure sshd

echo "[INFO ] Configuring sshd."

sed -i \
    -e '/UseDNS /s/.*\(UseDNS\) .*/\1 no/' \
    -e '/GSSAPIAuthentication /s/.*\(GSSAPIAuthentication\) .*/\1 no/' \
    /etc/ssh/sshd_config

wget -q https://raw.github.com/mitchellh/vagrant/master/keys/vagrant.pub -O /tmp/authorized_keys
for usr in /home/*; do
    username="${usr##*/}"
    install --directory --owner="${username}" --group="${username}" --mode=0700 /home/"${username}"/.ssh
    install --owner="${username}" --group="${username}" --mode=0600 --target-directory=/home/"${username}"/.ssh /tmp/authorized_keys
done
rm -rf /tmp/authorized_keys


# ----- Configure base system

echo "[INFO ] Configuring base system."

#install -d --owner 0 --group 0 --mode 1777 /vagrant
sed -i -e '/^mesg n/s/^/tty -s \&\& /' /root/.profile
echo 'export TZ=:/etc/localtime' > /etc/profile.d/tz.sh
echo 'export SYSTEMD_PAGER=' > /etc/profile.d/systemd.sh
sed -i \
    -e '/^GRUB_TIMEOUT=/s/=.*/=1/' \
    -e 's/GRUB_CMDLINE_LINUX_DEFAULT="\(.*\)"/GRUB_CMDLINE_LINUX_DEFAULT="\1 cgroup_enable=memory"/' \
    /etc/default/grub
grub2-mkconfig --output=/boot/grub2/grub.cfg


# ----- System cleanup

echo "[INFO ] Cleaning up the system."

apt-get -y -qq purge \
    dictionaries* \
    emacs* \
    iamerican* \
    ibritish* \
    ienglish* \
    installation-report \
    ispell \
    libx11-6 \
    libx11-data \
    libxcb1 \
    libxext6 \
    libxmuu1 \
    nfacct \
    popularity-contest \
    tcpd \
    xauth \
    > /dev/null 2>&1
apt-get -y -qq --purge autoremove > /dev/null 2>&1
apt-get autoclean
apt-get clean

#rm -rf /tmp/{..?*,.[!.]*,*}
rm -rf /usr/share/info/*
rm -rf /usr/share/man/*
rm -rf /var/cache/apt/*
rm -rf /var/lib/apt/lists/*
rm -rf /var/lib/dhcp/*
rm -rf /var/log/*
rm -rf /var/tmp/{..?*,.[!.]*,*}

find /home /root -type f -not \( -name '.bashrc' -o -name '.bash_logout' -o -name '.profile' -o -name 'authorized_keys' \) -delete
find /usr/share/locale -mindepth 1 -maxdepth 1 -type d -not \( -name 'en' -o -name 'en_US' \) -exec rm -r {} ';'
find /usr/share/doc -mindepth 1 -not -type d -not -name 'copyright' -delete
find /usr/share/doc -mindepth 1 -type d -empty -delete
find /var/cache -type f -delete


# ----- Fileystem cleanup

echo "[INFO ] Cleaning up the filesystem."

sed -i -e '/swap/s/UUID=[^ ]* /LABEL=SWAP /' /etc/fstab
sed -i -e '/cdrom/d' /etc/fstab

swap_part="$(swapon --show=NAME --noheadings --raw)"
swapoff "${swap_part}"
dd if=/dev/zero of="${swap_part}" > /dev/null 2>&1 || echo 'dd exit code suppressed'
mkswap -L SWAP "${swap_part}"
swapon "${swap_part}"

dd if=/dev/zero of=/EMPTY bs=1M > /dev/null 2>&1 || echo 'dd exit code suppressed'
rm -f /EMPTY

sync


# ----- System info

echo "[INFO ] System info:"

echo '--------------------------------------------------'
printf 'Debian ' ; cat /etc/debian_version
du -sh / --exclude=/proc
echo '--------------------------------------------------'


echo "[INFO ] Provisioning finished."
exit 0
