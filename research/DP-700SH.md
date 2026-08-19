# FUJIFILM DP-700SH リバースエンジニアリング調査メモ

最終更新: 2026-08-20 JST

この文書は DP-700SH のハードウェア、ファームウェア、赤外線リモコン、製造元を追跡するための作業メモ。確定情報と推測を分ける。

## 現在の実機側の状況

- 対象: FUJIFILM DP-700SH
- 純正リモコンなし。
- nubia Z80 Ultra は Android の `android.hardware.consumerir` を持つことを実機で確認済み。
- `yuubinnkyoku/android-ir-blaster` を Signal Tester / 総当たり探索向けに改造済み。
- 現在 Sharp 13-bit 系を実機で総当たり中。
  - 入力表示上は 16-bit / 65,536 通りに見えるが、無接頭辞探索では内部カーソルが Sharp の実効 13-bit に最適化される。
  - 実際の固有候補は 8,192 通り (`0x0000`–`0x1FFF`)。
- DP-700SH はリモコン受光部の指向性/配置が扱いづらいという実機レビューがあるため、送信機の向きは重要。

## 確定度: 高

### 製造元は SHARP

実機背面ラベルで「製造元 SHARP」を確認済み。2010年当時の所有者ブログにも同じ表示の記録がある。

参考:
- https://minkara.carview.co.jp/userid/176568/blog/18787364/

ただし「製造元 SHARP」だけでは SoC や全ソフトウェアスタックまで SHARP 製とは限らない。

### 液晶は SHARP 製

DP-1020SH / DP-850SH / DP-700SH はいずれも SHARP 製液晶を採用。DP-700SH は 7型 800x480 ASV 液晶。

参考:
- https://dc.watch.impress.co.jp/docs/news/346441.html
- https://www.bcnretail.com/news/detail/100203_16329.html

### 2010年に DP-1020SH / DP-850SH / DP-700SH 共通のファームウェア更新が存在

2010-04-30 に富士フイルムが新ファームウェアを公開。修正内容は IrSimple / IrSS / IrDA の通信がイレギュラー操作で中断した際、まれにシステムがハングする問題。

旧公式URL:
- http://fujifilm.jp/support/digitalphotoframe/download/dp1020sh_dp850sh_dp700sh/download001.html

記事:
- https://dc.watch.impress.co.jp/docs/news/365704.html

更新ファイル本体とファイル名は未回収。2026-08-20時点の通常Web検索でもバイナリ名は特定できていない。

### miniUSB は通常の USB デバイス接続用

取扱説明書から、PC と接続し内蔵メモリを読み書きするための USB mini-B 端子であることを確認済み。サービス専用端子という証拠はない。

同系列の DP-1020SH の実使用記録でも miniUSB 経由でPCから本体へ大量画像をコピーしていたことが確認できる。

参考:
- https://kurukuru-chaccha.seesaa.net/article/201004article_1.html

### IrSimple/IrSS の画像転送用赤外線とリモコン受光は別用途

DP-700SH は画像転送用の高速赤外線通信機能を持つ。一方で付属リモコンもあり、リモコン用受光部が存在する。画像転送プロトコルを送るだけではリモコン操作の代用にならない。

### DP-700SH のリモコン受光位置/指向性に注意

価格.com の実機レビューでは、DP-70SHから配置が変わり、画像転送用赤外線ポートが側面寄りになったほか、リモコンも近距離・正面から反応しないことがあると報告されている。

参考:
- https://review.kakaku.com/review/K0000084345/

### `EP-D72F` は本体内部型番ではなく AC アダプター型番

中古出品で `DP-700SH EP-D72F` と併記される例があるが、別の流通情報から `EP-D72F` は SHARP の AC アダプター型番と判明。SoC/基板型番探索には使えない。

5V / 2A 系として流通している記録がある。DP-700SH と SHARP の電源部品上のつながりを示す材料にはなる。

## 確定度: 中～高

### 先代 DP-70SH には隠れたファームウェア書き換え操作が存在

DP-70SH の公式ファーム更新手順についての当時の記事では、バージョン表示画面からリモコンで

`拡大 → 縮小 → 時計 → 回転`

と押すことでファームウェア書き換え画面へ入る手順が記録されている。

参考:
- https://dc.watch.impress.co.jp/cda/accessories/2009/04/01/10602.html

DP-700SHで同じシーケンスが使えるかは未確認。純正キーコードが取得できたら優先的に試す価値が高い。

### DP-850SH / DP-1020SH の開発案件は Sharp 顧客案件として記録されている

台湾・新竹の技術者の公開職歴に、2009-10〜2010-02のプロジェクトとして

- `Digital Photo Frame - FUJIFILM DP-850SH/DP-1020SH`
- `Customer: Sharp`

と記録されている。

参考:
- https://tw.linkedin.com/in/%E7%92%A7%E7%B6%AD-dusty-shyr-%E7%9F%B3-a6ab8a5b

DP-700SH はこの記載には含まれていない。ただし DP-700SH / 850SH / 1020SH は同時期シリーズで、2010年のファーム更新内容も共通だったため、Sharp が単なる液晶供給以上の役割を持った可能性を補強する材料として扱う。

### 同時期の SHARP AQUOS フォトプレーヤーは μITRON/eSOL 系

SHARP HN-PP100 / HN-PP150 は eSOL の `eCROS` を採用し、リアルタイムOSとして μITRON 4.0 準拠 `PrKERNELv4` を使用。

一次資料:
- https://www.esol.co.jp/archive/news/emb_press090512.html

DP-700SH が同じOSだという証拠はない。SHARP の同時期デジタル写真機器における比較候補として記録する。

### SHARP HN-PP150 の公式ファームは現在も記録が残る

2011-10-20版の更新ページが現存し、更新ファイル名は `TH150400.ver`、121MB。

参考:
- https://www.sharp.co.jp/support/photoplayer/fw_update.html
- https://www.sharp.co.jp/support/photoplayer/fw_agree.html

DP-700SHとの形式互換性を示す証拠はない。

## 純正リモコン調査

### `RRMCG2009SCZZ` という FUJIFILM DIGITAL PHOTO FRAME 用リモコンが実在

複数の中古流通記録で、FUJIFILM のデジタルフォトフレーム用リモコンとして `RRMCG2009SCZZ` が確認できる。

参考:
- https://paypayfleamarket.yahoo.co.jp/item/g1043790009
- 楽天市場の中古流通記録（`C2J710` / `C2J726` として RRMCG2009SCZZ が掲載）

ただし **DP-700SH との直接対応はまだ未確認**。現時点では候補型番扱い。

### DP-700SH 専用と明記されたリモコン単品の中古流通は存在

メルカリ検索結果に `【リモコンのみ本体無し】デジタルフォトフレーム DP-700SH` という出品が確認できる。

この個体の裏面ラベルまたは写真から部品番号を読めれば、`RRMCG2009SCZZ` との同一性を確定できる可能性が高い。

### リモコン型番が確定した場合の次の探索

- LIRC / Flipper Zero / IRDB 系の信号データ
- Sharp サービス部品番号データベース
- 同一リモコンが付属する他機種
- 各キーのアドレス・コマンド規則

を横断し、総当たりより先に既知コードを狙う。

## 赤外線探索

### 最優先: Sharp 13-bit

現在実機探索中。

`android-ir-blaster` の無接頭辞 Sharp 探索は実効13-bitだけを送るため、固有候補数は 8192。

反応した場合:
1. 即 Pause
2. Trigger で同一候補を再送
3. 再現したら Save Hit
4. `Sharp XXXX` のコードと実際の動作を記録

1キーでも見つかれば、同じアドレス/コマンド配置から残りの候補を大幅に絞れる可能性がある。

### 次候補

1. 内蔵IRデータベースの SHARP 候補
2. Kaseikyo / Sharp vendor `5AAA`
3. 同年代 SHARP フォトフレーム/フォトプレーヤーのリモコンコード
4. その他の一般的な家電IR形式

Kaseikyo は探索空間が大きいため、既知の SHARP コード/アドレス情報を集めてから部分探索する。

## 同系列機から得られる情報

### DP-1020SH でも miniUSB 転送時のフリーズ例あり

2010年の利用記録では、773枚・約436MBをPCから一括転送した際、途中で本体がフリーズした例がある。小分け転送では実用できていた。

参考:
- https://kurukuru-chaccha.seesaa.net/article/201004article_1.html

単なる実装品質の問題か、ファイルシステム/USBスタック/メモリ制約に由来するかは不明。OS推定の直接証拠ではないが、同系列ソフトウェアの挙動として記録する。

### DP-1020SH は電源接続部不具合で発売延期

2010-03 に一部個体の「電源接続部の不具合」により全数検査となり、発売が延期された。

参考:
- https://av.watch.impress.co.jp/docs/news/353844.html

DP-700SHの回路と共通かは不明。

## 未解決事項

- DP-700SH の SoC 型番
- RAM / Flash 型番
- メイン基板型番
- OS / RTOS
- 2010年公式更新ファイル本体とファイル名
- 更新ファイルの形式・署名・暗号化有無
- 純正リモコンの型番/部品番号（`RRMCG2009SCZZ` は候補）
- 純正リモコンの搬送波周波数とプロトコル
- DP-70SH の隠し更新シーケンスが DP-700SH に残っているか
- DP-700SH / DP-850SH / DP-1020SH の基板・ファーム共通範囲
- 850SH/1020SHを担当した台湾側開発組織・SoCベンダー

## 次に掘るもの

- Internet Archive / 古いミラー / キャッシュから旧 Fujifilm 更新ページとバイナリを回収
- DP-700SH / 850SH / 1020SH の分解写真・修理記録・基板写真を探索
- DP-700SH専用リモコン出品写真から裏面型番を特定し `RRMCG2009SCZZ` と照合
- SHARP の近縁機種で使われる IR コードを収集し Sharp / Kaseikyo の探索範囲を削減
- HN-PP100/150 や DP-70SH/701SH 系とのUI・更新方式・部品の比較
- 台湾側の開発経歴から ODM / SoC / ミドルウェアの手掛かりを逆引き

## 注意

推測を確定情報として扱わない。特に `SHARP製造 = eCROS/PrKERNELv4` ではない。OS候補はファームウェア、基板、文字列、サービス資料等で裏取りする。
