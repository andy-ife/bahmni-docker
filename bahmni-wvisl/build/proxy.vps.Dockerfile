FROM bahmni/proxy:1.1.0

COPY bahmni-docker/cert /etc/tls/

COPY bahmni-proxy/htdocs /usr/local/apache2/htdocs/

COPY proxy-conf /usr/local/apache2/conf/

ADD bahmni-docker/bahmni-wvisl/backups/bahmni-proxy-backup.tar.gz /usr/local/apache2/htdocs/