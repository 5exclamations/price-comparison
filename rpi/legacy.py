"""Bridge to the original pipeline's text parsers.

pipeline/units.py (Azerbaijani unit parsing: ``qr`` = grams, bare ``kq`` = weighed, ``7 Lİ`` = pack of 7)
and pipeline/fingerprint.py (name fingerprints) are proven against real catalogues, so they are reused
rather than rewritten. They use sibling-style imports (``import units``), hence the explicit loader.
"""

from __future__ import annotations

import importlib.util
import sys
from types import ModuleType

from rpi.config import ROOT

_PIPELINE = ROOT / "pipeline"


def _load(name: str) -> ModuleType:
    if name in sys.modules:
        return sys.modules[name]
    spec = importlib.util.spec_from_file_location(name, _PIPELINE / f"{name}.py")
    assert spec and spec.loader
    module = importlib.util.module_from_spec(spec)
    sys.modules[name] = module
    spec.loader.exec_module(module)
    return module


units = _load("units")
fingerprint = _load("fingerprint")
