### Opening a PR

Use this when the selected playbook calls for opening a PR.

Work from a git worktree off trunk, and keep unrelated work out of it. Rebase into small, landable commits. Apply [unslop](../skills/unslop.md) and [no-comments](../skills/no-comments.md) before commit. Follow the separately installed `git-commit` skill for commit messages.

Title: `type(scope): subject`, naming a real symbol when one carries the change. Body: a one-minute briefing at most 40 lines with these `##` headings in order: `## Why`, `## What changed`, `## Scope`, `## Tradeoffs` (only rejected alternatives a reviewer would otherwise ask about), `## Blast Radius`, `## Verification`.

Stack follow-ups by base branch. Open PRs ready, through the run's PR tool with `draft: false`. Without one, use `gh pr create` without `--draft`, or `origin pr create --status open` when Origin's CLI resolves the repository. Opening a PR does not start a babysit.
