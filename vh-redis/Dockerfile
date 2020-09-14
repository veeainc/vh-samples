#BEGIN vhc05
FROM arm32v7/alpine:3.9
#END


RUN apk update
RUN apk upgrade
RUN apk add --no-cache redis
RUN sed -i 's/protected-mode yes/protected-mode no/g' /etc/redis.conf
RUN sed -i 's/save 900 1/save 60 1/g' /etc/redis.conf
RUN sed -i 's/bind 127.0.0.1/#bind 127.0.0.1/g' /etc/redis.conf
RUN sed -i 's/unixsocket /#unixsocket /g' /etc/redis.conf
RUN sed -i 's/unixsocketperm /#unixsocketperm /g' /etc/redis.conf
RUN sed -i 's/logfile /#logfile /g' /etc/redis.conf
RUN sed -i 's/dir /#dir /g' /etc/redis.conf

WORKDIR /var/lib/veea/redis-volume
LABEL com.docker.stack.namespace="vhdeploy"
EXPOSE 6379
CMD ["redis-server","/etc/redis.conf"]
