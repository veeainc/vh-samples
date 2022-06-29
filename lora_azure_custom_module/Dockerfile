################################################################################
# Copyright (C) Veea Systems Limited - All Rights Reserved.
# Unauthorised copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential. [2022-2023]
################################################################################
#BEGIN vhx09-10
FROM arm64v8/alpine:3.9 as test
#END

RUN mkdir /app
COPY src/  /app/

WORKDIR /app
RUN chmod -R 777 /app
RUN apk update


RUN apk -U --allow-untrusted add python3 python3-dev curl wget && \
    python3 -m venv /app/myapp/venv3 && \
    source /app/myapp/venv3/bin/activate && \
    pip3 install asyncio azure-iot-device

RUN wget -q $(curl -s https://api.github.com/repos/veeainc/vbus-cmd/releases/tags/v1.5.2 | grep browser_download_url | grep 'arm64' | cut -d '"' -f 4) && \
	mv /app/elf-linux-arm64-vbus-cmd vbus-cmd && \
	chmod 777 vbus-cmd


#BEGIN vhx09-10
FROM arm64v8/alpine:3.9
#END

WORKDIR /app

RUN apk update && \
    apk -U --allow-untrusted add python3 python3-dev

COPY --from=test /app/ /app/
COPY --from=test /app/vbus-cmd /usr/bin/vbus-cmd
RUN chmod -R 777 /app

ENV VBUS_PATH=/app/

CMD ["/app/start.sh"]