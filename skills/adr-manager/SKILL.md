---
name: adr-manager
description: |
  設計の意思決定をADRとして docs/adr/ に書き出す。
  トリガー: "adr-manager", "/adr-manager"
  使用場面: (1) grill-meの後、(2) 重要な設計決定の記録、(3) ADRの更新・廃止
---

$ARGUMENTS

## 手順

### 1. 既存ADRの確認

```bash
ls docs/adr/ 2>/dev/null || echo "ADRディレクトリなし"
```

最大のADR番号を確認し、次の番号を決定する（例: 0007 → 次は 0008）。

### 2. 決定内容の特定

引数またはこの会話のコンテキストから記録すべき決定事項を抽出する。
grill-meの設計サマリーがある場合はそれを使う。

### 3. ADRファイルの生成

`docs/adr/NNNN-[kebab-case-title].md` として以下のテンプレートで作成する：

```markdown
# NNNN. [タイトル]

- Date: YYYY-MM-DD
- Status: Accepted

## Context

[この決定が必要になった背景・制約]

## Decision

[何をどう決めたか]

## Consequences

[この決定によって生じること・トレードオフ]
```

### 4. ADRのステータス管理

既存ADRが新しい決定で上書きされる場合：
- 古いADRのStatusを `Superseded by [[NNNN]]` に更新する
- 廃止の場合は `Deprecated` に更新する
