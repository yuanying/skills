# Agent Skills

[Pi](https://pi.dev/) や [Claude Code](https://claude.ai/code) で使うスキル集です。

## インストール

```bash
npx skills install github:yuanying/skills
```

ローカルのこのリポジトリから `~/.agents/skills` と `~/.claude/skills` にシンボリックリンクでインストールする場合:

```bash
./scripts/install-skills.sh
```

## スキル一覧

| スキル | 説明 |
|--------|------|
| [git-commit](skills/git-commit/SKILL.md) | コミットメッセージのフォーマットガイドライン |
| [git-push](skills/git-push/SKILL.md) | push 先のリモートとブランチを明示するためのガイドライン |
| [poteto-mode](skills/poteto-mode/SKILL.md) | 実装・レビュー・PR のプレイブック集。Pi では `/skill:poteto-mode` で明示的に起動 |
| [pr-merge](skills/pr-merge/SKILL.md) | Pull Request のマージ手順 |
| [work-report](skills/work-report/SKILL.md) | 作業セッション後のレポート自動生成 |
| [grill-me](skills/grill-me/SKILL.md) | 設計の意思決定を1問ずつ引き出す |
| [adr-manager](skills/adr-manager/SKILL.md) | 設計決定を ADR として `docs/adr/` に永続化し、規約に照らしてレビュー |
| [hunk-review](skills/hunk-review/SKILL.md) | hunk を使ったコードレビュー |
| [show-me](skills/show-me/SKILL.md) | 説明を図・スケッチで見せる（擬似コード・ツリー・Mermaid・diff・HTML） |

### 外部由来のスキル

| スキル | 出典 | ライセンス |
|--------|------|-----------|
| show-me | [humanlayer/skills](https://github.com/humanlayer/skills/tree/main/plugins/show-me) v1.0.0 | MIT |
| poteto-mode | [pstack](https://github.com/cursor/plugins/tree/b7b93c36be9bcc36a74db438e0fd385d660bc559/pstack) `b7b93c3`（[取り込み範囲](skills/poteto-mode/UPSTREAM.md)） | MIT |

## grill-me + adr-manager ワークフロー

設計の意思決定を漏れなく引き出し、ADR として永続化するワークフロー。

```
1. /grill-me <機能・要件>
   → 設計の意思決定を1問ずつ引き出す（約20問）

2. /adr-manager
   → 決定内容を docs/adr/ に ADR として書き出す
     （書く・書かないの規約 skills/adr-manager/adr-authoring.md で自己点検する）

3. 実装フェーズ
   → Pi で /skill:poteto-mode を起動し、ADR を参照しながら実装
```
