FROM bahmni/bahmni-web:1.1.0

COPY openmrs-module-bahmniapps/ui/app/ /tmp/bahmni-app/

RUN rm -rf /tmp/bahmni-app/components && rm -rf /usr/local/apache2/htdocs/bahmni && mv /tmp/bahmni-app /usr/local/apache2/htdocs/bahmni

COPY openmrs-module-bahmniapps/ui/node_modules/@bower_components/ /usr/local/apache2/htdocs/bahmni/components/