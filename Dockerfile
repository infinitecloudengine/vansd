## Docker version 17.09.0-ce
FROM library/alpine
# Nginx details :: https://wiki.alpinelinux.org/wiki/Nginx
COPY nginx/repositories /etc/apk/repositories
RUN /bin/sh -c 'apk update'
RUN /bin/sh -c 'apk add nginx --no-cache'
RUN /bin/sh -c 'apk add openrc --no-cache'
RUN /bin/sh -c 'mkdir /run/nginx'
RUN /bin/sh -c 'mkdir /www'
COPY nginx/index.html /www/index.html
RUN /bin/sh -c 'cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.sav'
RUN /bin/sh -c 'cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.sav'
RUN /bin/sh -c 'chown -R nginx:nginx /www'
RUN /bin/sh -c 'chown -R nginx:nginx /var/log/nginx'
RUN /bin/sh -c 'chown -R nginx:nginx /var/tmp/nginx'
RUN /bin/sh -c 'chown -R nginx:nginx /run/nginx'
RUN /bin/sh -c 'chown -R nginx:nginx /etc/nginx'
COPY nginx/nginx.conf /etc/nginx/nginx.conf
RUN /bin/sh -c 'nginx -t'
CMD ["nginx", "-g", "daemon off;"]

EXPOSE 8080
