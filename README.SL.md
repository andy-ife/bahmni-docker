## SIERRA LEONE EMR - WHITE LABELLING GUIDE

We needed to make it easy to change icons, images, fonts, and colors for the system to support changing ownership.

We use locally built Docker images for certain UI containers:
- config

And custom project paths for others:
- appointments
- implementer-interface
- openmrs-module-bahmniapps
- config
- proxy

`config` is unique in that we need both a locally built Docker image, and a custom project path.

### Appointments, Implementer-interface, and Openmrs-module-bahmniapps,

Simply clone and build the respective projects and update the relevant path variable in docker compose. Customize the respective projects with fonts, colors, images, icons, and functionality as needed.

### Config

**One time only:** Build the image using Dockerfile in bahmni-standard/bahmni-config and deploy to the docker compose file.

Set CONFIG_OPENMRS_APPS_PATH in the .env and in docker compose.
`bahmni-config` is used for white labelling including 
- landing page header text
- landing page title text
- landing page icons
- show/hide login page text

### Proxy
Set PROXY_HTDOCS_PATH in the .env and in docker compose
Like `bahmni-config`, `proxy` is used for white labelling, but mainly for the landing page and some app-wide components:
- landing page font style
- landing page footer text
- default error page
- since proxy container is loaded first, everything in config should be replicated here so that it prevents a flash of wrong content/placeholders at the start of the app, before config takes over and replaces placeholders with the correct content


### SIERRA LEONE EMR - BAHMNI CONNECT GUIDE
I added the bahmni-offline sync omod to the openmrs container. I also added a volume mount called bahmni-openmrs-modules. WE should write a Dockerfile to bake this omod into the openmrs image itself.

Next, build the event-log-service jar or Dockerize it and run

Add Bahmni connect UI to openmrs web apps

Setup Bahmni offline mobile app
