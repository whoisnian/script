#!/bin/bash
#########################################################################
# File Name: nian.sh
# Author: nian
# Blog: https://whoisnian.com
# Mail: zhuchangbao1998@gmail.com
# Created Time: 2019年01月27日 星期日 20时34分37秒
#########################################################################

SSCONFIGNAME=""
PRIVOXYADDRESS="http://127.0.0.1:8118"

function usage(){
    echo "usage: nian [command]"
    echo "  up\t\tpacman -Syu"
    echo "  pst\t\tstart shadowsocks & privoxy"
    echo "  pex\t\texport http_proxy & https_proxy"
    echo "  pun\t\tunset http_proxy & https_proxy"
    echo "  hst\t\tstart httpd & mariadb"
    echo "  hre\t\trestart httpd & mariadb"
}

function update(){
    sudo pacman -Syu
}

function proxy_start(){
    echo "Starting shadowsocks & privoxy..."
    sudo systemctl start shadowsocks@$SSCONFIGNAME privoxy
    echo "Done."
}

function proxy_export(){
    echo "Starting export http_proxy & https_proxy..."
    export http_proxy=$PRIVOXYADDRESS
    export https_proxy=$PRIVOXYADDRESS
    echo "Done."
}

function proxy_unset(){
    echo "Starting unset http_proxy & https_proxy..."
    unset http_proxy https_proxy
    echo "Done."
}

function httpd_start(){
    echo "Starting httpd & mariadb..."
    sudo systemctl start httpd mariadb
    echo "Done."
}

function httpd_restart(){
    echo "Restarting httpd & mariadb..."
    sudo systemctl restart httpd mariadb
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
    elif [ $1 = "pex" ]
    then
        proxy_export
    elif [ $1 = "pun" ]
    then
        proxy_unset
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
