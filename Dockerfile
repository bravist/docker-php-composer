FROM lucor/php7-cli:latest

MAINTAINER Luca Corbo <lu.corbo@gmail.com>

WORKDIR /app

VOLUME /home

COPY docker-entrypoint.sh /docker-entrypoint.sh
CMD ["composer"]
ENTRYPOINT ["/bin/sh", "/docker-entrypoint.sh"]

# Allow Composer to be run as root
ENV COMPOSER_ALLOW_SUPERUSER 1

ENV COMPOSER_HOME /home/.composer

ENV COMPOSER_SETUP_SHA 55d6ead61b29c7bdee5cccfb50076874187bd9f21f65d8991d46ec5cc90518f447387fb9f76ebae1fbbacf329e583e30

ENV COMPOSER_VERSION "1.3.2"

# Install Composer
RUN php -r "readfile('https://getcomposer.org/installer');" > /tmp/composer-setup.php \
    && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) === getenv('COMPOSER_SETUP_SHA')) { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('/tmp/composer-setup.php'); echo PHP_EOL; exit(1); } echo PHP_EOL;" \
    && mkdir -p /composer/bin \
    && php /tmp/composer-setup.php --install-dir=/composer/bin --filename=composer --version=${COMPOSER_VERSION} \
    && rm /tmp/composer-setup.php \
    && ln -sf /composer/bin/composer /usr/local/bin/composer

# Set up a /composer/bin volume so that the composer binary can be mounted
# and used in third-party php images (i.e with differents php versions)
VOLUME /composer/bin
