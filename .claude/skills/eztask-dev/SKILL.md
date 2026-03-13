---
name: eztask-dev
description: Common development workflows for the EZTask project. Stack management, testing, database, and debugging commands.
allowed-tools: Read, Bash, Grep, Glob
---

# Skill: eztask-dev

Common development workflows for the EZTask project.

## Quick Commands

### Stack Management
- **Start dev**: `make quick-start` (backend services only) or `make start` (full stack)
- **Restart crashed workers**: `docker compose up -d --force-recreate celery-email celery-scheduler celery`
- **Check health**: `docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"`
- **View logs**: `docker compose logs -f --tail=50 <service>`

### Testing
- **Run all backend tests**: `python test_runner.py`
- **Run specific test**: `python test_runner.py src/tests/test_file.py`
- **Run with debug**: `python test_runner.py -s src/tests/test_file.py`
- **Test by module**: `make test-email`, `make test-auth`, `make test-shopify`, `make test-crm`, `make test-quota`

### Database
- **Migrate**: `make migrate`
- **New migration**: `make migrate-create MSG="description"`
- **DB shell**: `docker exec -it postgres-db psql -U ezTask -d ezTask`

### Service Architecture
- **Backend**: Flask + SQLAlchemy, port 8000
- **Workers**: 3 Celery workers (email=4, scheduler=2, general=2 in dev)
- **DB**: PostgreSQL 17.5, Redis for broker/cache

## Workflow: Add New Feature

1. Create/update model in `src/models/`
2. Create migration: `make migrate-create MSG="add feature X"`
3. Run migration: `make migrate`
4. Create service in `src/services/` (business logic)
5. Create thin route in `src/routes/` (HTTP handling only)
6. Write tests in `src/tests/`
7. Run tests: `python test_runner.py src/tests/test_new_feature.py`

## Workflow: Debug Celery Task

1. Check worker logs: `docker compose logs -f celery-email`
2. Check Redis queue: `docker exec redis-server redis-cli LLEN celery`
3. Check task result: `docker exec redis-server redis-cli GET celery-task-meta-<task-id>`

## Common Issues

- **Workers crashing**: Usually missing dependency. Rebuild: `docker compose build celery-email && docker compose up -d celery-email`
- **GCS errors**: Credentials files are placeholders in dev. App handles gracefully (bucket=None).
- **Docker mount errors**: Use directory mounts via `docker-compose.override.yml` instead of individual file mounts.
- **.env missing**: Extract from running web container: `docker exec gunicorn-web env`
