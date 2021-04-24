FROM alpine:3.13.1
MAINTAINER acshmily<npc@newbie.town>
ENV FILEBEAT_VERSION=6.5.1 \
    FILEBEAT_SHA1=81d9de4bc33958bf086c67196d20f2fdebb53dbad92fab6d0f07104d6becb38f80e36fe763e3f270c7beb4235f12ad4648baf3077e25f8badc235d41ddf04b2a \
    TZ=Asia/Shanghai
WORKDIR /opt
RUN echo http://mirrors.aliyun.com/alpine/v3.13/main/ > /etc/apk/repositories \
    && echo http://mirrors.aliyun.com/alpine/v3.13/community/ >> /etc/apk/repositories  \
    && apk update && apk add ca-certificates && apk add tzdata && cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone &&\
    apk add wget bash libc6-compat && \
      wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz -O /opt/filebeat.tar.gz && \
          cd /opt && \
          echo "${FILEBEAT_SHA1}  filebeat.tar.gz" | sha512sum -c - && \
          tar xzvf filebeat.tar.gz && \
          cd filebeat-* && \
          cp filebeat /bin && \
          cd /opt && \
          rm -rf filebeat* && \
          apk del tzdata wget && \
          rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
