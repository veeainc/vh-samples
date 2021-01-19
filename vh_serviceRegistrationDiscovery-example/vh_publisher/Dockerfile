################################################################################
# Copyright (C) Veea Systems Limited - All Rights Reserved.
# Unauthorised copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential. [2019-2020]
################################################################################

#BEGIN vhc05
FROM arm32v7/alpine:3.9
ENV ARCH="arm-"
#END

#BEGIN vhx09-10
FROM arm64v8/alpine:3.9
ENV ARCH="arm64-"
#END

WORKDIR /app
COPY src/ /app/

RUN apk --update --no-cache add wget curl redis

RUN wget -q $(curl -s https://api.github.com/repos/veeainc/vbus-cmd/releases/tags/v1.5.0 | grep browser_download_url | grep "$ARCH" | cut -d '"' -f 4) && \
	mv "elf-linux-"$ARCH"vbus-cmd" /usr/bin/vbus-cmd && \
	chmod 777 /usr/bin/vbus-cmd && \
	chmod -R 777 /app

ENV VBUS_PATH=/var/lib/veea/vbus 

CMD ["/app/start.sh"]