#!/usr/bin/env python3
"""Check that readers can open the local files named by poteto-mode."""

import re
from pathlib import Path

root = Path(__file__).resolve().parents[1] / 'skills' / 'poteto-mode'
entry = root / 'SKILL.md'
if not entry.is_file():
    raise SystemExit(f'Missing skill entry: {entry}')

# Check Markdown link destinations and explicit bundle paths in prose/code.
# Template paths containing placeholders and paths to a user's project are not links.
links = re.compile(r'\]\(([^\s)]+)\)')
paths = re.compile(
    r'(?<![\w/.-])(?:(?:\.\.?/)+|(?:skills|principles|playbooks|scripts|references)/)'
    r'[\w./-]+\.(?:md|sh|tsv|txt)(?![\w/-])'
)
errors = []
checked = 0
for doc in sorted(root.rglob('*.md')):
    if doc.name == 'UPSTREAM.md':
        continue
    for line_no, line in enumerate(doc.read_text().splitlines(), 1):
        explicit = links.findall(line)
        refs = set(explicit + paths.findall(links.sub('', line)))
        for ref in sorted(refs):
            if ref.startswith(('#', '~', '/', 'https:', 'http:', 'mailto:')) or '<' in ref:
                continue
            path = ref.split('#', 1)[0]
            base = doc.parent if ref in explicit or path.startswith('.') else root
            target = (base / path).resolve()
            checked += 1
            if not target.is_relative_to(root) or not target.is_file():
                errors.append(f'{doc.relative_to(root)}:{line_no}: {ref}')
if errors:
    raise SystemExit('Unresolved bundle references:\n' + '\n'.join(errors))
print(f'Checked {checked} bundle references')
