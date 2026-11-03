---
name: adr-manager
description: |
  設計の意思決定をADRとして docs/adr/ に書き出す。既存のADRを規約に照らしてレビューする。
  トリガー: "adr-manager", "/adr-manager", "ADRをレビューして"
  使用場面: (1) grill-meの後、(2) 重要な設計決定の記録、(3) ADRの更新・廃止、(4) ADRやその差分のレビュー
---

$ARGUMENTS

ADR に何を書き何を書かないかの規約は [adr-authoring.md](adr-authoring.md)、雛形は [template.md](template.md) にある。
作成もレビューも、この 2 つだけを基準にする。規約の ID（A-1 など）は adr-authoring.md の表を指す。

引数や依頼が既存の ADR の点検であれば「レビューの手順」に、それ以外は「作成の手順」に従う。

## 作成の手順

### 1. 既存ADRの確認

```bash
ls docs/adr/ 2>/dev/null || echo "ADRディレクトリなし"
```

最大のADR番号を確認し、次の番号を決定する（例: 0007 → 次は 0008）。

### 2. 決定内容の特定

引数またはこの会話のコンテキストから記録すべき決定事項を抽出する。
grill-meの設計サマリーがある場合はそれを使う。

### 3. 規約と雛形を読む

[adr-authoring.md](adr-authoring.md) と [template.md](template.md) を読む。
既存の ADR があれば、関連しそうなものも読む（E-2 の食い違い、F-2 の用語合わせのため）。

### 4. 下書きを作る

`docs/adr/NNNN-[kebab-case-title].md` として、template.md の雛形で下書きを作る。
会話から抜き出した内容のうち、ADR に属さないもの（実装の詳細、移行のタスクなど）は
adr-authoring.md の「D-4 の判定」の移し先の表に従って外し、どこへ移すべきかをユーザーに伝える。

### 5. 規約で自己点検する

adr-authoring.md の MUST の規約を、表の順に 1 つずつ下書きに当てる。

- 違反は直す。
- 直せないもの（一次資料が手元に無く C-1 を満たせない、など）は、どの規約をなぜ満たせないかをユーザーに伝える。
- SHOULD を外したものは、外した理由をユーザーへの報告に書く。

### 6. Status を決める

- 未確定の事項が残っていれば `Proposed`（G-1）。
- 残っていなければ `Accepted`。

### 7. 置き換え・廃止を反映する

新しい ADR が既存の ADR を置き換える、または既存の ADR を廃止する場合は、同じ変更で次を直す（E-1）。

- 古い ADR の Status を `Superseded by ADR-NNNN` または `Deprecated` にする。
- 新旧両方の Related ADRs に関係を書く。
- その ADR を参照している他の ADR と、ADR の一覧（README などにあれば）を追従させる。

## レビューの手順

既存の ADR、または ADR の差分（`git diff -- docs/adr/` や PR の差分）を点検する。

1. 対象の ADR と [adr-authoring.md](adr-authoring.md) を読む。差分の場合も、変更された ADR の全文と、Related ADRs に挙がった ADR を読む。
2. adr-authoring.md の規約を、A から G まで表の順に 1 つずつ当てる。
3. 違反を、規約 ID・強度・場所（ファイルと節の見出し）・何が違反か・どう直すかの形で挙げる。MUST の違反を先に並べる。
   - 例: `[D-4 SHOULD] docs/adr/0012-notify-retry.md の Decision: 環境変数名と区切り文字まで決めている。方針だけを残し、形式は仕様書へ移す。`
4. SHOULD を外していても、その理由が ADR かその PR に書かれていれば違反として挙げない。
5. 規約に当たらないが繰り返し出そうな指摘は、規約の候補として別に挙げる（adr-authoring.md の「規約の足し方」）。

レビューでは指摘だけを返す。ADR の修正は、ユーザーが求めたときに作成の手順 5〜7 に沿って行う。
