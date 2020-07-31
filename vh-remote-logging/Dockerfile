################################################################################
# Copyright (C) Veea Systems Limited - All Rights Reserved.
# Unauthorised copying of this file, via any medium is strictly prohibited.
# Proprietary and confidential. [2019-2020]
################################################################################

#BEGIN vhc05
FROM arm32v7/python:3.7-alpine
#END

#BEGIN vhx09-10
FROM arm64v8/python:3.7-alpine
#END

RUN mkdir /app
COPY src/ /app/
WORKDIR /app

CMD ["python", "loop.py"]

