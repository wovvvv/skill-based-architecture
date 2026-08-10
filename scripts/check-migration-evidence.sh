#!/usr/bin/env bash
# Validate source-instruction disposition and activation evidence for a migration.

set -euo pipefail

usage() {
  cat <<'EOF'
Usage: bash scripts/check-migration-evidence.sh --root <project-root> --manifest <evidence.json>

The JSON manifest inventories decision-changing source clauses and gives each
exactly one mapped or excluded disposition. Verbatim mappings are checked
directly. Faithful rewrites require recorded review evidence; this script checks
that evidence is complete but does not pretend string matching proves semantic
equivalence.
EOF
}

ROOT_PATH=""
MANIFEST_PATH=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --root)
      [[ $# -ge 2 ]] || { echo "Missing value for --root" >&2; exit 2; }
      ROOT_PATH="$2"
      shift 2
      ;;
    --manifest)
      [[ $# -ge 2 ]] || { echo "Missing value for --manifest" >&2; exit 2; }
      MANIFEST_PATH="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown argument: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

[[ -n "$ROOT_PATH" ]] || { echo "Missing required --root" >&2; exit 2; }
[[ -n "$MANIFEST_PATH" ]] || { echo "Missing required --manifest" >&2; exit 2; }
[[ -d "$ROOT_PATH" ]] || { echo "Project root not found: $ROOT_PATH" >&2; exit 2; }
[[ -f "$MANIFEST_PATH" ]] || { echo "Evidence manifest not found: $MANIFEST_PATH" >&2; exit 2; }

python3 - "$ROOT_PATH" "$MANIFEST_PATH" <<'PY'
from __future__ import annotations

import json
import os
import sys
from pathlib import Path
from typing import Any


root = Path(sys.argv[1]).resolve()
manifest_path = Path(sys.argv[2]).resolve()


def load_manifest() -> dict[str, Any]:
    try:
        data = json.loads(manifest_path.read_text(encoding="utf-8"))
    except (OSError, json.JSONDecodeError) as exc:
        raise ValueError(f"cannot read JSON manifest: {exc}") from exc
    if not isinstance(data, dict):
        raise ValueError("manifest root must be an object")
    if data.get("version") != 1:
        raise ValueError("manifest version must be 1")
    return data


def project_path(raw: Any, label: str) -> Path:
    if not isinstance(raw, str) or not raw.strip():
        raise ValueError(f"{label} must be a non-empty project-relative path")
    relative = Path(raw)
    if relative.is_absolute():
        raise ValueError(f"{label} must be project-relative: {raw}")
    resolved = (root / relative).resolve()
    try:
        common = Path(os.path.commonpath([str(root), str(resolved)]))
    except ValueError as exc:
        raise ValueError(f"{label} escapes project root: {raw}") from exc
    if common != root:
        raise ValueError(f"{label} escapes project root: {raw}")
    return resolved


def read_project_file(raw: Any, label: str) -> tuple[Path, str]:
    path = project_path(raw, label)
    if not path.is_file():
        raise ValueError(f"{label} file missing: {raw}")
    return path, path.read_text(encoding="utf-8")


def require_text(value: Any, label: str) -> str:
    if not isinstance(value, str) or not value.strip():
        raise ValueError(f"{label} must be non-empty text")
    return value


def reference_candidates(source: Path, target: Path) -> set[str]:
    return {
        target.relative_to(root).as_posix(),
        Path(os.path.relpath(target, source.parent)).as_posix(),
    }


try:
    manifest = load_manifest()
except ValueError as exc:
    print(f"ERROR: {exc}", file=sys.stderr)
    raise SystemExit(2)

inventory_raw = manifest.get("inventory", [])
mappings_raw = manifest.get("mappings", [])
exclusions_raw = manifest.get("exclusions", [])
if not isinstance(inventory_raw, list) or not inventory_raw:
    print("ERROR: inventory must be a non-empty list", file=sys.stderr)
    raise SystemExit(2)
if not isinstance(mappings_raw, list) or not isinstance(exclusions_raw, list):
    print("ERROR: mappings and exclusions must be lists", file=sys.stderr)
    raise SystemExit(2)

failures: list[str] = []
passes: list[str] = []
reviews: list[str] = []
inventory: dict[str, dict[str, Any]] = {}

for index, item in enumerate(inventory_raw):
    try:
        if not isinstance(item, dict):
            raise ValueError("entry must be an object")
        item_id = require_text(item.get("id"), f"inventory[{index}].id")
        if item_id in inventory:
            raise ValueError(f"duplicate inventory id: {item_id}")
        _, source_content = read_project_file(item.get("source"), f"inventory[{index}].source")
        source_text = require_text(item.get("text"), f"inventory[{index}].text")
        if source_text not in source_content:
            raise ValueError(f"source text for {item_id} is not present in {item.get('source')}")
        inventory[item_id] = item
        passes.append(f"inventory {item_id} exists in {item.get('source')}")
    except ValueError as exc:
        failures.append(str(exc))

dispositions: dict[str, int] = {item_id: 0 for item_id in inventory}

for index, mapping in enumerate(mappings_raw):
    try:
        if not isinstance(mapping, dict):
            raise ValueError(f"mappings[{index}] must be an object")
        item_id = require_text(mapping.get("inventory_id"), f"mappings[{index}].inventory_id")
        if item_id not in inventory:
            raise ValueError(f"mapping references unknown inventory id: {item_id}")
        dispositions[item_id] += 1

        destination_path, destination_content = read_project_file(
            mapping.get("destination"), f"mapping {item_id} destination"
        )
        mode = mapping.get("mode")
        source_text = require_text(inventory[item_id].get("text"), f"inventory {item_id} text")
        if mode == "verbatim":
            if source_text not in destination_content:
                raise ValueError(f"verbatim text for {item_id} is missing from {mapping.get('destination')}")
            passes.append(f"mapping {item_id} preserves source text verbatim")
        elif mode == "rewrite":
            destination_text = require_text(
                mapping.get("destination_text"), f"mapping {item_id} destination_text"
            )
            review = require_text(mapping.get("review"), f"mapping {item_id} review")
            if destination_text not in destination_content:
                raise ValueError(
                    f"reviewed destination text for {item_id} is missing from {mapping.get('destination')}"
                )
            reviews.append(
                f"mapping {item_id} records rewrite review ({review}); semantic equivalence is review evidence, not a script claim"
            )
        else:
            raise ValueError(f"mapping {item_id} mode must be verbatim or rewrite")

        chain_raw = mapping.get("activation_chain")
        if not isinstance(chain_raw, list) or len(chain_raw) < 2:
            raise ValueError(f"mapping {item_id} activation_chain must contain at least two files")
        chain: list[tuple[Path, str, str]] = []
        for chain_index, raw in enumerate(chain_raw):
            path, content = read_project_file(raw, f"mapping {item_id} activation_chain[{chain_index}]")
            chain.append((path, content, str(raw)))
        if chain[-1][0] != destination_path:
            raise ValueError(f"mapping {item_id} activation_chain must end at its destination")
        for current, following in zip(chain, chain[1:]):
            candidates = reference_candidates(current[0], following[0])
            if not any(candidate in current[1] for candidate in candidates):
                raise ValueError(
                    f"activation chain for {item_id} has no reference from {current[2]} to {following[2]}"
                )
        passes.append(f"mapping {item_id} has a complete activation chain")
    except ValueError as exc:
        failures.append(str(exc))

for index, exclusion in enumerate(exclusions_raw):
    try:
        if not isinstance(exclusion, dict):
            raise ValueError(f"exclusions[{index}] must be an object")
        item_id = require_text(exclusion.get("inventory_id"), f"exclusions[{index}].inventory_id")
        if item_id not in inventory:
            raise ValueError(f"exclusion references unknown inventory id: {item_id}")
        dispositions[item_id] += 1
        reason = require_text(exclusion.get("reason"), f"exclusion {item_id} reason")
        passes.append(f"inventory {item_id} is explicitly excluded: {reason}")
    except ValueError as exc:
        failures.append(str(exc))

for item_id, count in dispositions.items():
    if count == 0:
        failures.append(f"inventory {item_id} has no mapped or excluded disposition")
    elif count > 1:
        failures.append(f"inventory {item_id} has {count} dispositions; exactly one is required")

for message in passes:
    print(f"PASS: {message}")
for message in reviews:
    print(f"REVIEW: {message}")
for message in failures:
    print(f"FAIL: {message}", file=sys.stderr)

print(
    f"Migration evidence results: {len(passes)} passed, {len(reviews)} review-backed, {len(failures)} failed"
)
if reviews:
    print("Rewrite equivalence remains owned by the recorded semantic review; this checker proves only evidence integrity.")
raise SystemExit(1 if failures else 0)
PY
