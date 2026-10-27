# Seeder for metabasedb. Base (postgres:15.1) declares VOLUME
# /var/lib/postgresql/data, so the backup rides at /seed/ and is extracted on
# first start by seed-volume.sh.
FROM postgres:15.1

COPY bahmni-docker/bahmni-wvisl/build/seed-volume.sh /seed/seed-volume.sh
COPY bahmni-docker/bahmni-wvisl/backups/metabase-data-backup.tar.gz /seed/metabase-data.tar.gz

RUN sed -i 's/\r$//' /seed/seed-volume.sh && chmod +x /seed/seed-volume.sh

ENV SEED_TAR=/seed/metabase-data.tar.gz
ENV SEED_TARGET=/var/lib/postgresql/data
ENV SEED_MARKER=/var/lib/postgresql/data/PG_VERSION

ENTRYPOINT ["/seed/seed-volume.sh", "docker-entrypoint.sh"]
CMD ["postgres"]
