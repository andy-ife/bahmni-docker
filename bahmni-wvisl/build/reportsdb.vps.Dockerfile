# Seeder for reportsdb. Base (mysql:8.0) declares VOLUME /var/lib/mysql, so the
# backup rides at /seed/ and is extracted on first start by seed-volume.sh.
FROM mysql:8.0

COPY bahmni-docker/bahmni-wvisl/build/seed-volume.sh /seed/seed-volume.sh
COPY bahmni-docker/bahmni-wvisl/backups/reportsdbdata-backup.tar.gz /seed/reportsdbdata.tar.gz

RUN sed -i 's/\r$//' /seed/seed-volume.sh && chmod +x /seed/seed-volume.sh

ENV SEED_TAR=/seed/reportsdbdata.tar.gz
ENV SEED_TARGET=/var/lib/mysql
ENV SEED_MARKER=/var/lib/mysql/mysql

ENTRYPOINT ["/seed/seed-volume.sh", "docker-entrypoint.sh"]
CMD ["mysqld"]
