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

The repository began as **qiymət**, a Flutter and FastAPI app with a SQLite prototype pipeline (`pipeline/`, `api/`, `app/`, `db/`, `checks/`, `notify/`, `deploy/`). It is kept for history and is not used by the platform except for two text parsers (`pipeline/units.py`, `pipeline/fingerprint.py`) that `rpi/legacy.py` loads. Docker images for the platform copy only those two files.

That prototype's own documentation (`pipeline/README.md`) states that its data collection scraped retailer and delivery-platform storefronts, that this breaches their terms of use, and that production use needs retailer-supplied feeds. The repository also contains a snapshot database and CSV/HTML exports derived from that collection. Before making the repository public, review whether those artifacts may be published and remove them (including from git history) if not. The platform does not depend on them.
