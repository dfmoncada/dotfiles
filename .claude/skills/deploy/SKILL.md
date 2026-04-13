---
name: deploy
description: EZTask deployment workflow to GCP Cloud Run. Runs pre-flight checks, builds, deploys, and verifies. Usage - /deploy [backend|frontend|all]
allowed-tools: Bash, Read, Grep, Glob, WebFetch
model: sonnet
---

# Skill: deploy

Deploy EZTask services to GCP Cloud Run (project: eztask-app-dev, region: us-central1).

## Pre-flight checks (always run first)

1. Verify branch is clean (`command git status`)
2. Verify tests pass (`make test-backend` or skip with `--skip-tests`)
3. Check critical requirements:
   - `google-cloud-monitoring` in requirements.txt
   - `gcs_project` in celeryconfig.py
   - `gcloud auth list` shows correct account

## Deploy backend

```bash
cd backend
gcloud builds submit --config=cloudbuild.yaml .
```

Services deployed:
- `eztask-dev-web` — Gunicorn web server
- `eztask-dev-celery` — Celery workers

## Deploy frontend

```bash
cd frontend/apj-backoffice
yarn build
# Upload to GCS bucket
gcloud storage cp -r build/* gs://dev.getisi.ai/
```

Or via Cloud Run:
```bash
cd backend/scripts/gcp-infrastructure/deployment
./deploy-frontend-to-run.sh
```

## Post-deploy verification

```bash
# Check services
gcloud run services list --region=us-central1

# Check for errors (wait 2 min)
gcloud logging read 'resource.type=cloud_run_revision AND severity>=ERROR' --limit=10 --format="table(timestamp,textPayload)" --freshness=5m

# Verify celery workers ready
gcloud logging read 'resource.type=cloud_run_revision AND resource.labels.service_name=eztask-dev-celery AND textPayload:"ready"' --limit=3 --format="value(timestamp,textPayload)"
```

## Run DB migration on Cloud Run

```bash
cd backend/scripts/gcp-infrastructure/deployment
./run-migration.sh
```

## Commands

### /deploy backend
Run pre-flight checks, deploy backend via cloudbuild, verify services.

### /deploy frontend
Build React app, upload to GCS, verify.

### /deploy all
Deploy backend first, then frontend. Run migration if pending.

### /deploy status
Check current Cloud Run service status and recent errors.

## Important

- Always notify via Telegram after deploy completes (use /notify skill)
- Reference: `backend/scripts/gcp-infrastructure/DEPLOYMENT_CHECKLIST.md`
- Never deploy from a dirty working tree
- The deploy runs from `backend/` directory
