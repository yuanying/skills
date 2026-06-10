---
name: anima-prompt
description: |
  Anima（circlestone-labs/Anima）向けの最適化されたプロンプトを生成するスキル。1〜2人のキャラクターに対応。
  トリガー: "anima-prompt", "/anima-prompt", "animaプロンプト", "Animaのプロンプト生成", "anima prompt"
  使用場面: (1) Animaモデルで画像を生成する前にプロンプトを作りたいとき、(2) 複数キャラクターの構成を整理したいとき、(3) タグ構造がわからないとき
---

Anima モデル向けのプロンプトをインタラクティブに組み立てます。

## Anima プロンプト規則（厳守）

### タグ順序（固定）

```
[quality/meta/year/safe] [count] [character(s)+appearance] [series] [artist] [style] [tags] [environment] [nltags]
```

### タグ記法
- 全て小文字、スペース区切り（アンダースコア不使用）
- スコアタグのみアンダースコア使用: `score_9`, `score_8` など
- アーティストタグは `@` 必須: `@wlop`, `@fkey`
- キャラクター名の作品は括弧で: `hatsune miku (vocaloid)`
- BREAK タグは Anima では効果なし（使用しない）

### 安全タグ
- ポジティブに `safe` / `sensitive` / `nsfw` / `explicit` のいずれかを明示
- ポジティブが `safe` → ネガティブに `nsfw, explicit` を追加

---

$ARGUMENTS

## フェーズ1: 情報収集（1問ずつ確認）

`$ARGUMENTS` と会話の文脈からすでに判明している項目はスキップする。

### ステップ1: キャラクター数

何人のキャラクターを描くかを確認する（1人 or 2人）。

### ステップ2: キャラクター情報

**1人の場合:**
- キャラクター名（作品名）: 例「初音ミク（ボーカロイド）」「オリジナルキャラ」
- 外見: 髪型・髪色・目の色・体型など（服装は含めない）
- 服装・小物（省略可）

**2人の場合:** 上記をキャラクター1・キャラクター2それぞれについて確認する。

キャラクター名・作品名が不明な場合は外見説明のみでも可。

### ステップ3: シーン・構図・ポーズ

何をしているシーンか、どんな構図かを確認する。
- 例: 「全身立ち絵、カメラ目線、笑顔」「上半身、本を読んでいる」「2人で向き合っている」

### ステップ4: アーティストスタイル

好みの画師名か画風を確認する（省略可）。
- アーティスト指定あり → `@画師名` 形式で使用
- 省略 → `artist` フィールドを空にする
- **2人以上は画面が不安定になるため、1名を推奨する旨を案内する**

### ステップ5: 背景・環境・ライティング

背景や光源の要望を確認する（省略可）。
- 例: 「夜の街、ネオンライト」「白背景」「夕焼けの草原」

### ステップ6: 安全レベル

生成するコンテンツの安全レベルを確認する:
- `safe`: 全年齢向け
- `sensitive`: 水着・下着程度
- `nsfw`: 成人向け（非明示的）
- `explicit`: 成人向け（明示的）

### ステップ7: アスペクト比

画像の比率を確認する（省略時は `1:1`）:
- `9:16`（縦型・キャラ立ち絵向け）
- `1:1`（正方形・デフォルト）
- `16:9`（横型・シーン向け）
- `3:2`, `4:3`, `16:10`, `21:9` など

---

## フェーズ2: プロンプト組み立て

収集した情報を以下のルールで組み立てる。

### quality_meta_year_safe の構成

```
masterpiece, best quality, score_9, score_8, score_7, highres, newest, year 2025, <safe_tag>
```

### count の決定

| 人数 | タグ |
|------|------|
| 1人（女性） | `1girl` |
| 1人（男性） | `1boy` |
| 1人（不明） | `1other` |
| 2人（女性2） | `2girls` |
| 2人（男性2） | `2boys` |
| 2人（混合） | `1girl, 1boy` |

### キャラクターブロックの組み立て

**1人の場合:**
```
<character_name> (<series>), <appearance>
```

**2人の場合（順番固定）:**
```
<character1_name> (<series1>) with <appearance1>, <character2_name> (<series2>) with <appearance2>
```
- `tags` フィールドに位置タグを追加: `on the left, on the right` または `side by side`
- ネガティブプロンプトに `duplicate, twins, clone` を追加

### デフォルトネガティブプロンプト

```
worst quality, low quality, score_1, score_2, score_3, blurry, jpeg artifacts, bad anatomy, bad hands, bad feet, extra fingers, missing fingers, extra toes, text, watermark, logo
```

安全タグが `safe` の場合は末尾に `, nsfw, explicit` を追加。
2人の場合は末尾に `, duplicate, twins, clone` を追加。

---

## フェーズ3: 出力

### 出力1: ComfyUI 用 JSON

```json
{
  "aspect_ratio": "<ratio>",
  "quality_meta_year_safe": "<quality tags>",
  "count": "<count>",
  "character": "<character block>",
  "series": "<series if single char>",
  "appearance": "<appearance if single char>",
  "artist": "<@artist or empty>",
  "style": "<style tags or empty>",
  "tags": "<action, composition, clothing, expression, camera>",
  "environment": "<background, lighting or empty>",
  "nltags": "",
  "neg": "<negative prompt>"
}
```

2人の場合は `character` フィールドに2人分を含め、`appearance` は空にする。

### 出力2: プレーンテキストプロンプト

ComfyUI の CLIPTextEncode に貼れる形式でも出力する:

**ポジティブ:**
```
<quality_meta_year_safe>, <count>, <character+appearance>, <artist>, <style>, <tags>, <environment>
```

**ネガティブ:**
```
<neg>
```

### 出力3: 推奨パラメータ

| パラメータ | 推奨値 |
|-----------|--------|
| Steps | 30 |
| CFG | 4.5 |
| Sampler | er_sde |
| Scheduler | simple |
