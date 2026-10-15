FROM bahmni/proxy:1.1.0

COPY bahmni-docker/cert /etc/tls/

COPY bahmni-proxy/htdocs /usr/local/apache2/htdocs/

COPY proxy-conf /usr/local/apache2/conf/