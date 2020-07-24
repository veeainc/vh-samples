################################################################################
# Copyright (C) Veea Systems Limited - All Rights Reserved.
# Unauthorised copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential. [2019-2020]
################################################################################

FROM golang:1.8-alpine as build

RUN mkdir /app
COPY src/ /app/
WORKDIR /app

#BEGIN vhc05
FROM arm32v7/busybox
#END
#BEGIN vhx09-10
FROM arm64v8/busybox
#END
EXPOSE 9500
ENV PORT 9500
ENV WELCOME_MESSAGE Welcome to the VeeaHub platform!

LABEL com.veea.authorisation.allowExternalStorage="true"

WORKDIR /example
COPY --from=build /app /app

CMD ["bash /app/storage-example.sh"]
