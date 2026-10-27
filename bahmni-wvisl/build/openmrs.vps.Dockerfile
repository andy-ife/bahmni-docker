# Seeder for openmrs file stores. Base declares no VOLUMEs, so backup tars are
# baked directly and seed the named volumes via hydrate-once.
FROM bahmni/openmrs:2.0.0

ADD bahmni-docker/bahmni-wvisl/backups/bahmni-patient-images-backup.tar.gz /home/bahmni/patient_images/
ADD bahmni-docker/bahmni-wvisl/backups/bahmni-document-images-backup.tar.gz /home/bahmni/document_images/
ADD bahmni-docker/bahmni-wvisl/backups/bahmni-clinical-forms-backup.tar.gz /home/bahmni/clinical_forms/
ADD bahmni-docker/bahmni-wvisl/backups/bahmni-lab-results-backup.tar.gz /home/bahmni/uploaded_results/
ADD bahmni-docker/bahmni-wvisl/backups/bahmni-uploaded-files-backup.tar.gz /home/bahmni/uploaded-files/
ADD bahmni-docker/bahmni-wvisl/backups/sms-token-backup.tar.gz /openmrs/data/sms-token/
