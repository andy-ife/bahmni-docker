# Seeder for openelisdb. Base declares VOLUME /var/lib/postgresql/data, so the
# backup rides at /seed/ and is extracted on first start by seed-volume.sh.
FROM bahmni/openelis-db:1.0.0-standard

COPY bahmni-docker/bahmni-wvisl/build/seed-volume.sh /seed/seed-volume.sh
COPY bahmni-docker/bahmni-wvisl/backups/openelisdbdata-backup.tar.gz /seed/openelisdbdata.tar.gz

RUN sed -i 's/\r$//' /seed/seed-volume.sh && chmod +x /seed/seed-volume.sh

ENV SEED_TAR=/seed/openelisdbdata.tar.gz
ENV SEED_TARGET=/var/lib/postgresql/data
ENV SEED_MARKER=/var/lib/postgresql/data/PG_VERSION

ENTRYPOINT ["/seed/seed-volume.sh", "docker-entrypoint.sh"]
CMD ["postgres"]
