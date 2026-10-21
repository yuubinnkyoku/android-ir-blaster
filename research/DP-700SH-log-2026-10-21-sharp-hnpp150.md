# DP-700SH調査ログ追補：Sharp HN-PP150の更新手順比較（2026-10-21）

## 一次資料から確定

Sharp公式のAQUOSフォトプレーヤーHN-PP150更新手順（6ページ）には、`TH150400.ver` をSDカードのルートに保存し、`各種設定と確認 → バージョンの確認` でリモコンの `赤 → 黄 → 青 → 緑` を押して更新画面に入ると明記されている。更新後の表示は `1.04.00.04`。2011-10-20付の案内はHN-PP100を対象外としている。

## 比較から分かること・推測の限界

先代FUJIFILM DP-70SHには `拡大 → 縮小 → 時計 → 回転` という別の隠しキー列が存在する。Sharp製写真機器でバージョン画面から更新画面へ入る設計の別例が確認できたが、機種間で操作列は同一ではない。DP-700SHの隠しキー列・SoC・OS・IRコード・更新パッケージ形式は未確定。HN-PP150用ファームはDPシリーズに適用しない。Sharp配布ページの使用許諾には逆解析禁止があり、ここでは公開手順だけを比較した。

## 出典

- https://jp.sharp/support/photoplayer/doc/how_to_update.pdf （特に1～4ページ）
- https://www.sharp.co.jp/support/photoplayer/fw_update.html
- https://jp.sharp/support/photoplayer/fw_agree.html

## 継続課題

DP-700SH用`TH34_dpf.pkg`本体、DP-700SH公式更新手順PDF本文、SoC/OS・基板写真、純正`RRMCG2009SCZZ`の実測IR、Sharpと台湾側ODMの直接契約資料は未回収。
