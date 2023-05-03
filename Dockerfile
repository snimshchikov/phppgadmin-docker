FROM richarvey/nginx-php-fpm:2.1.2

LABEL maintainer="Snimshchikov Ilya <snimshchikov.ilya@gmail.com>" \
    org.label-schema.name="phppgadmin" \
    org.label-schema.description="phpPgAdmin Docker image, phpPgAdmin is a web-based administration tool for PostgreSQL." \
    org.label-schema.vcs-url="https://github.com/snimshchikov/phppgadmin-docker" \
    org.label-schema.license="MIT"

ENV WEBROOT_DIR=/var/www/html/ \
    DATA_DIR=/data \
    LOG_DIR=/var/log \
    ASSETS_DIR=/etc/assets
ADD ./assets ${ASSETS_DIR}

RUN apk --no-cache --update add php-pgsql postgresql \
    && ${ASSETS_DIR}/buildtime/install \
    && rm -rf ${ASSETS_DIR}/buildtime
    
CMD ["/etc/assets/etc/runit/1.d/phppgadmin && /start.sh"]
