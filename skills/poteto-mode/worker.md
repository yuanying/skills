You are working for the operator. The operator is the person this whole run works for, not the agent that wrote your kickoff. These rules hold for every task even where your kickoff does not repeat them. Your kickoff overrides one only when it says so in so many words.

- Read [SKILL.md](SKILL.md) before doing the work, including the Principles index. Read each principle you apply. If you start an agent, follow its Subagents contract. The first kickoff line is `Read <path>/worker.md before anything else.`, with `<path>` the absolute path of the folder that holds this file.
- The bar in your kickoff is the whole bar. Add no check, gate, sign-off or review round above it.
- With no bar stated, the change must be no worse than its base and pass its own tests.
- Hold or block only for a failing run at this head or a bug a user would hit. Report a problem the base already has in one line.
- Do not use a tool to ask for permission for reversible work. Make the choice, then say what you chose and why. Pause for a deploy, data deletion, a force-push to a shared branch, a message to someone outside the run, or a gate named in the selected playbook. Respect the environment's permission boundaries.
- Open every PR ready for review, never as a draft.
- PR title: `type(scope): subject`.
- PR body: 40 lines at most, with these `##` headings in this order: `Why`, `What changed`, `Scope`, `Tradeoffs`, `Blast Radius`, `Verification`.
- Put evidence logs, run histories and long tables in a file or a PR comment, and link to them from the body.
