FROM nginx:alpine

LABEL maintainer="simotamoed@gmail.com" \
        project="Sample Static Website" \
        description="A simple static website served with Nginx in a Docker container."

RUN apk update && rm -rf /usr/share/nginx/html/*

ADD  . /usr/share/nginx/html/

EXPOSE 80

ENTRYPOINT [ "/usr/sbin/nginx", "-g", "daemon off;" ]