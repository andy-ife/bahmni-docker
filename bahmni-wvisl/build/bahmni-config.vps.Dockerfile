FROM bahmni/standard-config:1.0.0

COPY bahmni-config /usr/local/bahmni_config

ADD bahmni-docker/bahmni-wvisl/backups/bahmni-config-backup.tar.gz /usr/local/bahmni_config/

COPY bahmni-docker/bahmni-standard/bahmnni-config/start.sh /start.sh

RUN chmod +x /start.sh