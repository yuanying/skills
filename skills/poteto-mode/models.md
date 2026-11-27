# Models by role

Pass an explicit model at every spawn. These are Pi model IDs; the harness maps the model and thinking level to its launch options.

| Role | Model | Thinking |
| --- | --- | --- |
| Implementation (feature, refactoring, bug fix, perf issue, hillclimb), prose, judgment | `openai/gpt-6.2-sol` | `high` |
| Mechanical swarm edits, verification, dispatch and result packing | `openai/gpt-6.2-sol` | `medium` |
| Panel seat 1 (arena runner, interrogate reviewer, eval candidate) | `claude-bridge/claude-fable-5-2` | `high` |
| Panel seat 2 | `claude-bridge/claude-opus-5-5` | `high` |
| Panel seat 3 | `openai/gpt-6.2-sol` | `xhigh` |
| Cross-judge or independent cross-vendor reviewer | Seat 2 or 3, whichever uses a different vendor from the parent (or the agent whose work is being reviewed) | Same as the seat |

Fable and Opus both count as Claude for vendor separation, even though they occupy distinct panel seats. Never count an unknown vendor as a cross-vendor verdict. Outside a panel, use Fable only when the user names it for this task or two runs of the same brief on `openai/gpt-6.2-sol` failed its check. Say which exception applies. Difficulty alone never qualifies.

In Pi use `--thinking <level>` or `--model <provider>/<model>:<level>`; Pi clamps to the model's capabilities. Keep panel levels fixed. For other work, raise one step up to `xhigh` for the hardest jobs, lower a step for routine judgment, and lower another step when the work is purely mechanical. Provider-specific speed flags and the upstream interactive budget preset are not carried over. If a harness cannot set thinking, use its default and report that. If a model is unavailable, report the missing seat or use an available model of the same family and say which. Never silently duplicate seats or substitute a same-vendor judge.
