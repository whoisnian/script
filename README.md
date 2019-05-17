# Linux Script

## ipgw
* Set your student id and password.
* `$ ./ipgw`

## netease-cloud-music-download.php
* `$ ./netease-cloud-music-download`

## pastecode
* `<command> | pastecode` and get the link. Such as:
  * `$ screenfetch -N | pastecode` (default poster and type)
  * `$ cat nian.css | pastecode -p nian` (only default type)
  * `$ cat try.cpp | pastecode -t cpp` (only default poster)
  * `$ cat ipgw.sh | pastecode -p nian -t bash`

## cf
* Set your handle and query intervel.
* `$./cf`

## status
* `$ ./status`

## screenchange
* `$ xrandr --current` and set your screen name.
* `$ ./screenchange` : use 'intern' and 'extern';
* `$ ./screenchange 1` : use 'extern';
* `$ ./screenchange 2` : use 'intern'.

## bingwallpaper
* Set your own directory.
* `$ ./bingwallpaper`

## masm
* Set your own dosbox directory.
* `$ ./masm` OR `$ ./masm hello.asm`

## motd.sh
* `$ sudo cp ./motd.sh /etc/profile.d/`

## togif
* `$ ./togif example.flv example.gif`

## nian.sh
* `$ source nian.sh`
* `$ source nian.sh up`

## cert
* `$ ./cert`
* `$ sudo cp server.key /etc/httpd/conf`
* `$ sudo chmod 400 /etc/httpd/conf/server.key`
* `$ sudo cp server.crt /etc/httpd/conf`
* Configure your apache or nginx.
* Import `ca.crt` to your browser and system.

## yd
* Install `ydcv` and `kdialog`.
* `$ ./yd` or `$ ./yd hello`
* If you want run `yd` in `$HOME/.bin` with krunner, `echo '#!/bin/bash\nexport PATH=$HOME/.bin:$PATH' > ~/.config/plasma-workspace/env/path.sh`.
