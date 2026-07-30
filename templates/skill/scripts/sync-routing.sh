#!/usr/bin/env bash
# sync-routing.sh — Generate Always Read, Common Tasks, shell bootstraps (from
# routing.yaml), and the shared behavior block (auto-triggers + red flags) into shells.
# Usage:
#   bash scripts/sync-routing.sh [skill-name|skill-root] [--check] [--workspace-root <path>]
#   bash skills/<name>/scripts/sync-routing.sh <name> [--check] [--workspace-root <path>]

set -euo pipefail

MODE="sync"
TARGET=""
WORKSPACE_ROOT=""
while [[ $# -gt 0 ]]; do
  case "$1" in
    --check)
      MODE="check"
      shift
      ;;
    --workspace-root)
      [[ $# -ge 2 ]] || { echo "--workspace-root requires a path" >&2; exit 1; }
      WORKSPACE_ROOT="$2"
      shift 2
      ;;
    --workspace-root=*)
      WORKSPACE_ROOT="${1#*=}"
      shift
      ;;
    *)
      [[ -z "$TARGET" ]] || { echo "Unexpected extra target: $1" >&2; exit 1; }
      TARGET="$1"
      shift
      ;;
  esac
done

if [[ -n "$TARGET" && -f "$TARGET/SKILL.md" ]]; then
  SKILL_ROOT="$TARGET"
elif [[ -n "$TARGET" && -f "$TARGET/SKILL.md.template" ]]; then
  SKILL_ROOT="$TARGET"
elif [[ -n "$TARGET" && -f "skills/$TARGET/SKILL.md" ]]; then
  SKILL_ROOT="skills/$TARGET"
elif [[ -f "SKILL.md" && -f "routing.yaml" ]]; then
  SKILL_ROOT="."
elif [[ -f "SKILL.md.template" && -f "routing.yaml" ]]; then
  SKILL_ROOT="."
else
  echo "Usage: bash sync-routing.sh [skill-name|skill-root] [--check] [--workspace-root <path>]" >&2
  exit 1
fi

python3 - "$SKILL_ROOT" "$MODE" "$WORKSPACE_ROOT" <<'PY'
from pathlib import Path
import sys
import re

skill_root = Path(sys.argv[1]).resolve()
mode = sys.argv[2]
workspace_root = Path(sys.argv[3]).resolve() if sys.argv[3] else None
manifest = skill_root / "routing.yaml"
domain_manifest = skill_root / "domain-routing.yaml"
summary_start = "<!-- ROUTING_SUMMARY_START -->"
summary_end = "<!-- ROUTING_SUMMARY_END -->"
bootstrap_start = "<!-- ROUTING_BOOTSTRAP_START -->"
bootstrap_end = "<!-- ROUTING_BOOTSTRAP_END -->"
always_start = "<!-- ALWAYS_READ_START -->"
always_end = "<!-- ALWAYS_READ_END -->"
behavior_start = "<!-- BEHAVIOR_BLOCK_START -->"
behavior_end = "<!-- BEHAVIOR_BLOCK_END -->"

if not manifest.exists():
    raise SystemExit(f"Missing routing manifest: {manifest}")

template_mode = skill_root.name == "skill" and skill_root.parent.name == "templates"
skill_file = skill_root / ("SKILL.md.template" if template_mode else "SKILL.md")

if template_mode:
    repo_root = skill_root.parent / "shells"
elif skill_root.parent.name == "skills":
    repo_root = skill_root.parent.parent
else:
    repo_root = Path.cwd().resolve()

def skill_name() -> str:
    for line in skill_file.read_text().splitlines():
        if line.startswith("name:"):
            return line.split(":", 1)[1].strip()
    return skill_root.name

name = skill_name()

def clean(value: str) -> str:
    value = value.strip()
    if (value.startswith('"') and value.endswith('"')) or (value.startswith("'") and value.endswith("'")):
        return value[1:-1]
    return value

def parse_inline_list(value: str) -> list[str]:
    value = value.strip()
    if not (value.startswith("[") and value.endswith("]")):
        return []
    inner = value[1:-1].strip()
    if not inner:
        return []
    return [clean(part.strip()) for part in inner.split(",") if part.strip()]

def parse_inline_map(value: str) -> dict[str, str]:
    value = value.strip()
    if not (value.startswith("{") and value.endswith("}")):
        return {}
    inner = value[1:-1].strip()
    result = {}
    for part in inner.split(","):
        if ":" not in part:
            continue
        key, item = part.split(":", 1)
        result[clean(key).strip()] = clean(item)
    return result

# Two-root support (skeleton-flesh-split.md §7): `skill:` paths resolve inside
# this skill root; `code:` paths resolve from routing.yaml's code_root.root when
# the caller supplies --workspace-root. Without it, cross-root existence and
# business-domain materialization remain explicitly unverified.
def normalize_path(item: str) -> str:
    if item.startswith("skill:"):
        return item[len("skill:"):]
    return item

def is_code_path(item: str) -> bool:
    return item.startswith("code:")

def parse_manifest_file(path: Path):
    always_read = []
    tasks = []
    overlays = []
    owner_roots = {}
    current = None
    section = None
    top_section = None
    for raw in path.read_text().splitlines():
        if not raw.strip() or raw.lstrip().startswith("#"):
            continue
        stripped = raw.strip()
        if stripped.startswith("always_read:"):
            top_section = "always_read"
            current = None
            section = None
            _, value = stripped.split(":", 1)
            always_read.extend(parse_inline_list(value))
            continue
        if stripped == "tasks:":
            top_section = "tasks"
            current = None
            section = None
            continue
        if stripped == "domain_overlays:":
            top_section = "domain_overlays"
            current = None
            section = None
            continue
        if stripped == "owner_roots:":
            top_section = "owner_roots"
            current = None
            section = None
            continue
        if top_section == "always_read" and raw.startswith("  - "):
            always_read.append(clean(stripped[2:]))
            continue
        if top_section == "owner_roots" and raw.startswith("  ") and not raw.startswith("    ") and ":" in stripped:
            key, value = stripped.split(":", 1)
            owner_roots[clean(key)] = clean(value)
            continue
        if raw.startswith("  - id:"):
            current = {"id": clean(raw.split(":", 1)[1]), "labels": {}, "required_reads": [], "trigger_examples": [], "_present": set()}
            (overlays if top_section == "domain_overlays" else tasks).append(current)
            section = None
            continue
        if current is None:
            continue
        if raw.startswith("    labels:"):
            current["_present"].add("labels")
            section = "labels"
            _, value = stripped.split(":", 1)
            current["labels"].update(parse_inline_map(value))
            if current["labels"]:
                section = None
            continue
        if raw.startswith("    required_reads:"):
            current["_present"].add("required_reads")
            section = "required_reads"
            _, value = stripped.split(":", 1)
            current["required_reads"].extend(parse_inline_list(value))
            if value.strip().startswith("["):
                section = None
            continue
        if raw.startswith("    trigger_examples:"):
            current["_present"].add("trigger_examples")
            section = "trigger_examples"
            _, value = stripped.split(":", 1)
            current["trigger_examples"].extend(parse_inline_list(value))
            if value.strip().startswith("["):
                section = None
            continue
        if section == "labels" and raw.startswith("      ") and ":" in stripped:
            key, value = stripped.split(":", 1)
            current["labels"][key.strip()] = clean(value)
            continue
        if section in {"required_reads", "trigger_examples"} and raw.startswith("      - "):
            current[section].append(clean(stripped[2:]))
            continue
        if raw.startswith("    ") and ":" in stripped:
            key, value = stripped.split(":", 1)
            current[key.strip()] = clean(value)
            current["_present"].add(key.strip())
            section = None
    return always_read, tasks, overlays, owner_roots

always_read, tasks, inline_overlays, inline_owner_roots = parse_manifest_file(manifest)
if domain_manifest.exists():
    domain_always, domain_tasks, overlays, owner_roots = parse_manifest_file(domain_manifest)
else:
    domain_always, domain_tasks, overlays, owner_roots = [], [], [], {}

def parse_code_root_path():
    in_code_root = False
    for raw in manifest.read_text().splitlines():
        if raw.strip() == "code_root:" and raw.startswith("  "):
            in_code_root = True
            continue
        if in_code_root and raw.strip().startswith("root:"):
            return clean(raw.strip().split(":", 1)[1])
        if in_code_root and raw.startswith("  ") and not raw.startswith("    "):
            break
    return ""

code_root_path = parse_code_root_path()

def safe_relative_path(value: str) -> bool:
    path = Path(value)
    return bool(value.strip()) and not path.is_absolute() and ".." not in path.parts

def business_owner_units(business_dir: Path):
    if not business_dir.exists():
        return [], [], []
    content = sorted(
        path for path in business_dir.rglob("*.md")
        if path.name != "README.md"
    )
    owners = sorted(
        path for path in business_dir.glob("*.md")
        if path.name not in {"README.md", "index.md"}
    )
    missing_indexes = []
    for child in sorted(path for path in business_dir.iterdir() if path.is_dir()):
        if not any(path.name != "README.md" for path in child.rglob("*.md")):
            continue
        index = child / "index.md"
        if index.exists():
            owners.append(index)
        else:
            missing_indexes.append(child)
    return content, owners, missing_indexes

def validate_schema(always_read, tasks, overlays, owner_roots):
    errors = []
    if not tasks:
        errors.append("routing.yaml has no tasks")
    if inline_overlays:
        errors.append("routing.yaml must not contain domain_overlays; move them to domain-routing.yaml")
    if inline_owner_roots:
        errors.append("routing.yaml must not contain owner_roots; move them to domain-routing.yaml")
    if domain_always:
        errors.append("domain-routing.yaml must not contain always_read")
    if domain_tasks:
        errors.append("domain-routing.yaml must not contain tasks")
    if domain_manifest.exists() and not overlays:
        errors.append("domain-routing.yaml exists but has no domain_overlays; remove the empty manifest")
    if code_root_path and not safe_relative_path(code_root_path):
        errors.append(f"code_root.root must be a safe workspace-relative path: {code_root_path}")
    local_business_dir = skill_root / "references" / "business"
    local_business, local_business_owners, local_missing_indexes = business_owner_units(local_business_dir)
    if local_business and not domain_manifest.exists():
        errors.append("business domain files exist but domain-routing.yaml is missing")
    registered_local_business = {
        normalize_path(item).split("#", 1)[0]
        for overlay in overlays
        for item in overlay.get("required_reads", [])
        if not item.startswith("owner:") and not is_code_path(item)
    }
    for path in local_missing_indexes:
        errors.append(f"business domain directory must route through index.md: {path.relative_to(skill_root).as_posix()}")
    for path in local_business_owners:
        relative = path.relative_to(skill_root).as_posix()
        if relative not in registered_local_business:
            errors.append(f"business domain owner is not registered in domain-routing.yaml: {relative}")
    if workspace_root is not None and code_root_path:
        code_root_base = workspace_root / code_root_path
        code_business, code_business_owners, code_missing_indexes = business_owner_units(
            code_root_base / "references" / "business"
        )
        if code_business and not domain_manifest.exists():
            errors.append("code-root business content exists but domain-routing.yaml is missing")
        registered_code_business = {
            item[len("code:"):].split("#", 1)[0]
            for overlay in overlays
            for item in overlay.get("required_reads", [])
            if is_code_path(item)
        }
        for path in code_missing_indexes:
            errors.append(f"code-root business domain directory must route through index.md: {path.relative_to(code_root_base).as_posix()}")
        for path in code_business_owners:
            relative = path.relative_to(code_root_base).as_posix()
            if relative not in registered_code_business:
                errors.append(f"code-root business domain owner is not registered in domain-routing.yaml: {relative}")
    ids = [task.get("id", "") for task in tasks]
    duplicates = sorted({task_id for task_id in ids if ids.count(task_id) > 1})
    for task_id in duplicates:
        errors.append(f"duplicate task id: {task_id}")
    if "other" not in ids:
        errors.append("missing fallback task id: other")
    for task in tasks:
        task_id = task.get("id", "")
        if not task_id:
            errors.append("task missing id")
        if not task.get("labels"):
            errors.append(f"{task_id}: missing labels")
        workflow = task.get("workflow", "")
        if not workflow:
            errors.append(f"{task_id}: missing workflow")
        else:
            workflow_path = workflow.split("#", 1)[0]
            if is_code_path(workflow_path):
                workflow_path = workflow_path[len("code:"):]
            else:
                workflow_path = normalize_path(workflow_path)
            if not safe_relative_path(workflow_path) or not workflow_path.endswith(".md"):
                errors.append(f"{task_id}: workflow must be a safe skill/code-relative Markdown path")
            elif not workflow_path.startswith("workflows/"):
                errors.append(f"{task_id}: workflow must select a workflows/*.md procedure")
        if "required_reads" in task.get("_present", set()):
            errors.append(f"{task_id}: task routes select only a workflow; move required_reads into the workflow")
        if "route" in task.get("_present", set()):
            errors.append(f"{task_id}: task routes must not contain executable route instructions")
    overlay_ids = [overlay.get("id", "") for overlay in overlays]
    for overlay_id in sorted({item for item in overlay_ids if overlay_ids.count(item) > 1}):
        errors.append(f"duplicate domain overlay id: {overlay_id}")
    for overlay in overlays:
        overlay_id = overlay.get("id", "")
        if not overlay_id:
            errors.append("domain overlay missing id")
        if not overlay.get("labels"):
            errors.append(f"{overlay_id}: missing labels")
        if not overlay.get("required_reads"):
            errors.append(f"{overlay_id}: missing required_reads")
        elif not any("references/business/" in item for item in overlay.get("required_reads", [])):
            errors.append(f"{overlay_id}: domain overlay must register at least one business owner")
        if not overlay.get("trigger_examples"):
            errors.append(f"{overlay_id}: missing trigger_examples")
        if overlay.get("workflow"):
            errors.append(f"{overlay_id}: domain overlay must inherit the task workflow")
    for owner, root in owner_roots.items():
        if not re.fullmatch(r"[A-Za-z0-9_-]+", owner):
            errors.append(f"invalid owner id: {owner}")
        if not safe_relative_path(root):
            errors.append(f"owner root must be a safe workspace-relative path: {owner}: {root}")
    for item in always_read:
        if not item or "FILL:" in item:
            continue
        tier_prefixes = ("rules/", "workflows/", "references/", "architecture/", "gotchas/", "conventions/")
        normalized = normalize_path(item)
        if is_code_path(item):
            continue
        if not any(normalized.startswith(prefix) for prefix in tier_prefixes):
            errors.append(f"always_read path should be skill-relative one of {', '.join(tier_prefixes)}: {item}")
    return errors

schema_errors = validate_schema(always_read, tasks, overlays, owner_roots)
if schema_errors:
    for err in schema_errors:
        print(f"FAIL: {err}")
    raise SystemExit(1)

def label_for(task):
    labels = task.get("labels", {})
    en = labels.get("en", "").strip()
    zh = labels.get("zh", "").strip()
    task_id = task.get("id", "").strip()
    if en and zh and en != zh:
        return f"{en} / {zh} (`{task_id}`)"
    if en or zh:
        return f"{en or zh} (`{task_id}`)"
    return task_id

def format_always_skill(reads):
    if not reads:
        return "None by default; workflows load knowledge at evidence and phase boundaries."
    return "\n".join(f"{idx}. `{item}`" for idx, item in enumerate(reads, 1))

def format_always_shell(reads):
    if not reads:
        return "- None by default; workflows load knowledge at evidence and phase boundaries."
    return "\n".join(f"- `skills/{name}/{item}`" for item in reads)

def format_triggers(examples):
    real = [ex for ex in examples if ex and "FILL:" not in ex]
    if not real:
        return ""
    return "; triggers: " + ", ".join(f'"{ex}"' for ex in real[:3])

def format_workflow(value):
    if not value:
        return "none"
    if normalize_path(value).startswith("workflows/"):
        return f"`{value}`"
    return value

task_summary = "\n".join(
    f"- {label_for(task)} -> workflow {format_workflow(task.get('workflow', ''))}"
    f"{format_triggers(task.get('trigger_examples', []))}"
    for task in tasks
)
summary_block = task_summary
always_skill_block = format_always_skill(always_read)
always_shell_block = format_always_shell(always_read)

bootstrap_block = f"""Task routes live in `skills/{name}/routing.yaml`.

For every new task:
1. Read `skills/{name}/routing.yaml`.
2. Match exactly one task route by `labels`, `trigger_examples`, and task intent; if none matches, use `other`.
3. Follow only that route's `workflow`; the task route does not preload knowledge.
4. Let the workflow inspect the smallest evidence that can decide the next action.
5. Only when an explicit business-rule request, a source Plan already declares the applicable business-domain owner, or evidence proves an unresolved decision is business-bearing, read optional `skills/{name}/domain-routing.yaml`. Read a governing source Plan directly through its workflow; its existence alone does not activate a domain. Keywords identify candidates only. Append one domain owner's reads by default; never replace the task workflow.
6. Load mutation, testing, managed-execution, and closure contracts only when their phase begins."""

# Single source for the behavioral triggers duplicated across every thin shell.
# Edit here once, re-run sync-routing.sh → all shells update together.
behavior_block = f"""## Auto-Triggers

- **New task in same session** → always re-match the route (Common Tasks / `routing.yaml`). After a route change, read the new workflow; after compaction, recover only the current workflow and decision-relevant evidence. Then execute one clear action/check directly, otherwise follow `skills/{name}/workflows/task-execution.md` to establish a Task Anchor, present only useful alignment, use the harness-native Plan without repeating visible steps in chat, and run its compact Anchor Checkpoint before each main step. This is Session recitation, not planning-file persistence. Can't tell if context compacted? Re-read the current workflow.
- Before any requested commit/push/MR/deploy/publish delivery, or before declaring any non-trivial task complete → enter Task Closure Protocol (see `skills/{name}/workflows/task-closure.md`); `Ready for Delivery` is not completion
- When user asks to "record/save/remember" something → project-level knowledge goes to `skills/{name}/` docs; personal preferences go to agent memory

## Red Flags — STOP

- "Just this once I'll skip the AAR" → stop. See `skills/{name}/workflows/task-closure.md` § Rationalizations to Reject."""

def validate_paths():
    errors = []
    owner_ref_pattern = re.compile(r"^owner:([A-Za-z0-9_-]+):(.+)$")
    owner_refs = []
    code_refs = []

    def under(path: Path, root: Path) -> bool:
        try:
            path.relative_to(root)
            return True
        except ValueError:
            return False

    def validate_owner_ref(item, source):
        match = owner_ref_pattern.fullmatch(item)
        if not match:
            errors.append(f"{source}: malformed owner reference: {item}")
            return
        owner, relative_text = match.groups()
        if owner not in owner_roots:
            errors.append(f"{source}: undeclared owner id: {owner}")
            return
        if not safe_relative_path(relative_text):
            errors.append(f"{source}: owner reference must be a safe relative path: {item}")
            return
        owner_refs.append((source, item))
        if workspace_root is None:
            return
        owner_base = (workspace_root / owner_roots[owner]).resolve()
        target = (owner_base / relative_text).resolve()
        if not under(owner_base, workspace_root) or not under(target, owner_base):
            errors.append(f"{source}: owner reference escapes declared workspace boundary: {item}")
        elif not target.exists():
            errors.append(f"{source}: owner target missing: {item} -> {target}")

    def validate_code_ref(item, source):
        relative_text = item[len("code:"):].split("#", 1)[0]
        if not safe_relative_path(relative_text):
            errors.append(f"{source}: code reference must be a safe relative path: {item}")
            return
        if not code_root_path:
            errors.append(f"{source}: code reference requires routing.yaml code_root.root: {item}")
            return
        code_refs.append((source, item))
        if workspace_root is None:
            return
        code_root_base = (workspace_root / code_root_path).resolve()
        target = (code_root_base / relative_text).resolve()
        if not under(code_root_base, workspace_root) or not under(target, code_root_base):
            errors.append(f"{source}: code reference escapes declared workspace boundary: {item}")
        elif not target.exists():
            errors.append(f"{source}: code target missing: {item} -> {target}")

    def validate_read(item, source):
        if item.startswith("owner:"):
            validate_owner_ref(item, source)
            return
        if is_code_path(item):
            validate_code_ref(item, source)
            return
        if "*" in item or "FILL:" in item:
            return
        if "/" in item:
            target = skill_root / normalize_path(item).split("#", 1)[0]
            if not target.exists():
                errors.append(f"{source}: required_read missing: {item}")

    for item in always_read:
        if "*" in item or "FILL:" in item:
            continue
        if is_code_path(item):
            continue
        target = skill_root / normalize_path(item).split("#", 1)[0]
        if not target.exists():
            errors.append(f"always_read missing: {item}")
    for task in tasks:
        if "FILL:" in str(task):
            continue
        workflow = task.get("workflow", "")
        normalized_workflow = normalize_path(workflow)
        if normalized_workflow.startswith("workflows/"):
            target = skill_root / normalized_workflow.split("#", 1)[0]
            if not target.exists():
                errors.append(f"{task.get('id')}: workflow missing: {workflow}")
        for item in task.get("required_reads", []):
            validate_read(item, task.get("id"))
    for overlay in overlays:
        for item in overlay.get("required_reads", []):
            validate_read(item, f"domain overlay {overlay.get('id')}")
    return errors, owner_refs, code_refs

path_errors, owner_refs, code_refs = validate_paths()
if path_errors:
    for err in path_errors:
        print(f"FAIL: {err}")
    raise SystemExit(1)

def label(path: Path) -> str:
    for base in (repo_root, skill_root.parent.parent if template_mode else repo_root):
        try:
            return str(path.relative_to(base))
        except ValueError:
            pass
    return str(path)

targets = [
    (skill_file, always_start, always_end, always_skill_block),
    (skill_file, summary_start, summary_end, summary_block),
]
shell_targets = ["AGENTS.md", "CLAUDE.md", "CODEX.md", "GEMINI.md"]
# .codex/instructions.md is an optional compatibility mirror. New scaffolds
# don't include it (AGENTS.md is the canonical Codex CLI entry), but
# downstream projects scaffolded before its removal still have the file
# and rely on this script to keep its routing block in sync.
if (repo_root / ".codex" / "instructions.md").exists():
    shell_targets.append(".codex/instructions.md")
def maybe_behavior(path):
    # Behavior block is opt-in per shell: only sync where the markers already exist,
    # so older scaffolds without them don't fail. Add the BEHAVIOR_BLOCK markers to a
    # shell to bring its behavioral triggers under single-source generation.
    if path.exists() and behavior_start in path.read_text():
        targets.append((path, behavior_start, behavior_end, behavior_block))

for rel in shell_targets:
    path = repo_root / rel
    targets.append((path, always_start, always_end, always_shell_block))
    targets.append((path, bootstrap_start, bootstrap_end, bootstrap_block))
    maybe_behavior(path)
rules_dir = repo_root / ".cursor" / "rules"
if rules_dir.exists():
    for path in sorted(rules_dir.glob("*.mdc")):
        targets.append((path, always_start, always_end, always_shell_block))
        targets.append((path, bootstrap_start, bootstrap_end, bootstrap_block))
        maybe_behavior(path)
cursor_entry = repo_root / ".cursor" / "skills" / name / ("SKILL.md.template" if template_mode else "SKILL.md")
targets.append((cursor_entry, bootstrap_start, bootstrap_end, bootstrap_block))

failed = False
changed = False
for path, start, end, block in targets:
    if not path.exists():
        continue
    text = path.read_text()
    if start not in text or end not in text:
        print(f"FAIL: {label(path)} missing generated block markers: {start} / {end}")
        failed = True
        continue
    expected = f"{start}\n{block}\n{end}"
    actual = start + text.split(start, 1)[1].split(end, 1)[0] + end
    if actual == expected:
        print(f"OK: {label(path)}")
        continue
    if mode == "check":
        print(f"DRIFT: {label(path)}")
        failed = True
        continue
    before = text.split(start, 1)[0]
    after = text.split(end, 1)[1]
    path.write_text(before + expected + after)
    changed = True
    print(f"synced {label(path)}")

if failed:
    print("\nRun: bash skills/<name>/scripts/sync-routing.sh <name>")
    raise SystemExit(1)
if mode == "check":
    verification_open = False
    if owner_refs and workspace_root is None:
        print(f"UNVERIFIED: {len(owner_refs)} owner reference(s) passed syntax/owner checks, but target existence was not checked; rerun with --workspace-root <path>.")
        print("Routing manifest structural check passed; cross-owner target verification remains open.")
        verification_open = True
    if code_root_path and workspace_root is None:
        print(f"UNVERIFIED: code_root.root={code_root_path} is declared, but code-root targets and business-domain materialization were not checked; rerun with --workspace-root <path>.")
        print("Routing manifest structural check passed; code-root target verification remains open.")
        verification_open = True
    if not verification_open:
        print("Routing manifest check passed.")
elif not changed:
    print("Routing summary and bootstraps already up to date.")
PY
