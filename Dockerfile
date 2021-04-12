FROM docker.elastic.co/elasticsearch/elasticsearch:7.12.0

LABEL maintainer="d8sychain"

COPY --chown=elasticsearch:elasticsearch root/ /

RUN chmod +x /usr/local/bin/docker-entrypoint.sh /usr/local/bin/sub-entrypoint.sh

# environment settings
ENV ES_PATH_CONF=/config
ENV path.data=/config/data
ENV path.logs=/config/logs
ENV discovery.type=single-node
ENV ES_JAVA_OPTS="-Xms1g -Xmx1g"

# ports and volumes
EXPOSE 9200 9300
VOLUME /config

# docker run flag, add to template --ulimit nofile=262144:262144
