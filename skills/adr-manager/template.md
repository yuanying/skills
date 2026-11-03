# ADR の雛形

`docs/adr/NNNN-<kebab-case-title>.md` を、次の雛形で作る。
`[ ]` の中は書き方の指示であり、括弧ごと置き換える。括弧内の ID は `adr-authoring.md` の規約を指す。
該当する内容が無い節は「なし」と書き、節そのものは消さない。ただし Alternatives Considered は任意なので、書くことが無ければ節ごと消してよい。

```markdown
# NNNN. [決定の中身を表すタイトル（F-2）]

- Date: YYYY-MM-DD
- Status: [Proposed | Accepted | Deprecated | Superseded by ADR-NNNN（G-1）]

## Context

[このプロジェクトで実際に起きている問題・制約（C-2）。判断に必要な前提と用語を、ADR 単体で読めるように書く（C-3）。チケット番号や外部 URL は書かない（A-1）]

## Decision

[何をどう決めたか。実装の自由度を奪わない粒度で（D-4）、適用範囲を示して（D-3）書く。移行計画やタスクは書かない（D-1）。例外・暫定措置には失効条件を書く（D-2）]

### 本 ADR で決定しないこと

- [決めなかった事項]（委譲先: [別の ADR・仕様書・担当など、実在して辿れるもの]）（D-3）

## Consequences

[この決定で良くなること・悪くなること・受け入れるトレードオフ（D-5）]

## Alternatives Considered（任意）

[検討して採らなかった案と、採らなかった理由。判断に効いたものだけ]

## Related ADRs

- [Supersedes / Superseded by / Related]: ADR-NNNN [タイトル]（A-2、E-1）

## References

- [文書名・見出し]（[URL]、YYYY-MM-DD 確認）（A-1、C-1）
```
