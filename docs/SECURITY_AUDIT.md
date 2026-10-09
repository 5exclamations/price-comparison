# Security and data audit

Scope: all 494 tracked files and all 17 commits of this repository, audited on 2026-10-09 before preparing a public portfolio release.

## Method

| Check | Tool | Result |
|---|---|---|
| Secrets in full git history (17 commits) | gitleaks 8.21.2, default rules | no leaks found |
| Secrets in the working tree | gitleaks (no-git mode), detect-secrets | gitleaks: none; detect-secrets: 12 hits, all false positives (see below) |
| Sensitive file names ever tracked | `git log --all --name-only` filtered for `.env`, keys, keystores, service accounts, tfstate | only `.env.example` and `deploy/.env.example`, both placeholder templates |
| Hard-coded credentials in source | regex over Python, Dart, shell, YAML, Terraform, Gradle | none |
| Large or binary blobs in history | `git cat-file --batch-check` | `pipeline/qiymet.db` (27 MB), `demo.html` (1.5 MB), `pipeline/raw/bazarstore_ean.json` (0.6 MB) |
| Python dependency vulnerabilities | pip-audit | none known |
| Personal data | author history, e-mail addresses in files | one author e-mail in commit metadata (17 commits) |

detect-secrets false positives: development credentials `rpi:rpi` in `.env.example`, `docker-compose.yml`, `docker/rpi.Dockerfile`, `rpi/config.py`, workflow files and `README.md`; the same pattern in the legacy `ci.yml` and `deploy/dev/local-api.sh`; hex digests in iOS project files; a base64-looking string in `demo.html`. None is a live secret.

## Findings

### F1 (high, provenance): scraped third-party data is committed

`pipeline/qiymet.db` is a SQLite database of about 57,000 listings from six real supermarket chains with prices, barcodes and product images URLs, plus a match audit. `pipeline/raw/bazarstore_ean.json` holds 19,410 barcode mappings from one retailer. `demo.html`, `match_queue.csv`, `promo_honesty.csv` and `pipeline/promo_honesty.csv` are derived exports. The legacy documentation states that the data was collected by scraping storefronts, in breach of their terms of use. Publishing these files, or the history that contains them, risks a terms-of-use or database-rights complaint and attaches real chain names to price claims.

Action: kept in this private repository untouched. Excluded from the clean public repository, which is initialised without this history. Decision on deleting them here (and rewriting history) is left to the owner.

### F2 (high, provenance): scraping components

`pipeline/wolt.py`, `pipeline/pipeline.py` (Shopify and delivery-platform connectors), `pipeline/run.py` and `deploy/scripts/run-crawl.sh` automate the collection, including request headers chosen to be accepted by a private API. Excluded from the public repository.

### F3 (medium, secure by default): the write endpoint was open when no key was set

`require_key` skipped authentication whenever `RPI_API_KEY` was unset, so a deployment that forgot the variable accepted unauthenticated writes, and the client chose the recorded reviewer name. **Fixed:** writes now fail closed (HTTP 503 until a key of at least 16 characters is configured, 401 for a missing or wrong key, constant-time comparison), the reviewer is always `api`, the dashboard's approve and reject buttons are disabled unless `RPI_DASHBOARD_ALLOW_REVIEW=1`, and `docker-compose.yml` passes an empty key by default. Tests cover each case.

### F4 (medium, documentation): README claimed no restricted data

The README said no restricted data was included while the files in F1 remained. **Fixed:** README and `docs/DATA_SOURCES.md` now list the files and the risk.

### F5 (low): author e-mail in commit metadata

All commits carry the owner's personal e-mail. Normal for a private repository; the public repository uses the GitHub no-reply address.

### F6 (low): legacy deploy files contain operational detail

`deploy/` documents a hosting provider, a placeholder domain and a private LAN address in examples; no secret. Excluded from the public repository.

### F7 (info): legacy commit messages contain automated-assistant trailers

Earlier commits include `Co-Authored-By` trailers. Not a security issue; a reason to start the public history fresh.

## Added controls

* `.github/workflows/security.yml`: gitleaks over full history with a checksum-pinned binary, and pip-audit, on every push, pull request and weekly.
* `.gitleaks.toml`, `.pre-commit-config.yaml` (gitleaks and ruff), `.github/dependabot.yml` (pip, actions, docker).

## Public-release plan

The platform is released from a separate, independently initialised repository (no shared history) containing only reviewed platform files. The owner decides whether and when to publish it; the legacy files stay private.
