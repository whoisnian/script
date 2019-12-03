#!/bin/bash
#########################################################################
# File Name: transmission.sh
# Author: nian
# Blog: https://whoisnian.com
# Mail: zhuchangbao1998@gmail.com
# Created Time: 2019年12月01日 星期日 00时58分13秒
#########################################################################
RPC_ADDR="http://xxx.xxx.xxx.xxx:9091/transmission/rpc"
RPC_USER="transmission"
RPC_PASS="yourpassword"

# Get Session Id
SessionId=`curl -s \
    $RPC_ADDR \
    -u $RPC_USER:$RPC_PASS \
    | grep -oP '(?<=<code>X-Transmission-Session-Id: )[^<]*'`

# Get Torrent Info
TorrentInfo=`curl -s -X POST \
    $RPC_ADDR \
    -u $RPC_USER:$RPC_PASS \
    -H "X-Transmission-Session-Id: $SessionId" \
    -d '{"method":"torrent-get","arguments":{"fields":["id","addedDate","name","totalSize","rateDownload","rateUpload","uploadRatio","uploadedEver"]}}'`

# Write
echo $TorrentInfo | jq -c ". + {requestTime: `date +%s`}"
