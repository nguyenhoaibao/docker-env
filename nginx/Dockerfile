FROM centos:6.6

MAINTAINER baonh <nhbao.la@gmail.com>

# Install nginx package
#RUN rpm -Uvh http://mirrors.digipower.vn/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm
RUN rpm -Uvh http://nginx.org/packages/rhel/6/noarch/RPMS/nginx-release-rhel-6-0.el6.ngx.noarch.rpm
RUN yum install nginx -y

# Install php
#RUN rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm
#RUN yum --enablerepo=remi,remi-php56 install php-fpm php-common php-cli php-pear php-pdo php-mysqlnd php-pgsql php-pecl-mongo php-sqlite php-pecl-memcache php-pecl-memcached php-gd php-mbstring php-mcrypt php-xml -y

COPY ./nginx.conf /etc/nginx/
#COPY ./www.conf /etc/php-fpm.d/
COPY ./docker.server.conf /etc/nginx/conf.d/

RUN mkdir -p /var/log/nginx && \
	chown -R nginx:nginx /var/log/nginx

VOLUME [ "/var/log/nginx" ]

EXPOSE 80

CMD ["nginx"]
