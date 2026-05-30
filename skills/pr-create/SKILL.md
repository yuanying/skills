---
name: pr-create
description: |
  GitHub の Pull Request を作成する手順書。
  トリガー: "pr-create", "PR作成", "プルリクエスト作成"
  使用場面: (1) Pull Requestの作成、(2) Draft PRの作成、(3) ブランチのPR化
---

# GitHub Pull Request 作成手順

## 1. 現在のブランチを確認

```bash
git branch --show-current
```

## 2. 既存PRの確認

現在のブランチに既にPRが存在するか確認する：

```bash
gh pr view
```

PRが既に存在する場合は、ユーザーに通知し、新規作成するか既存PRを更新するか確認する。

## 3. main ブランチにいる場合のみ：新しいブランチを作成

### 3-1. 変更があるかを確認

```bash
git status --porcelain
```

変更がない場合はユーザーに通知して終了する。

### 3-2. 新しいブランチを作成

変更がある場合、変更内容に基づいて適切なブランチ名を決定する。

**ブランチ名の規則:**
- 必ず英単語を使用する（日本語は使用しない）
- 形式: `feature/<機能名>`, `fix/<修正内容>`, `refactor/<リファクタ内容>` など
- 例: `feature/add-user-auth`, `fix/login-validation`, `refactor/api-client`

```bash
git fetch origin
git checkout -b <branch-name> origin/main
```

## 4. 未コミットの変更をコミット

```bash
git status --porcelain
```

変更がある場合は、意味のある単位でコミットを作成する。

```bash
git add <files>
git commit -m "<commit-message>"
```

## 5. fixup コミットの整理

fixup コミットが残っている場合は、`autosquash` で整理する。

```bash
git log --oneline origin/main..HEAD
```

fixup コミット（`fixup!` で始まるコミット）がある場合：

```bash
# エディタを開かずに自動実行
GIT_SEQUENCE_EDITOR=":" git rebase -i --autosquash origin/main
```

## 6. リモートにプッシュ

```bash
git push -u origin <branch-name>
```

## 7. Pull Request を作成

**引数の確認:** `$ARGUMENTS`

- `$ARGUMENTS` が空、または `draft` 以外の場合: 通常のPRを作成
- `$ARGUMENTS` に `draft` が含まれる場合: Draft PRを作成

```bash
# 通常のPR
gh pr create --base main --title "<PRタイトル>" --body "<PR説明>"

# Draft PR
gh pr create --base main --draft --title "<PRタイトル>" --body "<PR説明>"
```

- タイトル: 変更内容を簡潔に表す
- 説明: 変更の目的、影響範囲、テスト方法などを記載

## 重要

- コミットメッセージは変更内容を明確に表すものにする
- PRのタイトルと説明は、レビュアーが変更内容を理解しやすいように記載する
- mainブランチから新しいブランチを作成する際は、必ず最新の状態から作成する
