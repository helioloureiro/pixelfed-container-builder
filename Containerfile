FROM docker.io/library/debian:latest

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \
  && apt install -y \
    locales \
  && echo "C.UTF-8 UTF-8" >> /etc/locale.gen \
  && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
  && locale-gen


RUN  apt install -y \
  curl \
  php8.4-pgsql \
  php8.4-redis \
  php8.4-xml \
  php8.4-bcmath \
  php8.4-curl \
  php8.4-zip \
  php8.4-common \
  php8.4-gd \
  composer \
  tar \
  gzip \
  imagemagick \
  net-tools

RUN apt clean \
  && apt autoremove -y

ARG VERSION
RUN mkdir -p /usr/share/webapps \
  && cd /usr/share/webapps \
  && curl -sLO https://github.com/pixelfed/pixelfed/archive/refs/tags/${VERSION}.tar.gz \
  && tar zxvf  ${VERSION}.tar.gz  \
  && rm -f ${VERSION}.tar.gz \
  && mv pixelfed-* pixelfed 

RUN  cd /usr/share/webapps/pixelfed \
  && composer install --no-ansi --no-interaction --optimize-autoloader \
  && find . -type d -exec chmod 755 {} \; \
  && find . -type f -exec chmod 644 {} \; \
  && mkdir -p /usr/share/webapps/pixelfed/storage \
  && chown -R www-data:www-data /usr/share/webapps/pixelfed

COPY entrypoint.sh-dummy /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]
