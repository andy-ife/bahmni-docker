# bahmni-wvisl (VPS variant)

VPS-ready copy of `bahmni-standard` with unused services removed, `profiles:` removed (everything in this file always starts), and former host bind-mounts baked into images.

## Layout

* `docker-compose.yml` — pull-only. No `build:` blocks. VPS never builds.
* `.vps.env` — runtime settings. Passed via `--env-file .vps.env`.
* `build/*.vps.Dockerfile` — built on laptop, pushed to `andyife/*:vps-v1`, pulled by VPS.

## Build on laptop (context matters)

`COPY` sources in `build/*.vps.Dockerfile` are relative to the build context
`C:\Users\HP\JavaProjects` (i.e. `../..` from `bahmni-wvisl/`). Do not run
`docker build` from inside `build/`. Run from the context root:

```powershell
cd C:\Users\HP\JavaProjects
docker build -f bahmni-docker/bahmni-wvisl/build/proxy.vps.Dockerfile -t andyife/bahmni-proxy:vps-v1 .
docker build -f bahmni-docker/bahmni-wvisl/build/bahmni-config.vps.Dockerfile -t andyife/bahmni-config:vps-v1 .
docker build -f bahmni-docker/bahmni-wvisl/build/bahmni-web.vps.Dockerfile -t andyife/bahmni-web:vps-v1 .
docker build -f bahmni-docker/bahmni-wvisl/build/implementer-interface.vps.Dockerfile -t andyife/implementer-interface:vps-v1 .
docker build -f bahmni-docker/bahmni-wvisl/build/appointments.vps.Dockerfile -t andyife/appointments:vps-v1 .
docker push andyife/bahmni-proxy:vps-v1
docker push andyife/bahmni-config:vps-v1
docker push andyife/bahmni-web:vps-v1
docker push andyife/implementer-interface:vps-v1
docker push andyife/appointments:vps-v1
```

Sources used: `bahmni-docker/cert`, `bahmni-proxy/htdocs`, `proxy-conf`,
`bahmni-config`, `openmrs-module-bahmniapps/ui/...`,
`implementer-interface/dist`, `openmrs-module-appointments-frontend/dist`,
`bahmni-docker/bahmni-standard/bahmnni-config/start.sh`. Context is large;
expect a slow first send.

## Run on VPS (pull-only)

```sh
cd bahmni-wvisl
docker compose --env-file .vps.env pull
docker compose --env-file .vps.env up -d
docker compose --env-file .vps.env ps
docker compose --env-file .vps.env logs openmrs -f
```

Validate without starting: `docker compose --env-file .vps.env config --quiet`.

## Quirks / decisions

1. **Hydrate-once named volumes.** `tls-cert:/etc/tls` (`docker-compose.yml:21`)
   and `bahmni-config:/usr/local/bahmni_config` (`docker-compose.yml:33`) plus
   consumers (`openelis:40`, `openmrs:118`, `bahmni-web:221`, `reports:263`)
   rely on Docker copy-on-first-use: empty volume is seeded from the baked
   image on first `up`, then goes stale. Config/cert change requires:
   `docker volume rm bahmni-wvisl_tls-cert bahmni-wvisl_bahmni-config`
   (never `down -v`, that deletes DB data), then `up -d` again.
2. **Seed ordering.** Consumers have `depends_on: bahmni-config`
   (`docker-compose.yml:56,128,222,270`). This only orders start, not
   readiness. First boot: `up bahmni-config` first if consumers report
   missing config.
3. **`openelisdb:64` still bind-mounts `./openelis-db-dump`.** Path resolves
   to `bahmni-wvisl/openelis-db-dump` (currently missing; real dump is in
   `bahmni-standard/openelis-db-dump`). Docker creates an empty dir if absent.
   Intentional per owner; copy dump in before first `up` if OpenELIS needs seed.
4. **Removed services leave dead env.** `.vps.env` still defines
   `ODOO_*, ODOO_10_*, PACS_*, CDSS_*, SNOWSTORM_*, CONFIG_VOLUME,
   PROXY_HTDOCS_PATH, CERTIFICATE_PATH, APACHE_CONF_PATH,
   BAHMNI_APPS_PATH, IMPLEMENTER_INTERFACE_CODE_PATH, APPOINTMENTS_PATH`.
   Unused by this compose file. `reports` Odoo vars (`docker-compose.yml:257`)
   and `atomfeed-console` Odoo/PACS vars (`docker-compose.yml:315,322`)
   are commented out accordingly.
5. **Always-on analytics.** `metabasedb/metabase/martdb/mart` have no profiles
   and always start (~4 GB extra RAM). Remove them from the file if not needed.
6. **`bahmni-openmrs-modules:121` is an empty named volume.** If base
   `bahmni/openmrs` bakes modules there, first seeder wins; verify
   `/openmrs/data/modules/` is populated after first `up`.
7. **`version: "3.7"` (`docker-compose.yml:1`) is obsolete**, ignored by
   Compose v2 (warning only).
8. **`restart: on-failure:[3]` (`docker-compose.yml:152,163`)** is non-standard
   syntax; preferred `on-failure:3`. Currently accepted by `config`.
9. **`ipd:329` pins `container_name: ipd`** — prevents scaling/recreate
   with duplicate name.
10. **Secrets not rotated.** `.vps.env:81,91` etc. still defaults
    (`password`, `adminAdmin!123`, `clinlims`, `Admin123`). Rotate before
    exposing the VPS. Never `COPY` `.vps.env` into an image.

## Audit status

`docker compose --env-file .vps.env config --quiet` → exit 0, only `version`
obsolete warning. No undefined volumes. `openelis-db-data`,
`configuration-checksums`, `openmrs-db-data`, `reports-db-data` names are
consistent between service mounts and top-level `volumes:336-351`.
