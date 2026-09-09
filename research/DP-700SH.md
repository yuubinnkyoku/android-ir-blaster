# FUJIFILM DP-700SH リバースエンジニアリング調査メモ

最終更新: 2026-09-09 JST

DP-700SH のハードウェア、ファームウェア、赤外線リモコン、開発/製造系統を追跡する作業メモ。**確定情報・状況証拠・推測を分ける**。詳細な探索経路は `research/DP-700SH-log.md` に残す。

## 現在の実機側の状況

- 対象: FUJIFILM DP-700SH
- 純正リモコンは手元にない。
- nubia Z80 Ultra で `android.hardware.consumerir` を確認済み。
- `yuubinnkyoku/android-ir-blaster` を Signal Tester / 総当たり探索向けに改造し、APK導入済み。
- 現在 Sharp 13-bit 系を実機で総当たり中。
  - UIは4桁hexのため65,536通りに見える。
  - 無接頭辞Sharp探索は内部で13-bitに正規化され、固有候補は8,192 (`0000`–`1FFF`)。
- 反応が出た場合は Pause → Triggerで同一候補を再送 → 再現したらSave Hit。
- 実機の「本体情報の表示」で **Ver.1.03.00** を確認済み。
- FUJIFILM公式公開更新版は **Ver.1.04.00** とWayback保存版で確認済み。したがって手元個体の1.03.00は公開更新前の版。

## 確定度: 高

### DP-700SHの銘板上の製造元はSHARP

2026-08-21にユーザー提供の実機背面写真から、DP-700SH本体銘板を直接確認した。

- `デジタルフォトフレーム DP-700SH W`
- `定格: 5V 8W`
- `販売元: 富士フイルム株式会社`
- **`製造元: シャープ株式会社`**
- `製造番号: 0T070764`
- `MADE IN CHINA`

これは従来の「Sharp製液晶・Sharp製ACアダプター・SharpをCustomerとする開発案件」という状況証拠より強く、**完成品DP-700SHの銘板上の製造元がSharpであることを直接示す**。

同時代の2010-07-07の利用者ブログにも、DP-700SHについて「後ろの製造元にはシャープ製って書いてある」という実機観察が残り、別個体でも同じ表示だったことを補強する。

参考:
- https://minkara.carview.co.jp/userid/176568/blog/18787364/
- 2026-08-21 ユーザー提供実機写真

**注意:** 銘板上の製造元がSharpであることと、SoC・メイン基板・OSの全設計をSharp社内だけで行ったことは同義ではない。台湾側の外部開発チーム/ODMへの委託可能性は引き続き残る。

### SHARP製液晶を採用

DP-1020SH / DP-850SH / DP-700SH はSHARP製液晶を採用。DP-700SHは7型800×480 ASV液晶。

参考:
- https://dc.watch.impress.co.jp/docs/news/346441.html
- https://www.bcnretail.com/news/detail/100203_16329.html

銘板から完成品の製造元もSharpと確認できたが、SoC/基板設計の詳細までは未確認。

### DP-700SHの標準ACアダプターはSHARP `EP-D72F`

中古販売記録で、DP-700SHの付属品としてACアダプター型番 `EP-D72F` が明記されている。ユーザー提供実機写真でもラベルを直接確認できた。

- `ACアダプター EP-D72F`
- `SHARP`
- 入力: `AC 100V-240V 900mA 50/60Hz`
- 出力: `DC 5V 2A`
- `MODEL: T04A-05200D2-S2`
- `1014-03814`
- `MADE IN CHINA`
- `ATECH`

実機写真を拡大して再確認すると、型番は **`T04A-05200D2-S2`**。以前の `T04A-0520002-S2` は転記ミス。

`ATECH` は台湾の **ATECH OEM INC.（亞元科技股份有限公司）** とみてよい。UL Solutions Product iQ の認証 `E227161` に電源アダプター系列 `T04A-0520XXX-XX` が登録されており、実機型番はこの系列に収まる。ATECHは台湾本社、中国の東莞・湖北宜昌に生産拠点を持つ。

別のSHARP純正ACアダプター `EP-D82F` では近縁型番 `T04A-05200D2-S3` の流通記録がある。ただし `EP-D82F` がDP-700SHの公式互換品であることや、S2/S3の差は未確認。

参考:
- https://used.sofmap.com/r/item/2133006495537
- https://paypayfleamarket.yahoo.co.jp/item/e1186028374
- https://www.ebay.ie/b/bn_616753
- https://item.rakuten.co.jp/ruitasu-r/1000063190/
- https://productiq.ulprospector.com/en/profile/2433476/qqgq.e227161
- https://www.atechoem.com/document-detail/0/1511/
- https://www.icaa.org.tw/data-64119
- 2026-08-21 ユーザー提供実機写真

**注意:** ATECHをDP-700SH本体のODM/EMSとする証拠はない。ここで特定できたのは電源アダプターの供給元。

### DP-700SH本体は中国製造個体を直接確認

ユーザー提供のDP-700SH背面写真で、銘板に **`MADE IN CHINA`** を直接確認した。別の中古出品でも同様の表示を確認済み。

参考:
- https://jp.mercari.com/item/m81292816659
- 2026-08-21 ユーザー提供実機写真

**確定:** DP-700SH本体そのものに中国製造個体が存在し、その銘板上の製造元はSharp。

**注意:** `MADE IN CHINA` は最終製造国の証拠であり、実際の中国側EMS/工場名までは示さない。

### 実機ファームウェアは `Ver.1.03.00`

2026-08-21のユーザー提供実機写真で、`各種設定／本体情報の表示` 画面に **`バージョン表示 1.03.00`** と表示されていることを直接確認した。

Wayback Machineで2010-05-05 17:10:35保存のFUJIFILM公式更新ページ `download001.html` を復元すると、公開更新版は以下と明記される。

- **DP-700SH: Ver.1.04.00**
- **DP-850SH / DP-1020SH: Ver.1.03.00**

したがって、手元DP-700SHの `1.03.00` は **2010-04-30公開の1.04.00更新を適用していない旧版** と確定できる。ただし、1.03.00が発売時の初期版なのか、発売後の非公開工場ビルドなのかまでは未確認。

Wayback保存版:
- https://web.archive.org/web/20100505171035id_/http://fujifilm.jp/support/digitalphotoframe/download/dp1020sh_dp850sh_dp700sh/download001.html

参考:
- 2026-08-21 ユーザー提供実機写真
- https://dc.watch.impress.co.jp/docs/news/365704.html

### 2010年公式ファームの実ファイル名・容量・直リンクを回収

Wayback Machineで2012-01-21 02:44:16保存のFUJIFILM公式 `download002.html` を復元し、使用許諾後の実ダウンロード情報を直接確認した。

- **DP-700SH:** `TH34_dpf.pkg` — **2.1MB**
  - `http://download.fujifilm.co.jp/pub/tools/dp700sh/TH34_dpf.pkg`
- **DP-850SH:** `TH35_dpf.pkg` — **2.2MB**
  - `http://download.fujifilm.co.jp/pub/tools/dp850sh/TH35_dpf.pkg`
- **DP-1020SH:** `TH36_dpf.pkg` — **2.2MB**
  - `http://download.fujifilm.co.jp/pub/tools/dp1020sh/TH36_dpf.pkg`

Wayback保存版:
- https://web.archive.org/web/20120121024416id_/http://fujifilm.jp/support/digitalphotoframe/download/dp1020sh_dp850sh_dp700sh/download002.html

更新手順PDFのファイル名も `download001.html` から確認できる。

- `/support/pdf/digitalphotoframe/manual/ff_dp1020sh_dp850sh_dp700sh_firmware_mn_j.pdf`
- ページ表示上の容量: 422KB

**確定:** 3機種は同じ不具合修正を同日に受ける一方、実更新ファイルは `TH34` / `TH35` / `TH36` と機種別に連番の `.pkg` が配布されていた。

**状況証拠:** これは3機種が完全に同一バイナリだったことではなく、共通のソフトウェア基盤から機種別パッケージを生成していた可能性を強く示す。ただしSoCや基板が同一である証拠ではない。

**未回収:** `TH34_dpf.pkg` / `TH35_dpf.pkg` / `TH36_dpf.pkg` のバイナリ本体。WaybackのCDXで各実URLを検索したが、現時点でファイル本体の保存は確認できない。

### 2010年共通更新の内容

2010-04-30、DP-1020SH / DP-850SH / DP-700SH向けに共通更新が公開された。修正対象はIrSimple / IrSS / IrDA通信がイレギュラー操作で中断した場合に、まれにシステムがハングする症状。

旧公式URL:
- http://fujifilm.jp/support/digitalphotoframe/download/dp1020sh_dp850sh_dp700sh/download001.html

記事:
- https://dc.watch.impress.co.jp/docs/news/365704.html

### miniUSB-Bは通常のPC接続用USB Device

取扱説明書から、PCと接続して内蔵メモリを読み書きするためのminiUSB-B端子であることを確認済み。サービス専用端子という証拠はない。

### 画像転送IRとリモコン受光は別系統 — リモコン受光部は前面

仕様上、IrSS / IrSimple受信用と専用リモコン用の受光部は別用途。スマホからIrSimpleを送るだけではリモコン代用にはならない。

Internet Archiveに保存されたDP-700SH使用説明書を確認すると、「各部の名称」で本体 **前面** に `リモコン受光部` が示され、「リモコンを使用するときは」でも **本体前面のリモコン受光部に向けて操作**するよう明記されている。同じ図では `明るさセンサー` と `赤外線通信ポート` が別部位として記載される。

参考:
- https://archive.org/details/japanese-manual-34460
- https://archive.org/stream/japanese-manual-34460/japanese-manual-34460_djvu.txt

**確定:** `RRMCG2009SCZZ` の受光部は画面側の前面。nubia Z80 Ultraで赤外線コードを総当たりする際は、前面受光部へ向けるのが正しい。

**既存推測の訂正:** 2010年の利用者レビューには、高速画像転送用の赤外線通信口が背面/側面へ移ったという観察に続いて「リモコン受光部も同様の位置らしい」とする推測があった。しかし後半は使用説明書と矛盾するため採用しない。画像転送用赤外線ポートとリモコン受光部を混同しない。

ユーザー提供写真でも、メニューに独立した `赤外線通信` 項目と `赤外線通信 待ち受け中` 画面を直接確認した。

### DP-700SH純正リモコン型番は `RRMCG2009SCZZ`

Yahoo!オークションのDP-700SH出品写真から、付属リモコン裏面ラベルを直接確認した。

- `REMOTE CONTROL UNIT`
- `RRMCG2009SCZZ`
- `使用電池 リチウム電池 CR2025 1個`
- `FUJIFILM Corporation`

参考:
- https://auctions.yahoo.co.jp/jp/auction/q1171811726

前面には電源、メニュー、方向/決定、戻る、スライドショー、インデックス、モード切替、便利メニュー、時計、絞り込み、縮小、拡大、回転などのキーがある。

## 確定度: 中～高 / 状況証拠

### DP-850SH / DP-1020SHの銘板上の製造元もSHARP

2026-09-02に確認したDP-850SH実機の背面銘板写真では、次の表示を読める。

- `デジタルフォトフレーム DP-850SH`
- `定格: 5V 8.5W`
- `販売元: 富士フイルム株式会社`
- **`製造元: シャープ株式会社`**
- `MADE IN CHINA`

参考:
- https://auctions.yahoo.co.jp/jp/auction/f1218793047
- https://jp.mercari.com/item/m88022822137

2026-09-09、Yahoo!オークション終了済み出品 `o1098196199` のDP-1020SH背面写真でも、銘板から次の表示を直接確認した。

- `デジタルフォトフレーム DP-1020SH`
- `販売元: 富士フイルム株式会社`
- **`製造元: シャープ株式会社`**
- `MADE IN CHINA`

参考:
- https://auctions.yahoo.co.jp/jp/auction/o1098196199
- https://auctions.c.yimg.jp/images.auctions.yahoo.co.jp/image/dr000/auc0407/users/af14fb92207a57ae3c4c9bf0a15c5cdcb8882880/i-img600x450-1688709486zeex8w1280860.jpg

**確定:** DP-700SH / DP-850SH / DP-1020SHの2010年3機種すべてで、完成品の銘板上の製造元がSharpである実機個体を直接確認できた。3機種とも中国製造個体の存在も確認できる。

**推測への影響:** 2010年3機種がSharpを製造元とする同一系列として設計・調達された可能性を強く補強する。ただし、同一SoC・同一メイン基板・同一OSを意味するものではなく、Sharp名義の製品を台湾ODMが設計/製造支援した可能性とも両立する。

### DP-850SH / DP-1020SHの開発案件は `Customer: Sharp`

台湾・新竹の技術者 Dusty Shyr（石璧維）の公開職歴に、2009-10〜2010-02の案件として以下が残る。

- `Digital Photo Frame - FUJIFILM DP-850SH/DP-1020SH`
- `Product: FUJIFILM DP-850SH/DP-1020SH`
- `Customer: Sharp`

参考:
- https://tw.linkedin.com/in/%E7%92%A7%E7%B6%AD-dusty-shyr-%E7%9F%B3-a6ab8a5b

DP-700SHの名前はこの記録にはない。ただし700SH/850SH/1020SHは同時期シリーズで共通更新を受け、3機種すべての実機銘板でSharpが製造元と確認できた。台湾側案件の `Customer: Sharp` と製品側のSharp関与は整合する。

### 同じ台湾側担当者の案件が連続

公開職歴上:

1. 2008-04〜10: Digital PhotoFrame - Electronic photo Album / Customer: Jablotron
2. 2009-03〜09: Story Book inColor / Customer: AIPTEK（Project / SW Manager）
3. 2009-10〜2010-02: FUJIFILM DP-850SH/DP-1020SH / Customer: Sharp

同一の台湾側ソフトウェア開発チームまたはODMが複数顧客向けにデジタル写真機器を開発していた可能性がある。

### Dusty Shyr氏の学術上の実名表記は `Bih-Wei Shyr`

国立陽明交通大学（旧・国立交通大学）の機関リポジトリに、1998年の修士論文 `影像序列中網型物件之建立與追蹤` の著者として **石璧維 / Bih-Wei Shyr** が記録されている。2000年のSPIE論文にも `Bih Wei Shyr` として掲載される。

### 2010年3機種は背面の明るさセンサー配置と誤消灯傾向を共有

2010年世代の共通設計を示す追加の実機観察が見つかった。

- DP-700SH利用者は、明るさセンサーが先代DP-70SHと異なり**背面**にあり、書棚や黒い壁の近くでは周囲を暗いと誤判定して自動消灯しやすいと報告している。
- DP-850SHを5台以上所有した同一レビュアーも、明るさセンサーが**背面**にあり、照明が点いていても自動消灯する挙動を全個体で確認。メーカー送付後も変わらなかったと記録している。
- 同レビュアーのDP-1020SHでも、明るさセンサーが**背面**で同種の自動消灯が起き、DP-850SHよりは軽いものの個体差ではないとしている。

参考:
- https://bbs.kakaku.com/bbs/K0000084345/ （2010-05-08「自動消灯機能について」）
- https://review.kakaku.com/review/K0000084346/ReviewCD=618875/
- https://review.kakaku.com/review/K0000084347/ReviewCD=618889/

**確定度: 中:** 3機種で背面センサー配置と似た省電力挙動が独立に観察されている。特にDP-850SHは複数個体で同じだったという比較記録がある。

**状況証拠:** これは2010年のDP-700SH / DP-850SH / DP-1020SHが、少なくとも明るさ検出・省電力制御とその筐体配置について同じ設計思想または共通部品/回路を共有した可能性を補強する。既知の共通機能、同日の共通ファーム修正、機種別連番 `.pkg` と整合する。

**断定禁止:** 背面センサーの共通性だけでは、同一SoC、同一メイン基板、同一OS、同一センサー型番までは証明できない。DP-70SHから2010年世代への変更点として、センサー位置が前世代と異なることも重要である。

### 後継DP-801SH用として `RRMCG2010SCZZ` が明記された流通記録

2026-09-08、Yahoo!オークションの過去出品記録で、FUJIFILM純正リモコン **`RRMCG2010SCZZ`** について商品名に `フォトフレーム DP-801SH用` と明記された個体を確認した。

参考:
- https://auctions.yahoo.co.jp/jp/auction/t1015891228

**確認できた事実:** 中古流通上、`RRMCG2010SCZZ` とDP-801SHを直接結びつける独立した記録が存在する。メーカー公式適合表ではないため確定度は「中」とする。

**既存根拠との接続:** 2010年世代ではDP-700SH純正 `RRMCG2009SCZZ` を型番直読で確認済み。2011年世代ではDP-701SH一式写真に同形リモコンが写ること、`RRMCG2010SCZZ` 単体実物が確認済みであり、今回DP-801SHという具体的な機種名との対応が追加された。

**推測:** `RRMCG2009SCZZ` → `RRMCG2010SCZZ` という連番と2010→2011年DPシリーズの世代交代が対応している可能性が高まった。`RRMCG2010SCZZ` の生波形を採取し、2009版とプロトコル・アドレス・各キーコードを比較する価値が高い。

**断定禁止:** 2009版と2010版の赤外線コードが同一であること、Sharp 13-bitなど特定のプロトコルを採用すること、DP-701SHにも正式に同型番が付属したことまでは今回の記録だけでは確定しない。

### AIPTEKのデジタルフォトフレーム特許がSanJetへ移転

中国実用新案 **CN201153780Y**（「可替换多种框体的数位相框组」）の公開記録を確認した。これはデジタルフォトフレームそのものを対象とする発明で、発明者は **涂茜雯 / Qian-Wen Tu**。

- 中国出願日: 2008-02-01
- 公開/登録: 2008-11-26
- 元の権利者: AIPTEK International / 天瀚科技
- 移転後の権利者: Sanjet Optoelectronics Co., Ltd.（勝捷光電）
- 権利移転の登録実効日: **2010-09-19**
- 中国側の移転公示: 2010-11-03

法的イベント欄には `Patentee before: Tianhan Science & Technology Co., Ltd.`、`Patentee after: Sanjet Optoelectronics Co., Ltd.` と明記されている。台湾対応出願 **TWM341472U** は2008-01-30出願、発明者 `qian-wen Tu`、Original Assignee `Aiptek Int Inc` と確認できる。

参考:
- https://patents.google.com/patent/CN201153780Y/zh
- https://patents.google.com/patent/TWM341472U/en

**確定:** AIPTEK/天瀚が2008年に保有していたデジタルフォトフレーム固有の知財が、2010年にSanJetへ実際に承継された例が存在する。以前確認した一般特許の権利移転より、DPF技術組織の連続性を直接補強する証拠である。

**状況証拠:** 2009年の代工部門分割、SanJet公式サイト上のDPF OEM/ODM表記、AIPTEK案件→Sharp向けFUJIFILM DPF案件と続く台湾側担当者の職歴と合わせると、AIPTEK時代のDPF設計資産・人員・知財の少なくとも一部がSanJet側へ移ったという見方がかなり強くなる。

**断定禁止:** この特許は交換可能な外枠構造を扱うもので、DP-700SH / DP-850SH / DP-1020SHそのものの基板・SoC・OS・ファームウェアを対象とした特許ではない。したがって、この記録だけからSanJetがDPシリーズのODMだった、あるいはAIPTEKの電子回路/ソフトウェア資産がそのままDPシリーズへ流用されたとは断定しない。

### DP-850SHの付属ACアダプターはSHARP `EP-D82F` / ATECH `T04A-05200D2-S3`

2026-09-08、Yahoo!オークションの終了済み `FUJI FILM デジタルフォトフレーム DP-850SH W` 出品 `l1132457656` の掲載写真で、付属ACアダプター銘板を正面から確認した。

写真から読める表示:
- `AC アダプター EP-D82F`
- `SHARP`
- 出力 `DC 5V 2A`
- `MODEL: T04A-05200D2-S3`
- `MADE IN CHINA`
- `ATECH`
- 個体/管理番号 `1022-04356`

参考:
- https://auctions.yahoo.co.jp/jp/auction/l1132457656
- https://item.rakuten.co.jp/ruitasu-r/1000063190/

**確定度: 中〜高:** DP-850SH一式として出品された個体の写真に `EP-D82F` が含まれ、銘板が判読可能。単体流通記録でも `EP-D82F / T04A-05200D2-S3` の組み合わせを独立に確認できる。

**DP-700SHとの比較:** DP-700SH手元実機では `EP-D72F` / ATECH `T04A-05200D2-S2` を直接確認済み。したがって2010年同系列で、DP-700SHとDP-850SHが同じATECHの `T04A-05200D2` 系を使い、末尾 `S2` / `S3` の近縁仕様として調達されていたことになる。

**状況証拠:** これはメイン基板やSoCの共通性を証明しないが、SHARP名義の完成品系列で電源部材まで近縁型番が採用されたことを示し、同一製品群としての部材調達・電源設計の共通性を補強する。

**未確定:** `EP-D82F` がDP-1020SHにも標準付属したか、S2/S3の差がプラグ・ケーブル・EMI対策・認証のどれに対応するかは未確認。

### 2011年後継DP-701SH / DP-801SHではファームウェア自体を共通化

2011-07-29、富士フイルムはDP-701SH / DP-801SH向けVer.1.04.07を公開した。当時のデジカメ Watch記事は **「ファームウェアは両機種で共通」** と明記している。

参考:
- https://dc.watch.impress.co.jp/docs/news/464018.html
- 旧公式ページ: http://fujifilm.jp/support/digitalphotoframe/download/dp701sh_dp801sh/download001.html

**確定:** 2011年世代の7型/8型2機種では、メーカー側が同一ファームウェアを明示的に共用していた。

**2010年世代との比較:** DP-700SH / DP-850SH / DP-1020SHは同日に同じ赤外線通信不具合を修正したが、更新ファイルは `TH34_dpf.pkg` / `TH35_dpf.pkg` / `TH36_dpf.pkg` と機種別だった。したがって、2010年世代について「同じ修正内容だったから完全に同一バイナリ」とみなすべきではないことを、後継世代との対照がさらに補強する。

**推測:** 2010年の機種別パッケージ分離は、機種別ビルド、パネル初期化、内蔵メモリ容量、動画/音声機能、機種識別など何らかの差分を反映していた可能性が高い。ただし、実バイナリ未回収のため差分の中身は不明。

**断定禁止:** この比較から2010年3機種のSoCやOSが異なるとは言えない。また、2011年世代が2010年世代と同じSoC/OSを継承した証拠もまだない。