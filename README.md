# Claude Code Skills

[Claude Code](https://claude.ai/code) 用のスキル集です。

## インストール

```bash
npx skills install github:yuanying/skills
```

## スキル一覧

| スキル | 説明 |
|--------|------|
| [git-commit](skills/git-commit/SKILL.md) | コミットメッセージのフォーマットガイドライン |
| [implement](skills/implement/SKILL.md) | 実装ワークフロー（ブランチ管理・コミット粒度） |
| [pr-create](skills/pr-create/SKILL.md) | Pull Request の作成手順 |
| [pr-merge](skills/pr-merge/SKILL.md) | Pull Request のマージ手順 |
| [pr-review-apply](skills/pr-review-apply/SKILL.md) | PR レビューフィードバックの適用 |
| [codex](skills/codex/SKILL.md) | Codex CLI（OpenAI）を使ったコード相談・レビュー |
| [work-report](skills/work-report/SKILL.md) | 作業セッション後のレポート自動生成 |
| [grill-me](skills/grill-me/SKILL.md) | 設計の意思決定を1問ずつ引き出す |
| [adr-manager](skills/adr-manager/SKILL.md) | 設計決定を ADR として `docs/adr/` に永続化 |

## grill-me + adr-manager ワークフロー

設計の意思決定を漏れなく引き出し、ADR として永続化するワークフロー。

```
1. /grill-me <機能・要件>
   → 設計の意思決定を1問ずつ引き出す（約20問）

2. /adr-manager
   → 決定内容を docs/adr/ に ADR として書き出す

3. 実装フェーズ
   → Claude Code が ADR を参照しながら実装
```
