################################################################################
# Copyright (C) Veea Systems Limited - All Rights Reserved.
# Unauthorised copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential. [2019-2020]
################################################################################
#BEGIN vhc05
FROM arm32v7/alpine:3.11.2
ENV ARCH="arm-"
#END

#BEGIN vhx09-10
FROM arm64v8/alpine:3.11.2
ENV ARCH="arm64-"
#END

RUN apk --no-cache update
RUN apk add redis wget curl jq
# Updating the redis configuration file
RUN sed -i 's/protected-mode yes/protected-mode no/g' /etc/redis.conf && \
	sed -i 's/save 900 1/save 60 1/g' /etc/redis.conf && \
	sed -i 's/bind 127.0.0.1/#bind 127.0.0.1/g' /etc/redis.conf && \
	sed -i 's/unixsocket /#unixsocket /g' /etc/redis.conf && \
	sed -i 's/unixsocketperm /#unixsocketperm /g' /etc/redis.conf && \
	sed -i 's#logfile /var/log/redis/redis.log#logfile /var/lib/veea/vh_redis/redis-server.log #g' /etc/redis.conf && \
	sed -i 's#dir /var/lib/redis#dir /var/lib/veea/vh_redis #g' /etc/redis.conf

WORKDIR /app
COPY src/ /app

RUN wget -q $(curl -s https://api.github.com/repos/veeainc/vbus-cmd/releases/tags/v1.5.0 | grep browser_download_url | grep "$ARCH" | cut -d '"' -f 4) && \
	mv "elf-linux-"$ARCH"vbus-cmd" /usr/bin/vbus-cmd && \
	chmod 777 /usr/bin/vbus-cmd && \
	chmod -R 777 /app

ENV VBUS_PATH=/var/lib/veea/vbus

EXPOSE 6379

CMD ["/app/start.sh"]