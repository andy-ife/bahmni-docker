# Seeder for reports file store. Base declares no VOLUMEs, so the backup tar is
# baked directly and seeds the named volume via hydrate-once.
FROM bahmni/reports:1.1.0

ADD bahmni-docker/bahmni-wvisl/backups/bahmni-queued-reports-backup.tar.gz /home/bahmni/reports/
