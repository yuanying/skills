# Upstream

This bundle is adapted from [pstack](https://github.com/cursor/plugins/tree/b7b93c36be9bcc36a74db438e0fd385d660bc559/pstack) at `b7b93c36be9bcc36a74db438e0fd385d660bc559` (`b7b93c3`). [LICENSE](LICENSE) is the unmodified MIT license, Copyright (c) 2026 Lauren Tan. The [Claude Code adapter](https://github.com/cursor/plugins/blob/b7b93c36be9bcc36a74db438e0fd385d660bc559/pstack/docs/harness/claude-code.md) and [backnotprop/pstack](https://github.com/backnotprop/pstack/tree/c81f1bf) were references for the harness split, not additional sources of bundled files.

## Imported

- Poteto-mode entry and worker rules, all 22 playbooks and all 24 principles.
- The remaining pstack skills, including their example feature map, TypeScript examples, and decision log helper. Only the bundle entry is discoverable as a standalone skill.
- The `poteto-agent` startup rules are folded into [worker.md](worker.md) and the entry's Subagents section. The comment reviewer is a bundled [role brief](skills/comment-sicko.md). The worktree audit remains a shell helper.

## Not imported

- Bugbot instructions and the Bugbot triage reference, Cursor's babysit, Automations/Benny, and `cursor-team-kit` (`/deslop`, `control-ui`, `control-cli`). They depend on plugin-specific integrations. Generic review triage, the cleanup passes, and live verification remain.
- `setup-pstack`, `poteto-help`, `statechart`, `create-formal-verification-skill`, `maintain-formal-verification-skill`, `ketchup`, `ketchup-video`, and `make-bot-ui`. The bundle does not include the setup wizard, plugin guide, formal verification stack, special reporting commands, or bot UI.
- The TypeScript `scripts/watch-pr` watcher, `bootstrap.ts`, `package.json`, and `bun.lock`. Babysit and Shipping use forge commands directly.
- Cursor cloud environments and scheduler, private transcript and cache discovery, plugin manifests, packaging assets, artwork, and the plugin README and guides. The bundle keeps the workflows instead of redistributing the plugin and its installation material.

## Translations

| Upstream | This bundle |
| --- | --- |
| Cursor agent tool and cloud workers | `spawn`, `send`, `wait`, `close`, `isolate`; the active harness provides the implementation. |
| `setup-pstack`, `pstack-models.mdc`, vendor-specific slugs | [models.md](models.md) lists Pi IDs, roles, and supported thinking levels. No vendor speed suffix or interactive budget preset. |
| Sibling skill directories and slash commands | One discoverable entry; relative links to bundled playbooks, principles, and procedures. |
| `/deslop` and surface control skills | Unslop plus no-comments; use the project's verification skill or a named driver for live proof. |
| Bugbot policy and `watch-pr` | Ordinary forge review threads, CI checks, and explicit verification of the current PR head. |
| `/loop` and cloud-agent status | Completion events or a harness wake; record the pending gate when the harness cannot wake the run. |
| Cursor transcript store, cache paths, and authoring UI | Scope history to the active workspace via the harness or explicit paths. Cleanup and audit do not infer transcript paths. Use the active harness's documented skill format. |
| `/ketchup` reports | Plain-language Japanese reports; decision trails and evidence remain linked. |
| Technical-writing for all prose | Install `git-commit` separately for commit messages. The user's `~/.pi/agent/AGENTS.md` takes precedence for tests. |
