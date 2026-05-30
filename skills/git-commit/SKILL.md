---
name: git-commit
description: Git commit message formatting guidelines. Use this skill when creating git commits to ensure commit messages follow best practices and maintain a clean, readable git history. Triggers on git commit operations, commit message writing, or when the user asks to commit changes.
---

# Git Commit Message Guidelines

## Message Structure

A commit message consists of a **subject line** and an optional **body**, separated by a blank line.

```
<subject line>

<body>
```

## Subject Line Rules

1. **Maximum 50 characters** - Keep it concise and scannable
2. **Capitalize the first letter** - Start with an uppercase letter
3. **No period at the end** - Trailing punctuation is unnecessary
4. **Use imperative mood** - Write as a command

## Body Rules

1. **Wrap at 72 columns** - Ensure readability in various git tools
2. **Separate from subject with blank line** - Required when body is present
3. **Explain what and why, not how** - The code shows how; the message explains the reasoning
