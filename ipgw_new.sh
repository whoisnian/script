#!/bin/bash
#########################################################################
# File Name: ipgw_new.sh
# Author: nian
# Blog: https://whoisnian.com
# Mail: zhuchangbao1998@gmail.com
# Created Time: 2019年05月19日 星期日 23时01分45秒
#########################################################################

# Your username and password in https://pass.neu.edu.cn
user_name="yourusername"
user_pass="password"

# Get Cookie and LoginForm
LoginForm=`curl -s -L -X GET \
  http://ipgw.neu.edu.cn/srun_cas.php \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:66.0) Gecko/20100101 Firefox/66.0' \
  -c /tmp/ipgw-cookies`

Form_action='https://pass.neu.edu.cn'`grep -oP '(?<=id="loginForm" action=")/tpass/login;jsessionid=[^"]*' <<< $LoginForm`
Form_lt=`grep -oP '(?<=id="lt" name="lt" value=")[^"]*' <<< $LoginForm`
Form_rsa=$user_name$user_pass$Form_lt
Form_ul=${#user_name}
Form_pl=${#user_pass}
Form_execution=`grep -oP '(?<=name="execution" value=")[^"]*' <<< $LoginForm`
Form__eventId=`grep -oP '(?<=name="_eventId" value=")[^"]*' <<< $LoginForm`

# Login
curl -s -k -L -X POST \
  $Form_action \
  -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:66.0) Gecko/20100101 Firefox/66.0' \
  -b /tmp/ipgw-cookies \
  -d "rsa=$Form_rsa&ul=$Form_ul&pl=$Form_pl&lt=$Form_lt&execution=$Form_execution&_eventId=$Form__eventId"
