#! /usr/bin/env bash

exiting(){
    echo "terminating container"
    exit 0
}

do_monitor() {
    while true
    do
        now=$(date)
        result=$(/etc/init.d/php8.4-fpm status | grep "is running")
        if [ $? -ne 0 ]; then
            echo "[ $now ] php8.4-fpm failed" >> /dev/stderr
            exit 1
        else
            echo "[ $now ] $result" >> /dev/stdout
        fi
        sleep 1
    done
}

trap exiting SIGTERM SIGKILL SIGUSR1

/etc/init.d/php8.4-fpm start
sleep 3
do_monitor &

tail -F /dev/stdout /dev/stderr

wait
