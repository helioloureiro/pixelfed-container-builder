FROM docker.io/library/debian:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \
  && apt dist-upgrade -y \
  && apt install -y \
    locales \
  && echo "C.UTF-8 UTF-8" >> /etc/locale.gen \
  && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen


RUN  apt install -y \
  curl \
  php8.4-fpm \
  php8.4-pgsql \
  php8.4-xml \
  php8.4-bcmath \
  php8.4-curl \
  php8.4-zip \
  php8.4-common \
  php8.4-gd \
  composer \
  tar \
  gzip \
  imagemagick

ARG VERSION
RUN mkdir -p /usr/share/webapps \
  && cd /usr/share/webapps \
  && curl -sLO https://github.com/pixelfed/pixelfed/archive/refs/tags/${VERSION}.tar.gz \
  && tar zxvf  ${VERSION}.tar.gz  \
  && rm -f ${VERSION}.tar.gz \
  && mv pixelfed-* pixelfed 

RUN  cd /usr/share/webapps/pixelfed \
  && composer install --no-ansi --no-interaction --optimize-autoloader \
  && chown -R www-data:www-data /usr/share/webapps/pixelfed \
  && sed -i "/listen = / s/= .*/ = 0.0.0.0:9001/" /etc/php/8.4/fpm/pool.d/www.conf \
  && sed -i "/^error_log =/ s/= .*/= \/proc\/self\/fd\/2/" /etc/php/8.4/fpm/php-fpm.conf \
  && sed -i "/access.log =/ s/^.*$/access.log = \/proc\/self\/fd\/2/" /etc/php/8.4/fpm/pool.d/www.conf


COPY entrypoint.sh /entrypoint.sh

WORKDIR /usr/share/webapps/pixelfed

EXPOSE 9001

ENTRYPOINT [ "/entrypoint.sh" ]
