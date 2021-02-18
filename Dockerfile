FROM php:8.0.2-apache
RUN apt-get update

# Ativo o mod_rewrite
RUN echo "LoadModule rewrite_module /usr/lib/apache2/modules/mod_rewrite.so" >> /etc/apache2/mods-available/rewrite.load
RUN a2enmod rewrite
RUN a2enmod headers

# Instalo a extensão para o mysql
RUN docker-php-ext-install pdo_mysql

# Instalo o composer
RUN apt-get install -y curl
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/
RUN ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

# Copio e habilito as confs do apache
COPY ./apache.conf /etc/apache2/sites-enabled/000-default.conf
CMD ["apachectl", "-D", "FOREGROUND"]

# Instalo algumas coisas que podem ser necessárias
RUN apt-get install -y git unzip

WORKDIR /var/www/html