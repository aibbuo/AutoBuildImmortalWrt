#!/bin/sh
# 该脚本为immortalwrt首次启动时运行的脚本 即 /etc/uci-defaults/99-custom.sh
# 设置默认防火墙规则，方便虚拟机首次访问 WebUI
uci set firewall.@zone[1].input='ACCEPT'

# 设置主机名映射，解决安卓原生 TV 无法联网的问题
uci add dhcp domain
uci set "dhcp.@domain[-1].name=time.android.com"
uci set "dhcp.@domain[-1].ip=203.107.6.88"

# 设置默认 LAN IP 为 192.168.58.1（你的需求）
uci set network.lan.ipaddr='192.168.58.1'
echo "Set LAN IP to 192.168.58.1 at $(date)" >> /tmp/firstboot.log

# 写入 PPPoE 拨号信息
uci set network.wan.proto='pppoe'                
uci set network.wan.username='02008017806@163.gd'     
uci set network.wan.password='OWBVCOIP'     
uci set network.wan.peerdns='1'                  
uci set network.wan.auto='1' 
echo "PPPoE configuration written at $(date)" >> /tmp/firstboot.log

# 设置所有网口可访问网页终端
uci delete ttyd.@ttyd[0].interface

# 设置所有网口可连接 SSH
uci set dropbear.@dropbear[0].Interface=''

# 设置编译者信息为 BIAO GUO
FILE_PATH="/etc/openwrt_release"
NEW_DESCRIPTION="BIAO GUO"
sed -i "s/DISTRIB_DESCRIPTION='[^']*'/DISTRIB_DESCRIPTION='$NEW_DESCRIPTION'/" "$FILE_PATH"

# 提交所有 UCI 更改
uci commit

exit 0

