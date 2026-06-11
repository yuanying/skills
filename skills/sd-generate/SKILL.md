---
name: sd-generate
description: |
  sdctl CLI を使って Stable Diffusion で画像を生成するスキル。txt2img・img2img・モデル管理をインタラクティブに実行する。
  トリガー: "sd-generate", "/sd-generate", "画像生成", "stable diffusion", "StableDiffusion", "SD画像", "txt2img", "img2img"
  使用場面: (1) テキストプロンプトから画像を生成したいとき (txt2img)、(2) 既存の画像をプロンプトで変換したいとき (img2img)、(3) 利用可能なモデルを確認・切り替えたいとき
---

`sdctl` CLI を使って Stable Diffusion で画像を生成します。

## 前提条件

以下がセットアップされていることを確認する。未セットアップの場合はユーザーに案内する。

### sdctl のインストール

```bash
go install github.com/yuanying/sdctl@latest
```

- Go 1.21+ が必要

### Stable Diffusion WebUI の起動

AUTOMATIC1111 WebUI が **API 有効**で起動していること：

```bash
# WebUI 起動時に --api フラグが必要
./webui.sh --api
```

### 接続先の設定（デフォルト: `http://localhost:7860`）

設定の優先順位（高い順）: CLIフラグ > 環境変数 > 設定ファイル

```bash
# 環境変数で上書き可能
export SDCTL_URL=http://myserver:7860
```

設定ファイル (`~/.config/sdctl/config.yaml`):

```yaml
url: http://localhost:7860
```

`--config` フラグで別の設定ファイルを指定することも可能：

```bash
sdctl --config /path/to/config.yaml txt2img "a cat"
```

$ARGUMENTS

## フェーズ1: インテント判定

`$ARGUMENTS` と会話の文脈から、以下のいずれかを判定する：

- **txt2img**: テキストプロンプトから画像を生成（デフォルト）
- **img2img**: 既存画像をプロンプトで変換
- **models**: モデルの一覧確認または切り替え

## フェーズ2: パラメータ収集（インタラクティブ）

判定したインテントに応じて、以下の順序で1項目ずつ確認する。
すでに `$ARGUMENTS` や会話の文脈から判明している項目はスキップする。

**設定ファイルの利用**: ユーザーが `--params` や `--prompt` ファイルを指定している場合、そのファイルの値をデフォルトとして扱い、CLIフラグで上書きできる点を案内する。

### txt2img の場合

1. **プロンプト** — 生成したい画像の説明（英語推奨）。`--prompt` ファイル指定時は省略可
2. **ネガティブプロンプト** — 除外したい要素（省略可。`--params` ファイルのデフォルト値を使用）
3. **画像サイズ** — 以下から選ぶか、カスタム値を入力
   - `512×512`（デフォルト）
   - `768×512`（横長）
   - `512×768`（縦長）
   - `1024×1024`（高解像度）
4. **ステップ数** — 生成品質に影響（デフォルト: 20、高品質: 50）
5. **出力先ディレクトリ** — デフォルト: カレントディレクトリ。複数枚生成時はディレクトリ必須

### img2img の場合

上記 txt2img の項目に加えて：

6. **入力画像パス** — 変換元の画像ファイルパス
7. **デノイジング強度** — 0.0（原画に近い）〜 1.0（大きく変換）。デフォルト: 0.75

### models の場合

フェーズ3に進み、まずモデル一覧を表示する。

## フェーズ3: コマンド実行 & 結果報告

確認したパラメータでコマンドを実行する。

### txt2img の実行

```bash
# 基本的な実行
sdctl txt2img "<prompt>" \
  -n "<negative_prompt>" \
  --width <width> --height <height> \
  --steps <steps> \
  --cfg-scale <cfg_scale> \
  --sampler "<sampler>" \
  --scheduler "<scheduler>" \
  --seed <seed> \
  --batch-count <batch_count> \
  --batch-size <batch_size> \
  -o <output_dir>

# パラメータファイルを使用する場合
sdctl txt2img "<prompt>" --params params.yaml -o <output_dir>

# プロンプトファイルとパラメータファイルを両方使用する場合
sdctl txt2img --params params.yaml --prompt prompt.yaml -o <output_dir>
```

省略されたフラグは使わない。パラメータファイルで指定済みの値は CLIフラグを省略できる。

### img2img の実行

```bash
# 基本的な実行
sdctl img2img "<prompt>" <input_image> \
  -n "<negative_prompt>" \
  --denoising <denoising_strength> \
  -o <output_dir>

# パラメータファイルを使用する場合
sdctl img2img --params params.yaml --prompt prompt.yaml <input_image>
```

### パラメータファイルのフォーマット

**パラメータファイル** (`params.yaml`) — 生成設定とデフォルトネガティブプロンプト：

```yaml
negative_prompt: "bad quality, blurry, worst quality"
steps: 30
width: 768
height: 768
cfg_scale: 8.0
sampler: "DPM++ 2M"
scheduler: "Karras"
seed: -1
batch_count: 1
batch_size: 1
denoising_strength: 0.75  # img2img のみ
```

**プロンプトファイル** (`prompt.yaml`) — ポジティブプロンプトとオプションのネガティブプロンプト上書き：

```yaml
prompt: "a beautiful landscape, golden hour, cinematic"
negative_prompt: "ugly, distorted"  # params.yaml のデフォルトを上書き
```

### models の実行

```bash
# 一覧表示
sdctl models list

# モデル切り替え（ユーザーが選択した場合）
sdctl models set <model_name>
```

### 結果報告

コマンド実行後、以下を報告する：

- 生成された画像ファイルのパス
- 使用したパラメータのサマリー
- モデル切り替えの場合は新しいモデル名
