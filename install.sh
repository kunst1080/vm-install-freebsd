export ZFSBOOT_DISKS=da0
export nonInteractive="YES"
DISTRIBUTIONS="base.txz kernel.txz"

#!/bin/sh

set -e

### Set timezone
cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime


### Edit loader.conf
cat <<EOS>> /boot/loader.conf
autoboot_delay="2"
EOS


### Edit resolv.conf
cat <<EOS>> /etc/resolv.conf
# Google nameservers
nameserver 8.8.8.8
nameserver 8.8.4.4
EOS


### Edit rc.conf
cat <<EOS>> /etc/rc.conf
hostname="VM-FreeBSD"
keymap="jp.106.kbd"

ifconfig_em0="DHCP"

sshd_enable="YES"
dumpdev="NO"

sendmail_enable="NO"
sendmail_submit_enable="NO"
sendmail_outbound_enable="NO"
sendmail_msp_queue_enable="NO"

# VMWare Guest
vmware_guest_vmblock_enable="YES"
vmware_guest_vmhgfs_enable="YES"
vmware_guest_vmmemctl_enable="YES"
vmware_guest_vmxnet_enable="YES"
vmware_guestd_enable="YES"

# NTP
ntpdate_enable="YES"
ntpdate_hosts="ntp.jst.mfeed.ad.jp"
ntpd_enable="YES"
EOS


### Install Applications
export ASSUME_ALWAYS_YES=yes
cat <<EOS | xargs pkg install
  sudo
  open-vm-tools
EOS


### root password
echo 'vmpass' | pw usermod root -h 0 -s /bin/tcsh


poweroff

