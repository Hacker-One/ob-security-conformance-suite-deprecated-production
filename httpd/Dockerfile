FROM reg.qloudhub.com/debian:stretch
RUN apt-get update \
	&& apt-get install -y apache2 ssl-cert \
	&& apt-get clean
RUN \
	echo 'Listen 8443' > /etc/apache2/ports.conf \
	&& a2enmod headers proxy proxy_ajp proxy_http rewrite ssl \
	&& a2dissite 000-default.conf
COPY server-static.conf /etc/apache2/sites-enabled
RUN chmod -R a+rw /etc/apache2/sites-enabled/server-static.conf
COPY start.sh /etc/apache2/sites-enabled/start.sh
RUN chmod u+x /etc/apache2/sites-enabled/start.sh
COPY resources/ /usr/local/apache2/htdocs/

RUN chmod u+x /etc/ssl/certs/ssl-cert-snakeoil.pem
RUN chmod u+x /etc/ssl/private/ssl-cert-snakeoil.key
CMD ["/etc/apache2/sites-enabled/start.sh"]
