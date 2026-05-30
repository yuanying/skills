---
name: pr-review-apply
description: |
  GitHub Pull Requestのレビュー内容を適用する手順書。PRレビューのフィードバックをコードに反映する際に使用。
  トリガー: "pr-review-apply", "レビュー適用", "レビュー反映"
  使用場面: (1) PRレビューのフィードバック反映、(2) レビューコメントへの対応、(3) コードレビュー修正
---

# PRレビュー内容の適用手順

## 現在のブランチに関連するPRの取得

まず、現在のブランチに関連するPRを確認します：

```bash
gh pr view
```

- `$ARGUMENTS` が指定されている場合は、以降のステップで `$ARGUMENTS` を使用する
- `$ARGUMENTS` が指定されていない場合は、`gh pr view` の結果からPR番号を特定して使用する

## PR URLのパース

以下のコマンドで PR のURLとブランチ名を取得します：

bash
gh pr view $ARGUMENTS --json url,headRefName

PRのURL `https://HOST/OWNER/REPO/pull/NUMBER` から以下を抽出して使用：
- `HOSTNAME`: ホスト名
- `OWNER`: リポジトリオーナー
- `REPO`: リポジトリ名
- `NUMBER`: PR番号

## 操作一覧

### 1. 現在のワークスペースの確認

現在のブランチを確認し、PRのベースブランチに切り替えます。

### 2. コメント取得

Issue Comments（PR全体へのコメント）:
bash
gh api --hostname HOSTNAME \
  repos/OWNER/REPO/issues/NUMBER/comments --jq '.[] | {id, user: .user.login, created_at, body}'

Review Comments（コード行へのコメント）:
bash
gh api --hostname HOSTNAME \
  repos/OWNER/REPO/pulls/NUMBER/comments --jq '.[] | {id, user: .user.login, path, line, created_at, body, in_reply_to_id}'

### 3. コメント内容の確認と適用

- 取得したコメントを確認し、コードに反映すべきフィードバックを特定する
- 各コメントの内容に基づき、ローカルリポジトリでコードを修正する
- 修正後、必要に応じてテストを実行し、動作確認を行う
- 修正が完了したら、変更をコミットし、プッシュする
  - コミットはレビューに関連する元のコミットに対して `--fixup` オプションを使用して行うことを推奨
  - 別のコミットとしてまとめたい場合は通常のコミットを行う

bash
git add <modified-files>
git commit --fixup=<commit-hash-of-original-change>
git push origin <headRefName>

#### 除外すべきコメント:
- Reply comments (`in_reply_to_id` is not null)
- Outdated comments (`line` is null for review comments)
- Non-actionable comments (e.g., "LGTM", "approved")
- Previously fixed comments

### 4. PRの更新

- **Important** 更新をプッシュした後、**必ず** PRの説明を更新し、変更に関連する返信を追加する

bash
gh api --hostname HOSTNAME \
  repos/OWNER/REPO/pulls/NUMBER/comments/COMMENT_ID/replies \
  --method POST \
  -f body="返信内容"

`COMMENT_ID`はコメント取得で得た`id`を使用。

## 重要

- `gh api` を使用する際、GitHub Enterprise Serverを使用している場合は `--hostname` オプションでホスト名を指定することを忘れないでください。
