################################################################################
# Copyright (C) Veea Systems Limited - All Rights Reserved.
# Unauthorised copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential. [2019-2020]
################################################################################


#BEGIN vhc05
FROM arm32v7/alpine:3.9
#END

#BEGIN vhx09-10
FROM arm64v8/alpine:latest
#END

RUN mkdir /app
COPY src/ /app

RUN apk add --no-cache bash

LABEL com.veea.authorisation.allowExternalStorage="true"

WORKDIR /var/lib/veea

# CMD ["./app/storage-example.sh"]
