#! /usr/bin/env bash

exiting(){
    echo "terminating container"
    exit 0
}

trap exiting SIGTERM SIGKILL SIGUSR1

/etc/init.d/php8.4-fpm start

while true
do
    now=$(date)
    echo -n "[ $now ] "
    /etc/init.d/php8.4-fpm status | grep "is running"
    if [ $? -ne 0 ]; then
        echo "php8.4-fpm failed"
        exit 1
    fi
    sleep 1
done
