#!/bin/bash
#########################################################################
# File Name: motd.sh
# Author: nian
# Blog: https://whoisnian.com
# Mail: zhuchangbao1998@gmail.com
# Created Time: 2018年06月21日 星期四 13时57分24秒
#########################################################################

#
# Logo
#

logo='
                       -`
                      .o+`
                     `ooo/
                    `+oooo:
                   `+oooooo:
                   -+oooooo+:
                 `/:-:++oooo+:
                `/++++/+++++++:
               `/++++++++++++++:
              `/+++ooooooooooooo/`
             .ooosssso++osssssso+`
            .oossssso-````/ossssss+`
           -osssssso.      :ssssssso.
          :osssssss/        osssso+++.
         /ossssssss/        +ssssooo/-
       `/ossssso+/:-        -:/+osssso+-
      `+sso+:-`                 `.-/+oso:
     `++:.                           `-/+/
     .`                                 `/"
'

#
# Memory
#
# MemUsed = Memtotal + Shmem - MemFree - Buffers - Cached - SReclaimable
# Source: https://github.com/KittyKatt/screenFetch/issues/386#issuecomment-249312716

mem_info=$(</proc/meminfo)
mem_total=$(awk '$1=="MemTotal:" {print $2}' <<< ${mem_info})
mem_used=$((${mem_total} + $(awk '$1=="Shmem:" {print $2}' <<< ${mem_info})))
mem_used=$((${mem_used} - $(awk '$1=="MemFree:" {print $2}' <<< ${mem_info})))
mem_used=$((${mem_used} - $(awk '$1=="Buffers:" {print $2}' <<< ${mem_info})))
mem_used=$((${mem_used} - $(awk '$1=="Cached:" {print $2}' <<< ${mem_info})))
mem_used=$((${mem_used} - $(awk '$1=="SReclaimable:" {print $2}' <<< ${mem_info})))

mem_total=$((mem_total / 1024))
mem_used=$((mem_used / 1024))
mem_usage=$((100 * ${mem_used} / ${mem_total}))

#
# Load average
#

load_average=$(awk '{print $1" "$2" "$3}' /proc/loadavg)

#
# Time
#

time_cur=$(date)

#
# Users
#

user_num=$(who -u | wc -l)

echo -e "\033[0;36;40m$logo\033[0m"
echo -e "System time: \t$time_cur"
echo -e "Memory used: \t\033[0;31;40m$mem_used\033[0m MiB / \033[0;32;40m$mem_total\033[0m MiB ($mem_usage%)"
echo -e "Load average: \t\033[0;33;40m$load_average\033[0m"
echo -e "Users online: \t$user_num\n"
