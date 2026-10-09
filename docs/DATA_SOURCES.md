# Data sources and licensing

## What the platform uses

Only synthetic data produced by `rpi/synth`. The retailers (`baku_fresh`, `caspianmart`, `absheron`, `shirvan`, `sumqayit`), brands, product catalogue and prices are invented. The feed *formats* imitate the kinds of variation real retail feeds show (JSONL, JSON array, CSV; decimal strings, float AZN, integer qepik; Azerbaijani, Russian and English category labels; barcodes missing or mistyped). The same seed always produces byte-identical files, so every number in the documentation is reproducible.

Nothing in the generator or the pipeline contacts a retailer or any third-party site.

## Adding a real source

1. Obtain the feed under an agreement or licence that permits the intended use.
2. Add a parser in `rpi/silver/parsers.py` mapping the payload to `Parsed` (money to integer qepik).
3. Register the retailer in `rpi/reference/retailers.csv` and map its category labels in `rpi/reference/category_map.csv`.
4. Drop files named `<source>_<YYYY-MM-DD>.<ext>` into the landing directory.

## The earlier prototype in this repository

The repository began as **qiymət**, a Flutter and FastAPI app with a SQLite prototype pipeline (`pipeline/`, `api/`, `app/`, `db/`, `checks/`, `notify/`, `deploy/`). The platform uses two of its text parsers (`pipeline/units.py`, `pipeline/fingerprint.py`, loaded by `rpi/legacy.py`) and nothing else; the Docker image copies only those two files.

That prototype was fed by scraping retailer and delivery-platform storefronts. Its own documentation (`pipeline/README.md`) says this breaches their terms of use and that production use needs retailer-supplied feeds. Files in this repository that derive from that collection:

| Path | What it is |
|---|---|
| `pipeline/qiymet.db` | SQLite snapshot: about 57,000 listings, 36,000 products, prices and match audit for six real chains |
| `pipeline/raw/bazarstore_ean.json` | 19,410 product-id to barcode pairs from one retailer |
| `pipeline/raw/wolt_all.json` | small sample of delivery-platform items |
| `demo.html` | demo page with embedded real prices |
| `match_queue.csv`, `promo_honesty.csv`, `pipeline/promo_honesty.csv` | exports of that data |
| `pipeline/wolt.py`, `pipeline/pipeline.py`, `pipeline/run.py`, `deploy/scripts/run-crawl.sh` | the collection code |

They must not be published. See [`SECURITY_AUDIT.md`](SECURITY_AUDIT.md) for the full audit and the public-release plan.
