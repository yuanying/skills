#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
tmp_dir="$(mktemp -d)"
trap 'rm -rf -- "${tmp_dir}"' EXIT
export HOME="${tmp_dir}/home"

# Only dangling links into this checkout's skills directory are pruned.
checkout="${HOME}/skill checkout"
agents="${HOME}/.agents/skills"
claude="${HOME}/.claude/skills"
mkdir -p "${checkout}/scripts" "${checkout}/skills/kept" "${agents}/local" "${claude}"
cp "${repo_root}/scripts/prune-skill-links.sh" "${checkout}/scripts/"
ln -s "${checkout}/skills/removed" "${agents}/removed"
ln -s '../../skill checkout/skills/removed-group/removed' "${claude}/removed"
ln -s "${checkout}/skills/kept" "${agents}/kept"
ln -s "${checkout}/skills-other/removed" "${agents}/external"
ln -s "${checkout}/skills/../other/removed" "${claude}/external"

expected="${agents}/removed"$'\n'"${claude}/removed"
[[ "$(bash "${checkout}/scripts/prune-skill-links.sh" --dry-run)" == "${expected}" ]]
[[ -L "${agents}/removed" && -L "${claude}/removed" ]]

[[ "$(bash "${checkout}/scripts/prune-skill-links.sh")" == "${expected}" ]]
[[ ! -L "${agents}/removed" && ! -L "${claude}/removed" ]]
[[ -L "${agents}/kept" && -L "${agents}/external" && -L "${claude}/external" ]]
[[ -d "${agents}/local" && ! -L "${agents}/local" ]]
