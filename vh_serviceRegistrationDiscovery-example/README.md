Service Registration and Discovery Sample
===========================================

## Objective:

The objective of this sample project is to explain the concept of Service Registration and Discovery. In this project, we use vbus-cmd to register and discover services on vBus

There are three applications in this project:

1. Publisher

2. Redis Server

3. Consumer


![](.//media/image1.png)

**Redis-server**: It registers/exposes its Service URI whenever its container is started. 

**Publisher**: It will discover the Redis Server URI and start incrementing and setting the “myCounter” value in Redis-server at a set time interval(eg. 30 seconds)

**Consumer**: Like Publisher, Consumer also discover the Redis Server URI but instead of updating the “myCounter“ value, it reads it from Redis at a set time interval (eg. 30 seconds)