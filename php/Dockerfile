FROM php:7.4-fpm-alpine

### Environment Vars
    ## Build Dependancies 
ENV DEPS_BUILD="libxml2-dev imagemagick-dev php7-dev php7-pear gnupg"\
    ## Production Dependancies
    DEPS_PROD="vim zip unzip curl wget git tzdata libzip-dev"\
    ## Image Library Dependancies
    DEPS_IMG_REF="freetype libpng libjpeg-turbo vips-tools imagemagick jpegoptim optipng pngquant"\
    ## Image Library Headers
    DEPS_IMG_REF_DEV="freetype-dev libpng-dev libjpeg-turbo-dev vips-dev"\
    # others
    # bash icu-dev icu-libs openssh-client rsync zlib-dev yaml-dev pcre-dev 
    ## Retrieve the ODBC drivers for Ubuntu
    MS_URI=https://download.microsoft.com/download/e/4/e/e4e67866-dffd-428c-aac7-8d28ddafb39b/\
    MS_SQL=mssql-tools_17.6.1.1-1_amd64\
    MS_ODBC=msodbcsql17_17.6.1.1-1_amd64\
    ## Adding SQL Server tools and Composer to $PATH
    PATH=./vendor/bin:/composer/vendor/bin:$PATH:/opt/mssql-tools/bin\
    ## Add Composer vars
    COMPOSER_HOME=/composer\
    COMPOSER_ALLOW_SUPERUSER=1

### Copy and Update certificates
# COPY ./sample-cert.crt /usr/local/share/ca-certificates/sample-cert.crt
# RUN cat /usr/local/share/ca-certificates/sample-cert.crt >> /etc/ssl/certs/ca-certificates.crt &&\
#     /usr/sbin/update-ca-certificates 

### Install Dependencies
    ## Install base packages and dependancies
RUN apk --no-cache --update --virtual .build-deps add ${DEPS_BUILD} &&\
    apk --no-cache --update --virtual .prod-deps add build-base ${DEPS_PROD} &&\
    apk --no-cache --update --virtual .img-ref-deps add ${DEPS_IMG_REF} ${DEPS_IMG_REF_DEV}

### Retrieve the ODBC drivers for Ubuntu
    ## Download mssql-tools and sig
RUN curl -O ${MS_URI}${MS_SQL}.apk &&\
    curl -O ${MS_URI}${MS_SQL}.sig &&\
    ## Download msodbcsql and sig
    curl -O ${MS_URI}${MS_ODBC}.apk &&\
    curl -O ${MS_URI}${MS_ODBC}.sig &&\
    ## Import gpg keys for signature verification
    curl https://packages.microsoft.com/keys/microsoft.asc | gpg --import - &&\
    gpg --verify ${MS_SQL}.sig ${MS_SQL}.apk &&\
    gpg --verify ${MS_ODBC}.sig ${MS_ODBC}.apk

### Install ODBC drivers
RUN echo y | apk add --allow-untrusted ${MS_SQL}.apk ${MS_ODBC}.apk &&\
    ACCEPT_EULA=Y apk --no-cache --update --virtual mssql-odbc-drivers add unixodbc-dev msodbcsql17 mssql-tools &&\
    ## Install the drivers via PECL
    pecl install vips &&\
    pecl install sqlsrv &&\
    pecl install pdo_sqlsrv

### Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

### Configure
    ## Generate default php.ini
RUN cp /usr/local/etc/php/php.ini-production /usr/local/etc/php/php.ini &&\
    ## Set local time
    ln -sf /usr/share/zoneinfo/US/Eastern /etc/localtime &&\
    ## PHP Config
    pecl config-set php_ini /usr/local/etc/php/php.ini &&\
    ## Install extensions and clean up
    docker-php-ext-install zip exif pcntl &&\
    docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg &&\
    docker-php-ext-install gd &&\
    ## Enable pecl extensions
    docker-php-ext-enable vips sqlsrv pdo_sqlsrv &&\
    ## Cleanup dev dependencies
    apk del -f .build-deps &&\
    ## File Permissions
    chown -R www-data:www-data /var/www/html

### Setup working directory
WORKDIR /var/www/html
### Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]