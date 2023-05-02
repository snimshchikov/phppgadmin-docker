FROM boxedcode/alpine-nginx-php-fpm:v2.0.0

ENV DOCKAGE_WEBROOT_DIR=/var/www \
    DOCKAGE_DATA_DIR=/data \
    DOCKAGE_ETC_DIR=/etc/dockage \
    DOCKAGE_LOG_DIR=/var/log
    
LABEL maintainer="Snimshchikov Ilya <snimshchikov.ilya@gmail.com>" \
    org.label-schema.name="phppgadmin" \
    org.label-schema.vendor="Dockage" \
    org.label-schema.description="phpPgAdmin Docker image, phpPgAdmin is a web-based administration tool for PostgreSQL." \
    org.label-schema.vcs-url="https://github.com/snimshchikov/phppgadmin-docker" \
    org.label-schema.license="MIT"

ADD ./assets ${DOCKAGE_ETC_DIR}

RUN apk --no-cache --update add php-pgsql postgresql \
    && ${DOCKAGE_ETC_DIR}/buildtime/install \
    && cp -ar ${DOCKAGE_ETC_DIR}/etc/* /etc \
    && rm -rf /var/cache/apk/* ${DOCKAGE_ETC_DIR}/etc ${DOCKAGE_ETC_DIR}/buildtime
