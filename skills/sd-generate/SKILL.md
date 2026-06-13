---
name: sd-generate
description: |
  sdctl CLI を使って Stable Diffusion WebUI (AUTOMATIC1111) で画像生成・変換・生成環境確認を行うスキル。
  トリガー: "sd-generate", "/sd-generate", "画像生成", "stable diffusion", "StableDiffusion", "SD画像", "txt2img", "img2img", "モデル一覧", "model", "modules", "vae", "text encoder", "sampler", "scheduler", "params.yaml", "prompt.yaml"
  使用場面: (1) テキストプロンプトから画像を生成したいとき、(2) 既存画像をimg2imgで変換したいとき、(3) モデル・サンプラー・スケジューラー・VAE・text encoderを確認したいとき、(4) seed・CFG・batch・model・VAE・text encoder・YAML設定ファイルなどsdctl生成パラメータを指定して実行したいとき
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

```bash
# 環境変数で上書き可能
export SDCTL_URL=http://myserver:7860

# または設定ファイル
# url: http://localhost:7860

# 別の設定ファイルを使う場合
sdctl --config /path/to/config.yaml ...
```

$ARGUMENTS

## フェーズ1: インテント判定

`$ARGUMENTS` と会話の文脈から、以下のいずれかを判定する：

- **txt2img**: テキストプロンプトから画像を生成（デフォルト）
- **img2img**: 既存画像をプロンプトで変換
- **models**: モデルの一覧確認または切り替え
- **modules**: VAE / text encoder の一覧確認
- **samplers**: サンプラー一覧の確認
- **schedulers**: スケジューラー一覧の確認

## フェーズ2: パラメータ収集（インタラクティブ）

判定したインテントに応じて、以下の順序で1項目ずつ確認する。
すでに `$ARGUMENTS` や会話の文脈から判明している項目はスキップする。
指定がない項目は `sdctl` のデフォルト値を使い、不要な確認を増やさない。
リポジトリ内で作業する場合、既存の `params.yaml` と `prompt_XX_Y.yaml` があれば `--params` / `--prompt` を優先する。
画像生成時は、ユーザーが別指定した場合を除き `--batch-size 2` を使う。`params.yaml` を作成・更新する場合も `batch_size: 2` を標準にする。

### txt2img の場合

1. **プロンプト** — 生成したい画像の説明（英語推奨）
2. **ネガティブプロンプト** — 除外したい要素（省略可。省略時は空欄）
3. **設定ファイル** — 必要なら `--params <params.yaml>` と `--prompt <prompt.yaml>`
4. **画像サイズ** — デフォルト: `512x512`
5. **ステップ数** — デフォルト: `20`
6. **CFG scale** — デフォルト: `7`
7. **sampler** — デフォルト: `Euler a`。必要なら `sdctl samplers list` で確認する。
8. **scheduler** — 省略可。必要なら `sdctl schedulers list` で確認する。
9. **model checkpoint** — 生成ごとに切り替える必要がある場合のみ `--model <model_name>` を指定する。モデル名は `sdctl models list` と完全一致させる。
10. **VAE / text encoder** — モデルに必要な場合のみ `--vae <module_or_path>` と `--text-encoder <module_or_path>` を指定する。必要なら `sdctl modules` で module name と full path を確認する。
11. **seed** — デフォルト: `-1`（ランダム）
12. **batch** — 標準は `--batch-size 2` と `--batch-count 1`。必要な場合のみ変更する。
13. **出力先** — `--output` / `-o` は原則として保存先ファイルパスを指定する。ユーザーや手順が「出力先ディレクトリ」を指定している場合も、実行時はそのディレクトリ配下に適切なファイル名を付けたパスに変換する。省略時はカレントディレクトリ配下に適切なファイル名を付ける。

### img2img の場合

上記 txt2img の項目に加えて：

1. **入力画像パス** — 変換元の画像ファイルパス
2. **デノイジング強度** — `0.0`（原画に近い）〜 `1.0`（大きく変換）。デフォルト: `0.75`

`--prompt` を使う場合、コマンド引数は `sdctl img2img --prompt prompt.yaml input.png` または `sdctl img2img "override prompt" --prompt prompt.yaml input.png` にする。

### 管理系の場合

- **models**: 一覧表示か切り替えかを判定する。切り替え時はモデル名を確認する。生成ごとに指定するだけなら `models set` ではなく `--model` を使う。
- **modules**: VAE / text encoder の一覧を表示する。`--vae` / `--text-encoder` や `params.yaml` の `override_settings.forge_additional_modules` に指定する module name または full path を確認する。
- **samplers**: 一覧を表示する。
- **schedulers**: 一覧を表示する。

### YAML 設定ファイル形式

`params.yaml` は生成設定とデフォルトのネガティブプロンプトを保持する：

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
batch_size: 2
denoising_strength: 0.75
override_settings:
  sd_model_checkpoint: "SD1_QuinceMixV2"
  forge_additional_modules:
    - "qwen_image_vae.safetensors"
    - "qwen_3_06b_base.safetensors"
```

`prompt.yaml` はポジティブプロンプトと任意のネガティブプロンプト上書きを保持する：

```yaml
prompt: "a beautiful landscape, golden hour, cinematic"
negative_prompt: "ugly, distorted"
```

CLI 引数は YAML ファイルより優先される。プロンプト引数を指定した場合は `prompt.yaml` の `prompt` を上書きする。
model / VAE / text encoder は CLI と YAML で指定方法が異なる。CLI では `--model` / `--vae` / `--text-encoder` を使う。`params.yaml` では `override_settings.sd_model_checkpoint` と `override_settings.forge_additional_modules` を使い、`model:` / `vae:` / `text_encoder:` は書かない。`forge_additional_modules` は VAE を先、text encoder を後に並べる。

VAE / text encoder は module name と full path のどちらでも指定できる。module name は生成時に `/sdapi/v1/sd-modules` の一覧から full path に解決される。見つからない場合は元の値のまま API に渡される。

## フェーズ3: コマンド実行 & 結果報告

確認したパラメータでコマンドを実行する。

### txt2img の実行

```bash
sdctl txt2img "<prompt>" \
  -n "<negative_prompt>" \
  --width <width> --height <height> \
  --steps <steps> \
  --cfg-scale <cfg_scale> \
  --sampler "<sampler>" \
  --scheduler "<scheduler>" \
  --model "<model_name>" \
  --vae "<vae_module_or_path>" \
  --text-encoder "<text_encoder_module_or_path>" \
  --seed <seed> \
  --batch-count <batch_count> \
  --batch-size <batch_size> \
  -o <output_file>
```

設定ファイルを使う場合：

```bash
sdctl txt2img --params params.yaml --prompt prompt.yaml -o <output_file>
sdctl txt2img "override prompt" --params params.yaml -o <output_file>
```

省略値を使うフラグ、空のネガティブプロンプト、未指定の scheduler、未指定の model / VAE / text encoder、未指定の output はコマンドから省く。ただし `params.yaml` に `batch_size: 2` がない場合は、ユーザーが別指定しない限り `--batch-size 2` を付ける。

### img2img の実行

```bash
sdctl img2img "<prompt>" <input_image> \
  -n "<negative_prompt>" \
  --width <width> --height <height> \
  --steps <steps> \
  --cfg-scale <cfg_scale> \
  --sampler "<sampler>" \
  --scheduler "<scheduler>" \
  --model "<model_name>" \
  --vae "<vae_module_or_path>" \
  --text-encoder "<text_encoder_module_or_path>" \
  --seed <seed> \
  --denoising <denoising_strength> \
  --batch-count <batch_count> \
  --batch-size <batch_size> \
  -o <output_file>
```

設定ファイルを使う場合：

```bash
sdctl img2img --params params.yaml --prompt prompt.yaml <input_image> -o <output_file>
sdctl img2img "override prompt" --params params.yaml <input_image> -o <output_file>
```

省略値を使うフラグ、空のネガティブプロンプト、未指定の scheduler、未指定の model / VAE / text encoder、未指定の output はコマンドから省く。ただし `params.yaml` に `batch_size: 2` がない場合は、ユーザーが別指定しない限り `--batch-size 2` を付ける。

### models の実行

```bash
# 一覧表示
sdctl models list

# モデル切り替え（ユーザーが選択した場合）
sdctl models set <model_name>
```

生成コマンド単位でモデルを指定する場合は、永続的に切り替える `models set` ではなく `--model <model_name>` を使う。`--model` の値は `sdctl models list` に出るモデル名と完全一致させる。

### modules の実行

```bash
sdctl modules
```

VAE と text encoder の一覧を表示する。`sdctl modules` の出力にある module name または full path は、`--vae` / `--text-encoder` と `params.yaml` の `override_settings.forge_additional_modules` に指定できる。

### samplers / schedulers の実行

```bash
sdctl samplers list
sdctl schedulers list
```

### model / VAE / text encoder の指定

生成時の CLI 指定：

```bash
sdctl txt2img "anime girl" \
  --model animagineXLV31_v31 \
  --vae qwen_image_vae.safetensors \
  --text-encoder qwen_3_06b_base.safetensors
```

`params.yaml` に保存する場合：

```yaml
override_settings:
  sd_model_checkpoint: "SD1_QuinceMixV2"
  forge_additional_modules:
    - "qwen_image_vae.safetensors"
    - "qwen_3_06b_base.safetensors"
```

CLI の `--model` は `params.yaml` の `override_settings.sd_model_checkpoint` より優先される。CLI の `--vae` / `--text-encoder` は `params.yaml` の `override_settings.forge_additional_modules` より優先される。`--model` / `--vae` / `--text-encoder` を指定した生成後は、sdctl の現在の仕様では WebUI 側の設定が維持される。

### 出力ファイル命名

- `-o` には可能な限りディレクトリではなくファイルパスを渡す。ユーザーがディレクトリを指定した場合、または手順に「出力先ディレクトリ」と書かれている場合は、そのディレクトリ配下に適切なファイル名を付けて `-o <dir>/<filename>.png` にする。
- シナリオワークスペースで `prompt_XX_Y.yaml` を使う場合は、同じシナリオの `outputs/image_XX_Y.png` を標準名にする。例: `kutara_aki/01_example/prompt_02_1.yaml` なら `kutara_aki/01_example/outputs/image_02_1.png`。
- プロンプトファイル名がない場合は、用途が分かる短い snake_case 名を作る。例: `portrait_desk.png`, `window_reading.png`, `toy_plane_fullbody.png`。
- 複数枚生成する場合もベース名を付ける。`sdctl` は `-o result.png` のようにファイルを指定して複数枚生成すると `result.0001.png`, `result.0002.png` のように保存するため、ベース名が分かるファイルパスを渡す。
- 明示的にディレクトリ保存の挙動を確認したい場合だけ、ディレクトリをそのまま `-o` に渡してよい。その場合は `output-TIMESTAMP-N.png` 形式になり得ることを報告する。

### 結果報告

コマンド実行後、以下を報告する：

- 生成された画像ファイルのパス
- 使用したパラメータのサマリー
- 管理系コマンドの場合は表示・変更した対象
