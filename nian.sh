#!/bin/bash
#########################################################################
# File Name: nian.sh
# Author: nian
# Blog: https://whoisnian.com
# Mail: zhuchangbao1998@gmail.com
# Created Time: 2019年01月27日 星期日 20时34分37秒
#########################################################################

SSCONFIGNAME=""
TRANCONFIGNAME=""
PRIVOXYADDRESS="http://127.0.0.1:8118"

function usage(){
    echo "usage: nian [command]"
    echo "  up\t\tpacman -Syu"
    echo "  pst\t\tstart shadowsocks & privoxy"
    echo "  ped\t\tend shadowsocks & privoxy"
    echo "  pex\t\texport http_proxy & https_proxy"
    echo "  pun\t\tunset http_proxy & https_proxy"
    echo "  tst\t\tstart transparent proxy"
    echo "  ted\t\tend transparent proxy"
    echo "  hst\t\tstart httpd & mariadb"
    echo "  hre\t\trestart httpd & mariadb"
}

function update(){
    sudo pacman -Syu
}

function proxy_start(){
    echo "Starting shadowsocks & privoxy..."
    sudo systemctl start shadowsocks@$SSCONFIGNAME privoxy
    kwriteconfig5 --file $HOME/.config/kioslaverc --group "Proxy Settings" --key "ProxyType" 2
    echo 'user_pref("network.proxy.type", 2);' > $HOME/.mozilla/firefox/*.default/user.js
    echo "Done."
}

function proxy_end(){
    echo "Ending shadowsocks & privoxy..."
    sudo systemctl stop shadowsocks@$SSCONFIGNAME privoxy
    kwriteconfig5 --file $HOME/.config/kioslaverc --group "Proxy Settings" --key "ProxyType" 0
    echo 'user_pref("network.proxy.type", 5);' > $HOME/.mozilla/firefox/*.default/user.js
    echo "Done."
}

function proxy_export(){
    echo "Starting export http_proxy & https_proxy..."
    export http_proxy=$PRIVOXYADDRESS
    export https_proxy=$PRIVOXYADDRESS
    export HTTP_PROXY=$PRIVOXYADDRESS
    export HTTPS_PROXY=$PRIVOXYADDRESS
    echo "Done."
}

function proxy_unset(){
    echo "Starting unset http_proxy & https_proxy..."
    unset http_proxy https_proxy HTTP_PROXY HTTPS_PROXY
    echo "Done."
}

function transparent_start(){
    echo "Starting transparent proxy..."
    sudo systemctl start shadowsocks-auto-redir@$TRANCONFIGNAME
    sudo sed -i 's|default|dnsmasq|g' /etc/NetworkManager/NetworkManager.conf
    sudo systemctl restart NetworkManager
    echo "Done."
}

function transparent_end(){
    echo "Ending transparent proxy..."
    sudo systemctl stop shadowsocks-auto-redir@$TRANCONFIGNAME
    sudo sed -i 's|dnsmasq|default|g' /etc/NetworkManager/NetworkManager.conf
    sudo systemctl restart NetworkManager
    echo "Done."
}

function httpd_start(){
    echo "Starting httpd & mariadb..."
    sudo systemctl start httpd mariadb php-fpm
    echo "Done."
}

function httpd_restart(){
    echo "Restarting httpd & mariadb..."
    sudo systemctl restart httpd mariadb php-fpm
    echo "Done."
}

if [ $# -ge 1 ]
then
    if [ $1 = "up" ]
    then
        update
    elif [ $1 = "pst" ]
    then
        proxy_start
    elif [ $1 = "ped" ]
    then
        proxy_end
    elif [ $1 = "pex" ]
    then
        proxy_export
    elif [ $1 = "pun" ]
    then
        proxy_unset
    elif [ $1 = "tst" ]
    then
        transparent_start
    elif [ $1 = "ted" ]
    then
        transparent_end
    elif [ $1 = "hst" ]
    then
        httpd_start
    elif [ $1 = "hre" ]
    then
        httpd_restart
    else
        usage
    fi
else
    usage
fi
