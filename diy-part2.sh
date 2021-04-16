#!/bin/bash
#============================================================
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
# Lisence: MIT
# Author: P3TERX
# https://github.com/yfdoor/OpenWrt/blob/master/.github/workflows/OpenWrt-Build.yml
#============================================================

# Modify default IP Time
sed -i 's/16384/1048576/g' package/kernel/linux/files/sysctl-nf-conntrack.conf
sed -i 's/192.168.1.1/192.168.9.1/g' package/base-files/files/bin/config_generate

#sysctl
echo "vm.swappiness = 0" >> package/base-files/files/etc/sysctl.d/10-default.conf
echo "net.ipv4.tcp_slow_start_after_idle = 0" >> package/base-files/files/etc/sysctl.d/10-default.conf
echo "net.ipv4.tcp_fastopen = 3" >> package/base-files/files/etc/sysctl.d/10-default.conf
echo "net.ipv4.tcp_fastopen_blackhole_timeout_sec = 0" >> package/base-files/files/etc/sysctl.d/10-default.conf
echo "net.ipv4.tcp_tw_reuse = 1" >> package/base-files/files/etc/sysctl.d/10-default.conf
echo "net.ipv4.tcp_max_tw_buckets = 48000" >> package/base-files/files/etc/sysctl.d/10-default.conf
echo "net.ipv4.ip_local_port_range = 10999 64999" >> package/base-files/files/etc/sysctl.d/10-default.conf
sed -i '/net.ipv4.tcp_keepalive_time/d' package/base-files/files/etc/sysctl.d/10-default.conf
echo "net.ipv4.tcp_keepalive_time = 1800" >> package/base-files/files/etc/sysctl.d/10-default.conf
echo "net.core.somaxconn = 40960" >> package/base-files/files/etc/sysctl.d/10-default.conf
echo "net.core.optmem_max = 81920" >> package/base-files/files/etc/sysctl.d/10-default.conf
echo "net.ipv4.tcp_max_orphans = 81920" >> package/base-files/files/etc/sysctl.d/10-default.conf
echo "net.core.netdev_max_backlog = 2000" >> package/base-files/files/etc/sysctl.d/10-default.conf
echo "net.ipv4.tcp_max_syn_backlog = 8192" >> package/base-files/files/etc/sysctl.d/10-default.conf

# application
git clone https://github.com/xiaorouji/openwrt-passwall.git  package/passwall
git clone https://github.com/nixlbb/application.git  package/application

# tools
mkdir -p tools/ucl && wget -P tools/ucl https://raw.githubusercontent.com/nixlbb/tools/master/ucl/Makefile
mkdir -p tools/upx && wget -P tools/upx https://raw.githubusercontent.com/nixlbb/tools/master/upx/Makefile
sed  -i '/tools-$(CONFIG_TARGET_orion_generic)/atools-y += ucl upx' tools/Makefile
sed  -i '/dependencies/a\\$(curdir)/upx/compile := $(curdir)/ucl/compile' tools/Makefile

# update golang
pushd feeds/packages/lang
rm -rf golang && svn co https://github.com/openwrt/packages/trunk/lang/golang
popd
