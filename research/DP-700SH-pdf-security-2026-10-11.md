# DP-700SH / DP-850SH / DP-1020SH 共通更新手順PDFの構造

確認日: 2026-10-11

## 確定事項

2012-01-21のWayback保存版 `ff_dp1020sh_dp850sh_dp700sh_firmware_mn_j.pdf` はPDF 1.6、10ページ、内部長432,694バイト。トレーラーに `/Encrypt 57 0 R` があり、オブジェクト57には `/Filter /Standard`、`/V 2`、`/R 3`、`/Length 128`、`/P -1340` がある。PDF標準セキュリティの128ビットRC4方式であり、通常のコピー権限は無効（権限ビット5=0）。2014-04-21再訪版にも同じ辞書がある。

## 未確認・推測の区別

本文の更新操作・SDカード配置・隠しキー列は未抽出。アーカイブの文字列化された応答はPDFのバイナリを無損失に保持していないため、そのまま復号に使えない。閲覧パスワードの有無は未確認。PDFの暗号化は説明書ファイルの設定であり、`TH34_dpf.pkg`の暗号化や本体SoC/OSの証拠ではない。

## 出典

- https://web.archive.org/web/20120121040119id_/http://fujifilm.jp/support/digitalphotoframe/download/pack/pdf/ff_dp1020sh_dp850sh_dp700sh_firmware_mn_j.pdf
- https://web.archive.org/web/20140421055523id_/http://fujifilm.jp/support/digitalphotoframe/download/pack/pdf/ff_dp1020sh_dp850sh_dp700sh_firmware_mn_j.pdf
