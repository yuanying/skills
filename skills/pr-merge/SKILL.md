---
name: pr-merge
description: |
  GitHub Pull Request をマージする手順書。マージ方法（merge, squash, rebase）を選択可能。
  トリガー: "pr-merge", "PRマージ", "プルリクエストマージ"
  使用場面: (1) PRのマージ実行、(2) マージ方法の選択、(3) fixupコミット整理後のマージ
---

# GitHub Pull Request マージ手順

## 引数の確認

**$ARGUMENTS**: マージ方法を指定（デフォルト: `merge`）

- `merge`: 通常のマージコミットを作成
- `squash`: すべてのコミットを1つにまとめてマージ
- `rebase`: リベースしてマージ

## 1. 現在のブランチと PR の確認

```bash
git branch --show-current
gh pr status
```

現在のブランチに関連する PR が存在するか確認する。

## 2. PR の詳細を確認

```bash
gh pr view
```

## 3. fixup コミットの整理（squash）

マージ前に、fixup コミットが残っていないか確認する。

```bash
git log --oneline origin/main..HEAD
```

fixup コミット（`fixup!` で始まるコミット）がある場合は整理する：

```bash
# エディタを開かずに自動実行
GIT_SEQUENCE_EDITOR=":" git rebase -i --autosquash origin/main
```

整理後、force push が必要な場合：

```bash
git push origin <branch-name> --force-with-lease
```

## 4. CI/チェックの確認

PR のチェックがすべて通過しているか確認する。

```bash
gh pr checks
```

チェックが失敗している場合は、問題を解決してから再度実行する。
チェックが終わってない場合は、完了を待ち再試行する。

## 5. PR をマージ

`$ARGUMENTS` に基づいてマージ方法を決定する：

| 引数 | コマンド |
|------|----------|
| `merge`（デフォルト） | `gh pr merge --merge` |
| `squash` | `gh pr merge --squash` |
| `rebase` | `gh pr merge --rebase` |

```bash
# merge（デフォルト）
gh pr merge --merge
# squash
gh pr merge --squash
# rebase
gh pr merge --rebase```

## 重要

- マージ前に必ず fixup コミットを整理すること
- CI/チェックがすべて通過していることを確認すること
- マージ後はローカルブランチを削除して整理すること
