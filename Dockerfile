FROM richarvey/nginx-php-fpm:2.1.2

LABEL maintainer="Snimshchikov Ilya <snimshchikov.ilya@gmail.com>" \
    org.label-schema.name="phppgadmin" \
    org.label-schema.description="phpPgAdmin Docker image, phpPgAdmin is a web-based administration tool for PostgreSQL." \
    org.label-schema.vcs-url="https://github.com/snimshchikov/phppgadmin-docker" \
    org.label-schema.license="MIT"

ENV WEBROOT_DIR=/var/www/html/ \
    DATA_DIR=/data \
    LOG_DIR=/var/log \
    ASSETS_DIR=/etc/assets \
    
    PPA_SERVER_DESC=PostgreSQL \
    PPA_SERVER_HOST= \
    PPA_SERVER_PORT=5432 \
    PPA_SERVER_SSL_MODE=allow \
    PPA_SERVER_DEFAULT_DB=postgres \
    PPA_SERVER_PG_DUMP_PATH=/usr/bin/pg_dump \
    PPA_SERVER_PG_DUMPALL_PATH=/usr/bin/pg_dumpall \

    PPA_SERVER_DESCS= \
    PPA_SERVER_HOSTS= \
    PPA_SERVER_PORTS= \
    PPA_SERVER_SSL_MODES= \
    PPA_SERVER_DEFAULT_DBS= \
    PPA_SERVER_PG_DUMP_PATHS= \
    PPA_SERVER_PG_DUMPALL_PATHS= \

    PPA_DEFAULT_LANG=auto \
    PPA_AUTO_COMPLETE='default on' \
    PPA_EXTRA_LOGIN_SECURITY=true \
    PPA_OWNED_ONLY=false \
    PPA_SHOW_COMMENTS=true \
    PPA_SHOW_ADVANCED=false \
    PPA_MIN_PASSWORD_LENGTH=10 \
    
    PPA_LEFT_WIDTH=200 \
    PPA_THEME=default \
    PPA_SHOW_OIDS=false \
    PPA_MAX_ROWS=50 \
    PPA_MAX_CHARS=50 \
    PPA_USE_XHTML_STRICT=false \
    PPA_HELP_BASE='http://www.postgresql.org/docs/%s/interactive/' \
    PPA_AJAX_REFRESH=3 

ADD ./assets ${ASSETS_DIR}

RUN apk --no-cache --update add php-pgsql postgresql \
    && ${ASSETS_DIR}/buildtime/install \
    && rm -rf ${ASSETS_DIR}/buildtime
    && mv ${ASSETS_DIR}/runtime/configs/phppgadmin/config.inc.php ${WEBROOT_DIR}/conf/config.inc.php
    
CMD ["/start.sh"]
