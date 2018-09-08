FROM openjdk:8-alpine

ENV CONF_HOME=/var/atlassian/confluence
ENV CONF_INSTALL=/opt/atlassian/confluence
ARG CONF_VERSION=6.11.0
ENV JAVA_CACERTS=${JAVA_HOME}/jre/lib/security/cacerts
ARG CERTIFICATE=${CONF_HOME}/certificate
ARG JDBC_DL_PATH=https://jdbc.postgresql.org/download/
ARG JDBC_DRIVER=postgresql-42.2.5.jar

RUN set -x \
    && apk --no-cache add --update curl xmlstarlet bash ttf-dejavu libc6-compat \
    && mkdir -p                "${CONF_HOME}" \
    && chmod -R 700            "${CONF_HOME}" \
    && chown daemon:daemon     "${CONF_HOME}" \
    && mkdir -p                "${CONF_INSTALL}/conf" \
    && curl -Ls                "https://www.atlassian.com/software/confluence/downloads/binary/atlassian-confluence-${CONF_VERSION}.tar.gz" | tar -xz --directory "${CONF_INSTALL}" --strip-components=1 --no-same-owner \
    && curl -Ls                "${JDBC_DL_PATH}${JDBC_DRIVER}" -o "${CONF_INSTALL}/confluence/WEB-INF/lib/${JDBC_DRIVER}" \
    && chmod -R 700            "${CONF_INSTALL}/conf" \
    && chmod -R 700            "${CONF_INSTALL}/temp" \
    && chmod -R 700            "${CONF_INSTALL}/logs" \
    && chmod -R 700            "${CONF_INSTALL}/work" \
    && chown -R daemon:daemon  "${CONF_INSTALL}/conf" \
    && chown -R daemon:daemon  "${CONF_INSTALL}/temp" \
    && chown -R daemon:daemon  "${CONF_INSTALL}/logs" \
    && chown -R daemon:daemon  "${CONF_INSTALL}/work" \
    && echo -e                 "\nconfluence.home=$CONF_HOME" >> "${CONF_INSTALL}/confluence/WEB-INF/classes/confluence-init.properties" \
    && xmlstarlet              ed --inplace \
        --delete               "Server/@debug" \
        --delete               "Server/Service/Connector/@debug" \
        --delete               "Server/Service/Connector/@useURIValidationHack" \
        --delete               "Server/Service/Connector/@minProcessors" \
        --delete               "Server/Service/Connector/@maxProcessors" \
        --delete               "Server/Service/Engine/@debug" \
        --delete               "Server/Service/Engine/Host/@debug" \
        --delete               "Server/Service/Engine/Host/Context/@debug" \
                               "${CONF_INSTALL}/conf/server.xml" \
    && touch -d "@0"           "${CONF_INSTALL}/conf/server.xml" \
    && chown daemon:daemon     "${JAVA_CACERTS}"

USER daemon:daemon

EXPOSE 8090 8091

WORKDIR ${CONF_HOME}

CMD ["/opt/atlassian/confluence/bin/start-confluence.sh", "-fg"]
