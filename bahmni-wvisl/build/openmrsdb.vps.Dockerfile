# Seeder for openmrsdb. Base declares VOLUME /var/lib/mysql, so data cannot be
# baked with ADD (it would be discarded); the backup rides at /seed/ and is
# extracted on first start by seed-volume.sh. Checksums path has no VOLUME,
# so it is baked directly and seeds the shared volume via hydrate-once.
FROM bahmni/openmrs-db:1.0.0-standard

COPY bahmni-docker/bahmni-wvisl/build/seed-volume.sh /seed/seed-volume.sh
COPY bahmni-docker/bahmni-wvisl/backups/openmrsdbdata-backup.tar.gz /seed/openmrsdbdata.tar.gz
ADD bahmni-docker/bahmni-wvisl/backups/configuration_checksums-backup.tar.gz /configuration_checksums/

RUN sed -i 's/\r$//' /seed/seed-volume.sh && chmod +x /seed/seed-volume.sh

ENV SEED_TAR=/seed/openmrsdbdata.tar.gz
ENV SEED_TARGET=/var/lib/mysql
ENV SEED_MARKER=/var/lib/mysql/mysql

ENTRYPOINT ["/seed/seed-volume.sh", "docker-entrypoint.sh"]
CMD ["mysqld"]
