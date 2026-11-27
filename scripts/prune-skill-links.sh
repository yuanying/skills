#!/usr/bin/env bash
set -euo pipefail

script_dir="$(CDPATH= cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
repo_root="$(cd "${script_dir}/.." && pwd -P)"
skills_dir="${repo_root}/skills"

targets=(
  "${HOME}/.agents/skills"
  "${HOME}/.claude/skills"
)

dry_run=0
if [[ $# -eq 1 && "$1" == --dry-run ]]; then
  dry_run=1
elif [[ $# -ne 0 ]]; then
  printf 'usage: %s [--dry-run]\n' "$0" >&2
  exit 2
fi

if [[ ! -d "${skills_dir}" || -L "${skills_dir}" ]]; then
  echo "skills directory not found in this checkout: ${skills_dir}" >&2
  exit 1
fi

points_into_skills() (
  local target="$1"
  # Walk up missing components until an existing directory can be resolved.
  # Do not guess where an unresolved symlink or '..' in the missing tail leads.
  while :; do
    while [[ "${target}" == */ && "${target}" != / ]]; do
      target="${target%/}"
    done
    [[ ! -e "${target}" && ! -L "${target}" && "${target##*/}" != .. ]] || return 1
    target="${target%/*}"
    target="${target:-/}"
    if cd -P -- "${target}" 2>/dev/null; then
      [[ "${PWD}" == "${skills_dir}" || "${PWD}" == "${skills_dir}/"* ]]
      return
    fi
  done
)

shopt -s nullglob dotglob
for target_dir in "${targets[@]}"; do
  for link_path in "${target_dir}"/*; do
    [[ -L "${link_path}" && ! -e "${link_path}" ]] || continue
    # Keep any trailing newlines in the symlink target itself.
    link_target="$(readlink "${link_path}" && printf '.')" || continue
    link_target="${link_target%$'\n.'}"
    if [[ "${link_target}" != /* ]]; then
      link_target="${target_dir}/${link_target}"
    fi
    points_into_skills "${link_target}" || continue

    if [[ ${dry_run} -eq 0 ]]; then
      rm -- "${link_path}"
    fi
    printf '%s\n' "${link_path}"
  done
done
