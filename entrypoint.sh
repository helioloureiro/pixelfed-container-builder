#! /usr/bin/env bash


exiting(){
    echo "terminating container"
    /etc/init.d/php8.4-fpm stop
    exit 0
}

trap exiting SIGTERM SIGKILL SIGUSR1

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
        sleep 300
    done
}

die() {
    echo "$*" >&2
    exit 1
}


logerror() {
  echo "$*" >&2
}

initialize() {
    cd /usr/share/webapps/pixelfed
    php artisan storage:link  || \
      logerror "storage link failed"
    php artisan migrate --force || \
      logerror "failed to migrated data"
    touch /usr/share/webapps/pixelfed/storage/.initialized
    }

  pixel_start() {
    cd /usr/share/webapps/pixelfed
    #php artisan import:cities \
    php artisan instance:actor \
      && php artisan passport:keys \
      && php artisan route:cache \
      && php artisan view:cache \
      && php artisan config:cache \
      && php artisan horizon:install || \
      logerror "Failed to initialize pixelfed"
}

/etc/init.d/php8.4-fpm start
sleep 3
# do_monitor &
#
if [ ! -f "/usr/share/webapps/pixelfed/storage/.initialized" ] ;then
    initialize
fi

pixel_start

tail -F /dev/stdout /dev/stderr

# wait
