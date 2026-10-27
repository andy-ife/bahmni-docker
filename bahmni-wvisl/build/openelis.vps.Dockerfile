FROM bahmni/openelis:1.0.0

# Copy web ui code
COPY bahmni-lab-web /run/bahmni-lab/bahmni-lab

ADD bahmni-docker/bahmni-wvisl/backups/bahmni-lab-results-backup.tar.gz /home/bahmni/uploaded_results/
ADD bahmni-docker/bahmni-wvisl/backups/bahmni-uploaded-files-backup.tar.gz /home/bahmni/uploaded-files/