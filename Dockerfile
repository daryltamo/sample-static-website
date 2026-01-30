FROM nginx:1.29-alpine

LABEL maintainer="daryltamo" \
      project="Sample Static Website" \
      description="A simple static website served with Nginx."

# No need to install git or RUN git clone!
# GitLab CI already placed your files in the working directory.

WORKDIR /usr/share/nginx/html

# 1. Clean the default nginx files
RUN rm -rf ./*

# 2. Copy the files from your repo (the build context) 
# into the nginx html folder
COPY . .

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]