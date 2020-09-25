################################################################################
# Copyright (C) Veea Systems Limited - All Rights Reserved.
# Unauthorised copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential. [2019-2020]
################################################################################


#BEGIN vhc05
FROM balenalib/armv7hf-alpine-golang:latest-build as builder
#END

#BEGIN vhx09-10
FROM balenalib/aarch64-alpine-golang:latest-build as builder
#END


RUN apk --update --no-cache add bash build-base

RUN [ "cross-build-start" ]

COPY ./src ./src/

RUN gcc ./src/helloworld.c -o /bin/helloworld

RUN [ "cross-build-end" ]


#BEGIN vhc05
FROM balenalib/armv7hf-alpine:latest-run
#END

#BEGIN vhx09-10
FROM balenalib/aarch64-alpine:latest-run
#END

COPY ./run.sh /run.sh

RUN chmod +x /run.sh

COPY --from=builder /bin/helloworld /bin/helloworld

CMD ["sh", "run.sh"]