FROM php:7-apache
EXPOSE 80
EXPOSE 443

ENV PRIVATEBIN_URL https://github.com/PrivateBin/PrivateBin/archive/master.zip
ENV DOMAIN domain.com

ADD cert.sh /cert.sh
RUN chmod a+x /cert.sh

RUN sed -i "/#ServerName www.example.com/c\ServerName $DOMAIN" /etc/apache2/sites-available/000-default.conf

RUN apt-get update && apt-get upgrade -y --allow-unauthenticated
RUN apt-get install -y --allow-unauthenticated libfreetype6-dev libjpeg62-turbo-dev libpng-dev wget unzip pkg-config patch

ADD https://git.archlinux.org/svntogit/packages.git/plain/trunk/freetype.patch?h=packages/php /tmp/freetype.patch
RUN docker-php-source extract; \
  cd /usr/src/php; \
  patch -p1 -i /tmp/freetype.patch; \
  rm /tmp/freetype.patch

RUN docker-php-ext-configure gd --with-freetype --with-jpeg=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd

RUN set -x \
  && cd /var/www/html \
  && rm -rf *

RUN cd /tmp \
    && wget $PRIVATEBIN_URL \
    && unzip master.zip \
    && cd PrivateBin-master \
    && mv * /var/www/html \
    && cd /var/www/html \
    && rm *.md

RUN apt-get install -y apt-utils python3-certbot-apache 
RUN rm -rf /var/lib/apt/lists/*
RUN apt-get --purge autoremove -y unzip
RUN apt-get --purge autoremove -y wget

RUN echo "Don't forget to edit & run /cert.sh"
