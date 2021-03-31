FROM php:8.0.3-apache
ARG UID
EXPOSE $UID

RUN adduser -u ${UID} --disabled-password --gecos "" appuser
RUN mkdir /home/appuser/.ssh
RUN chown -R appuser:appuser /home/appuser/
RUN echo "StrictHostKeyChecking no" >> /home/appuser/.ssh/config
RUN echo "export COLUMNS=300" >> /home/appuser/.bashrc
RUN echo "alias sf=/appdata/www/bin/console" >> /home/appuser/.bashrc

RUN apt-get update \
    && apt-get install -y git acl openssl openssh-client wget vim libzip-dev \
    && apt-get install -y libpng-dev zlib1g-dev libxml2-dev libicu-dev \
    && docker-php-ext-install intl pdo_mysql zip gd soap \
    && docker-php-ext-enable --ini-name 05-opcache.ini opcache \
    && pecl install xdebug

COPY ./site.conf /etc/apache2/sites-available/site.conf
COPY ./php.ini /usr/local/etc/php/php.ini

RUN sed -i s/www-data/appuser/g /etc/apache2/envvars

RUN curl --insecure https://getcomposer.org/composer.phar -o /usr/bin/composer && chmod +x /usr/bin/composer

RUN mkdir -p /appdata/www
RUN chown -R appuser:appuser /appdata/www

RUN docker-php-ext-enable xdebug

USER appuser

USER root
RUN a2enmod rewrite \
    && a2ensite site.conf \
    && a2dissite 000-default.conf

WORKDIR /appdata/www