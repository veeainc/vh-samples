################################################################################
# Copyright (C) Veea Systems Limited - All Rights Reserved.
# Unauthorised copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential. [2019-2020]
################################################################################


#BEGIN vhc05
FROM balenalib/armv7hf-alpine:latest-run
#END

#BEGIN vhx09-10
FROM balenalib/aarch64-alpine:latest-run
#END

RUN mkdir /app

COPY src/ /app

RUN apk add --no-cache bash

LABEL com.veea.authorisation.allowExternalStorage="true"

ENV LOCALFILE="logo-veea-inc.png"

RUN chmod 777 /app/${LOCALFILE}

WORKDIR "/var/lib/veea/external_storage"

CMD ["/bin/bash", "/app/storage-example.sh"]