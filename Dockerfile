FROM ubuntu:22.04

LABEL maintainer="daryltamo" \
        project="Sample Static Website" \
        description="A simple static website served with Nginx in a Docker container."

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y nginx git

RUN rm -rf /var/www/html/*

ADD  . /var/www/html/

EXPOSE 80

ENTRYPOINT [ "/usr/sbin/nginx", "-g", "daemon off;" ]
