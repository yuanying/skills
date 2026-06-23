---
name: git-push
description: |
  git push 時のルールとガイドライン。
  トリガー: "git push", "push", "プッシュ"
  使用場面: (1) リモートへのプッシュ、(2) ブランチのプッシュ、(3) 上流ブランチの設定
---

# Git Push ガイドライン

## ルール

### リモートブランチを必ず明示する

`git push` を実行する際は、**必ずリモート名とブランチ名を明示**すること。
引数なしの `git push` や `git push origin` のような省略形は使用しない。

```bash
# 正しい
git push origin <branch-name>
git push -u origin <branch-name>

# 禁止
git push
git push origin
```

## 重要

- `main` / `master` ブランチへの force push は絶対に行わない
