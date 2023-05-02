FROM dockage/alpine:latest

LABEL maintainer="Snimshchikov Ilya <snimshchikov.ilya@gmail.com>" \
    org.label-schema.name="phppgadmin" \
    org.label-schema.vendor="Dockage" \
    org.label-schema.description="phpPgAdmin Docker image, phpPgAdmin is a web-based administration tool for PostgreSQL." \
    org.label-schema.vcs-url="https://github.com/snimshchikov/phppgadmin-docker" \
    org.label-schema.license="MIT"

ENV SERVICE_AVAILABLE_DIR=/etc/sv \
    SERVICE_ENABLED_DIR=/service
ENV SVDIR=${SERVICE_ENABLED_DIR} \
    SVWAIT=7
ADD https://rawgit.com/dockage/runit-scripts/master/scripts/installer /opt/
RUN apk update \
    && apk --no-cache add runit \
    && mkdir -p ${SERVICE_AVAILABLE_DIR} ${SERVICE_ENABLED_DIR} \
    && chmod +x /opt/installer \
    && sync \
    && /opt/installer \
    && rm -rf /var/cache/apk/* /opt/installer
    
ENV DOCKAGE_WEBROOT_DIR=/var/www \
    DOCKAGE_DATA_DIR=/data \
    DOCKAGE_ETC_DIR=/etc/dockage \
    DOCKAGE_LOG_DIR=/var/log
    
ADD ./assets ${DOCKAGE_ETC_DIR}

RUN apk update \
    && apk --no-cache add nginx php8.1-fpm \
    && runit-enable-service nginx \
    && runit-enable-service php-fpm \
    && chown nginx:nginx ${DOCKAGE_WEBROOT_DIR} \
    && mv ${DOCKAGE_ETC_DIR}/sbin/* /sbin \
    && rm -rf /var/cache/apk/* ${DOCKAGE_ETC_DIR}/sbin ${DOCKAGE_WEBROOT_DIR}/* \
    && ln -s /usr/bin/php-fpm8.1 /usr/bin/php-fpm
    
EXPOSE 80/tcp 443/tcp
VOLUME ["$DOCKAGE_DATA_DIR", "$DOCKAGE_LOG_DIR"]
WORKDIR ${DOCKAGE_WEBROOT_DIR}

RUN apk --no-cache --update add php-pgsql postgresql \
    && ${DOCKAGE_ETC_DIR}/buildtime/install \
    && cp -ar ${DOCKAGE_ETC_DIR}/etc/* /etc \
    && rm -rf /var/cache/apk/* ${DOCKAGE_ETC_DIR}/etc ${DOCKAGE_ETC_DIR}/buildtime
    
ENTRYPOINT ["/sbin/entrypoint"]
CMD ["app:start"]
