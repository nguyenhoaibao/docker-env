FROM centos:6.6

MAINTAINER baonh <nhbao.la@gmail.com>

# Install nginx package
RUN rpm -Uvh http://nginx.org/packages/rhel/6/noarch/RPMS/nginx-release-rhel-6-0.el6.ngx.noarch.rpm
RUN yum install nginx -y

COPY ./nginx.conf /etc/nginx/
COPY ./docker.server.conf /etc/nginx/conf.d/

RUN mkdir -p /var/log/nginx && \
	chown -R nginx:nginx /var/log/nginx

# Forward error logs to docker log collector
RUN ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

CMD ["nginx"]
