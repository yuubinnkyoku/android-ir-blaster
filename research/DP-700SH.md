# FUJIFILM DP-700SH リバースエンジニアリング調査メモ

最終更新: 2026-08-21 JST

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

中古販売記録で、DP-700SHの付属品としてACアダプター型番 `EP-D72F` が明記されている。別の中古流通記録では同型番が **SHARP ACアダプター** として扱われ、仕様は5V 2A（10W）、プラグ外径約4.0mm/内径約1.7mm、センタープラスとされる。

2026-08-21のユーザー提供実機写真ではラベルを直接確認でき、以下を読める。

- `ACアダプター EP-D72F`
- `SHARP`
- 入力: `AC 100V-240V 900mA 50/60Hz`
- 出力: `DC 5V 2A`
- `MODEL: T04A-05200D2-S2`
- `1014-03814`
- `MADE IN CHINA`
- `ATECH`

**型番転記の訂正:** 実機写真を拡大して再確認すると、従来 `T04A-0520002-S2` と読んでいた箇所は **`T04A-05200D2-S2`**（`D`）と読める。以前の `...0002...` は転記ミスとして訂正する。Web上でもSHARP 5V 2A ACアダプターとして同じ `T04A-05200D2-S2` の流通記録が確認できる。またSHARP `EP-D82F` には近縁型番 `T04A-05200D2-S3` の流通記録がある。ただし、`EP-D82F` がDP-700SHの標準付属品または公式互換品であることを示すものではない。

この `ATECH` は **台湾の ATECH OEM INC.（亞元科技股份有限公司）** とみてよい。UL Solutions の認証データで、ATECH OEM INC. が保有する電源アダプター認証 `E227161` のモデル群に **`T04A-0520XXX-XX`** が含まれており、実機ラベルの `T04A-05200D2-S2` はこの系列に収まる。

ATECH OEM INC. は台湾・台北に本社を置く電源/磁性部品メーカーで、中国の東莞（華南）および湖北宜昌（華中）に生産拠点を持つと会社紹介にある。実機アダプターの `MADE IN CHINA` と整合する。ただし、どちらの中国工場で `EP-D72F` が製造されたかは未確認であり、ATECHがDP-700SH本体のODM/EMSだったことを示す証拠でもない。

参考:
- https://used.sofmap.com/r/item/2133006495537
- https://paypayfleamarket.yahoo.co.jp/item/e1186028374
- https://www.ebay.ie/b/bn_616753
- https://item.rakuten.co.jp/ruitasu-r/1000063190/
- https://productiq.ulprospector.com/en/profile/2433476/qqgq.e227161
- https://www.atechoem.com/document-detail/0/1511/
- https://www.icaa.org.tw/data-64119
- 2026-08-21 ユーザー提供実機写真

### DP-700SH本体は中国製造個体を直接確認

ユーザー提供のDP-700SH背面写真で、本体下部の銘板を直接確認した。銘板には `デジタルフォトフレーム DP-700SH W`、`定格: 5V 8W`、`製造元: シャープ株式会社` とともに **`MADE IN CHINA`** の表記が写っている。

別の中古出品でも同様の中国製造表示を確認済み。

参考:
- https://jp.mercari.com/item/m81292816659
- 2026-08-21 ユーザー提供実機写真

**確定:** DP-700SH本体そのものに中国製造個体が存在し、その銘板上の製造元はSharp。

**注意:** `MADE IN CHINA` は最終製造国の証拠であり、実際の中国側EMS/工場名までは示さない。

### 実機ファームウェアは `Ver.1.03.00`

2026-08-21のユーザー提供実機写真で、`各種設定／本体情報の表示` 画面に **`バージョン表示 1.03.00`** と表示されていることを直接確認した。

これにより、DP-700SHの実在ファームバージョンとして `1.03.00` を確定できる。

ただし、この個体が2010-04-30の公開更新を適用済みかどうかは不明。そのため **1.03.00が発売時版なのか、公開更新版なのかはまだ断定しない**。Web検索では現時点でDP-700SHと`1.03.00`を直接結ぶ公開記録は見つかっていない。

参考:
- 2026-08-21 ユーザー提供実機写真

### 2010年に3機種共通のファームウェア更新が存在

2010-04-30、DP-1020SH / DP-850SH / DP-700SH向けに共通更新が公開された。修正対象はIrSimple / IrSS / IrDA通信がイレギュラー操作で中断した場合に、まれにシステムがハングする症状。

旧公式URL:
- http://fujifilm.jp/support/digitalphotoframe/download/dp1020sh_dp850sh_dp700sh/download001.html

記事:
- https://dc.watch.impress.co.jp/docs/news/365704.html

更新ファイル本体、実ファイル名、公開更新後のバージョン番号は未回収。実機で `1.03.00` は確認済み。

### miniUSB-Bは通常のPC接続用USB Device

取扱説明書から、PCと接続して内蔵メモリを読み書きするためのminiUSB-B端子であることを確認済み。サービス専用端子という証拠はない。

### 画像転送IRとリモコン受光は別系統

仕様上、IrSS / IrSimple受信用と専用リモコン用の受光部は別用途。スマホからIrSimpleを送るだけではリモコン代用にはならない。

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

### DP-850SH / DP-1020SHの開発案件は `Customer: Sharp`

台湾・新竹の技術者 Dusty Shyr（石璧維）の公開職歴に、2009-10〜2010-02の案件として以下が残る。

- `Digital Photo Frame - FUJIFILM DP-850SH/DP-1020SH`
- `Product: FUJIFILM DP-850SH/DP-1020SH`
- `Customer: Sharp`

参考:
- https://tw.linkedin.com/in/%E7%92%A7%E7%B6%AD-dusty-shyr-%E7%9F%B3-a6ab8a5b

DP-700SHの名前はこの記録にはない。ただし700SH/850SH/1020SHは同時期シリーズで共通ファーム更新を受け、DP-700SH本体銘板ではSharpが製造元と確認できた。したがって台湾側案件の `Customer: Sharp` と製品側のSharp関与がより直接につながる。

### 同じ台湾側担当者の案件が連続

公開職歴上:

1. 2008-04〜10: Digital PhotoFrame - Electronic photo Album / Customer: Jablotron
2. 2009-03〜09: Story Book inColor / Customer: AIPTEK（Project / SW Manager）
3. 2009-10〜2010-02: FUJIFILM DP-850SH/DP-1020SH / Customer: Sharp

同一の台湾側ソフトウェア開発チームまたはODMが複数顧客向けにデジタル写真機器を開発していた可能性がある。ただし当時の所属会社名はまだ特定できていない。

### Dusty Shyr氏の学術上の実名表記は `Bih-Wei Shyr`

国立陽明交通大学（旧・国立交通大学）の機関リポジトリに、1998年の修士論文 `影像序列中網型物件之建立與追蹤` の著者として **石璧維 / Bih-Wei Shyr** が記録されている。2000年のSPIE論文にも `Bih Wei Shyr` として掲載される。

参考:
- https://ir.lib.nycu.edu.tw/handle/11536/64322
- https://scholar.nycu.edu.tw/en/publications/generation-and-tracking-of-mesh-objects-in-image-sequences/
- https://tw.linkedin.com/in/%E7%92%A7%E7%B6%AD-dusty-shyr-%E7%9F%B3-a6ab8a5b

LinkedInの現在所属欄に出る `新帝` は **SanDisk（新帝科技）** であり、2008〜2010年当時の受託会社名としては扱わない。

### AIPTEK資料との食い違いは「外部受託チーム」仮説を強める

2009年のStory Book inColorについて台湾側公開資料は **天瀚科技（AIPTEK）が研発・製造** とする一方、Dusty氏の履歴では同案件を `Customer: AIPTEK` と記録している。

参考:
- https://9lib.co/document/rz32k9eq-Aiptek%E5%BD%A9%E8%89%B2%E5%85%92%E7%AB%A5%E9%9B%BB%E5%AD%90%E6%9B%B8%E9%80%B2%E8%BB%8D%E6%96%B0%E5%8A%A0%E5%9D%A1%E5%B8%82%E5%A0%B4.html
- https://www.ithome.com.tw/news/58275

**推測:** AIPTEKが製品全体の開発・製造主体でありつつ、一部ソフトウェア/システム開発をDusty氏の所属会社へ委託していた可能性がある。

### JABLOTRON TAIWANは当時「アジア向け営業・マーケティング」拠点

Jablotron Groupの当時のCompany Profileでは:

- `JABLOTRON TAIWAN – sales and marketing for Asia region`
- `JABLOTRON CHINA – production QC and component supplying`

と記載される。

参考:
- https://www.sklep-jablotron.pl/userfiles/files/company_profile.pdf

**推測への影響:** Dusty氏がJABLOTRON TAIWANの社内開発者だったという読みは弱く、Jablotron/ALBUMteamから別の台湾系設計会社へ開発が発注されていた可能性を補強する。

### `RRMCG2009SCZZ` はDP-850SH / DP-1020SHでも使われた可能性が高い

中古流通で同型番が `DP-850SH` / `DP-1020SH` 対応として明記されている。公式互換表ではないため確定扱いにはしないが、3機種のUI/リモコン入力層が共通だった可能性を補強する。

参考:
- https://jp.mercari.com/item/m93734607492
- https://jp.mercari.com/item/m53512993273

### `RRMCG` はSHARP系リモコン部品番号として広く使われる

SHARPの旧製品資料には `RRMCG1392CESA`, `RRMCG1327CESA`, `RRMCG0033TASA` など多数の例がある。

参考:
- https://sharp.manymanuals.com/data-projectors/xg-e3500u/instruction-manual-16837/37
- https://manualzilla.com/doc/7351006/sharp-pg-d100u/instruction-manual
- https://manualzz.com/doc/736350/sharp-s50a2vl-fd1u-camcorder-service-manual

これはSharpがリモコン設計/調達に関与した状況証拠にはなるが、`RRMCG2009SCZZ` の製造者や赤外線方式を確定するものではない。

### 先代DP-70SHには隠しファーム更新画面がある

DP-70SH Ver.1.04.00では、SDカードへファームを保存し、「本体情報→バージョン表示」中にリモコンで

`拡大 → 縮小 → 時計 → 回転`

と押すとファームウェア書き換え画面に入る。

参考:
- https://dc.watch.impress.co.jp/cda/accessories/2009/04/01/10602.html

DP-700SH純正リモコンにも4キーがすべて存在するため、同じシーケンスを試すことはできる。ただし実装継承は未確認。

デジカメ Watchの2009年バックナンバーには **2009-09-18にもDP-70SHの最新ファームウェア記事** がある。DP-70SHの公開更新は少なくとも2回存在した。

参考:
- https://dc.watch.impress.co.jp/docs/news/20090918_316738.html

### 後継DP-701SH / DP-801SHにも共通更新

2011-07-29に共通ファームVer.1.04.07が公開された。一方、2011年12月購入のDP-801SHでVer.1.05.01が出荷状態だったという実機報告があり、Web未公開の工場/修理向けビルドが存在した可能性がある。

参考:
- https://dc.watch.impress.co.jp/docs/news/464018.html

### 2009年からSharpが製品訴求の前面に出ていた

DP-70SH販売ページには「写真の富士フイルム」と「液晶のシャープ」が考えた製品という趣旨の訴求があり、ITmediaも当時「富士フイルム×シャープ」と表現した。

参考:
- https://www.kitamura.jp/shopping/ichioshi/2009/fujifilm_dp-70sh.html
- https://www.itmedia.co.jp/news/article/0902/04/1090204098/

これは正式な共同開発発表ではないため、状況証拠として扱う。

### 後継2011世代ではSharpとの共同開発が明記

2011年2月のDP-701SH / DP-801SH発表記事では、**「シャープと共同開発した24ビット表示が可能な『クリスタルフォト液晶』」** と明記される。

参考:
- https://dc.watch.impress.co.jp/docs/news/425705.html
- https://www.fujifilm.co.jp/press/ffnr0485.html

ただし2011世代はTN液晶、512MB、SD/MS、miniUSB-B、赤外線2系統、ACアダプター `EP-D701` で、2010世代のDP-700SH（ASV液晶、1GB、より多種類のカード、`EP-D72F`）から構成がかなり変わる。SoC/基板の直接比較は慎重に行う。

## 赤外線リモコン調査

### Sharp 13-bit方式についての確定事項と注意

Linux kernelの `RC_PROTO_SHARP` は5-bit address + 8-bit commandのメッセージと、約40ms後の反転側メッセージを組にする方式。SB-Projectsも38kHz、LSB-first、同じaddressを維持しつつcommand等を反転した第2メッセージを説明する。

参考:
- https://www.kernel.org/doc/html/next/userspace-api/media/rc/rc-protos.html
- https://www.sbprojects.net/knowledge/ir/sharp.php

`lib/ir/protocols/sharp.dart` はこの2メッセージ構造をすでに実装している。したがって「第2メッセージを送っていないため反応しない」という仮説は除外できる。

ただし、`RRMCG...` がSHARP系部品番号であることは `RRMCG2009SCZZ` が `RC_PROTO_SHARP` を使う証拠ではない。

### 探索候補

1. Sharp 13-bit（8,192固有候補）
2. 内蔵IR DBのSHARP候補
3. Kaseikyo / SHARP vendor `5AAA`
4. 近縁SHARP写真機器の既知コード
5. その他の家電IRプロトコル

`Lucaslhm/Flipper-IRDB` の `Picture_Frames` ではFUJIFILM/SHARPフォトフレームの登録を未確認。GitHubコード検索でも `DP-700SH` / `RRMCG2009SCZZ` の既知IR信号は未発見。

## 比較対象

### Jablotron / ALBUMteam `ALBUM`

同じ台湾側担当者が2008年に関わった案件。Jablotron公式にはALBUM firmware 1.15が残る。

- 現行配布: `albumq42008_en.zip` 約4.2MB
- 旧Jablotronサイト複製では同じfirmware 1.15を `FWI (4 MB)` と表示

したがって旧更新実体は `.fwi` 系だった可能性が高い。ただしDP-700SHが `.fwi` を使う証拠ではない。

参考:
- https://www.jablotron.com/en/support/downloads/alarms/software
- https://jablotron.com.cov04.vas-server.cz/en/about-jablotron/downloads/?level1=2598

ALBUMteamは台湾ODMではなく、Jablotronグループ系のチェコ企業。ALBUM/ALBUM2は米国・チェコで設計、台湾・中国で生産されたと報じられる。

参考:
- https://www.prnewswire.com/news-releases/albumteam-named-as-ces-innovations-2010-design--engineering-award-honoree-80907592.html
- https://ov.gov.cz/zapis/9717145

### Prosoyo Technology

2009年前後のJablotronは中国EMS企業Prosoyoと深く提携していたという当時報道がある。Prosoyoは製品設計からPCB実装、完成品組立までを掲げる。

ただし **ALBUMをProsoyoが製造した証拠、DP-700SHとの直接関係は未確認**。

参考:
- https://www.finance.cz/clanky/217833-jablotron-navzdory-krizi-zvysil-trzby-o-petinu-na-1-2-miliardy-kc/
- https://www.euro.cz/clanky/jak-vydelavat-v-cine-894445/
- https://www.prosoyoems.com/

### AIPTEK Story Book inColor

同担当者の2009年案件。8型800×600、USB host/slave、SD系、JPEG/MP3等を持つ。機能構成は近いが、SoC/OS/基板情報は未回収。

### FUJIFILM `DP-7V`

2010-07-30に公開ファーム **Ver.1.2.30** が提供された。価格.comの実機報告では同時購入の2台に **Ver.1.2.2.0** と **Ver.1.2.2.5** が混在しており、Web未公開の出荷時改版が存在したことを示す。

参考:
- https://dc.watch.impress.co.jp/docs/news/385194.html
- https://bbs.kakaku.com/bbs/K0000060109/

同時期FUJIFILM DPFのファーム命名・更新形式を横から追う比較対象。ただし同一SoC/基板の証拠ではない。

### SHARP HN-PP100 / HN-PP150

同時期のSHARP AQUOSフォトプレーヤーはeSOL `eCROS`を採用し、OSはμITRON 4.0準拠 `PrKERNELv4`。

参考:
- https://www.esol.co.jp/archive/news/emb_press090512.html

これはDP-700SHのOS証拠ではない。

## 現時点の共通基盤仮説

**確定:** DP-700SH / DP-850SH / DP-1020SHは同じ2010-04-30ファーム更新を受け、IrSimple/IrSS/IrDA通信スタックの同じ不具合を修正した。

**確定:** DP-700SHの銘板上の製造元はSharp。DP-850SH/1020SHについても台湾側開発案件の顧客がSharpと記録されている。

**状況証拠:** `RRMCG2009SCZZ` はDP-700SHで直接確認され、DP-850SH/1020SH向けとしても流通する。3機種は画像管理、赤外線、USB、メディア処理など共通機能が多い。

**推測:** 少なくともアプリケーション/ミドルウェアのかなりの部分を共有していた可能性が高い。ただしSoC、メイン基板、RAM/Flashが同一であることは未証明。

DP-700SHはSharpを製造元として中国製造されている。台湾側でSharp向けの設計/ソフト開発、中国で量産という構図は従来より整合的になったが、台湾側開発会社と中国側EMSの社名は未特定。なお、付属ACアダプター `EP-D72F` の電源OEMは台湾 ATECH OEM INC. と確認できたが、本体製造系統とは分けて扱う。

## 未解決事項

- DP-700SHのSoC型番
- RAM / Flash型番
- メイン基板型番 / 基板写真
- OS / RTOS
- 2010年公式更新ファイル本体・実ファイル名・公開更新後バージョン
- 実機 `Ver.1.03.00` が発売時版か公開更新版か
- 更新形式、署名/暗号化の有無
- `RRMCG2009SCZZ` の搬送波周波数 / プロトコル / 全キーコード
- DP-70SHの隠し更新シーケンスがDP-700SHにも残るか
- DP-700SH/850SH/1020SHの基板/ソフト共通範囲
- 2008〜2010年案件を担当した台湾側開発会社/ODM
- 中国側の実製造会社/EMS
- `EP-D72F` がATECHの東莞/宜昌のどの生産拠点で作られたか
- `EP-D72F (T04A-05200D2-S2)` と `EP-D82F (T04A-05200D2-S3)` の公式な差分・互換性

## 次に掘るもの

- 旧FUJIFILMページのWayback/CDXから更新ファイルhref回収
- DP-70SH / DP-701SH / DP-801SH / DP-7Vの旧公開ファイル名を回収し命名規則を推定
- `1.03.00` と2010-04-30公開更新の前後関係を別個体/旧資料で確認
- DP-700SH/850SH/1020SHの分解・修理・基板写真
- `RRMCG2009SCZZ` の実波形/コード
- ALBUM/Story Bookの内部写真・基板・SoC
- Dusty Shyr / Bih-Wei Shyrの2008〜2010年勤務先逆引き
- Sharp製造案件として台湾受託先・中国EMSを逆引き
- ATECHの旧認証/製造記録から `EP-D72F` の中国側生産拠点を絞る
- 実機からUSB VID/PIDを取得
- 実機で「本体情報→バージョン表示→拡大→縮小→時計→回転」の反応を確認
- ファーム実体を回収できた場合は `SPMF28XX`, `ThreadX`, `MIPS32_4Kx`, `SPIF RSV`, `2800 sysAppInit` などSunplus SPMF28xx系の文字列も検索する

## 記録方針

推測を確定情報として扱わない。特に次を混同しない:

- SharpがDP-700SH銘板上の製造元であること
- SHARP製液晶 / Sharp顧客案件
- SHARP製ACアダプター
- ATECH OEM INC. が `EP-D72F` の電源OEMであること
- `RRMCG` 系リモコン部品番号
- `RC_PROTO_SHARP` などの赤外線プロトコル
- `MADE IN CHINA` という最終製造国表示
- 台湾側開発会社 / 中国側EMS / Sharpの役割
- 本体全体のOEM/SoC/OS

## 台湾側開発会社候補: Sanjet Technology（勝捷光電）

AIPTEK自身の年報を遡ると、2009年6月に **AIPTEK（天瀚科技）が代工/OEM事業を既存会社の勝捷光電股份有限公司（Sanjet Technology Corp.）へ分割譲渡した** と明記されている。同じ年報では、その直後の2009年11月に `Story Book inColor` を発表したことも連続して記録される。

参考:
- https://www.aiptek.com.tw/uploads/information_year/en/111%E5%B9%B4%E5%A0%B1.pdf
- https://www.moneydj.com/kmdj/news/newsviewer.aspx?a=667e5451-a279-49d9-a14e-0e437620cbb9

**確定:** 勝捷光電は2008-11-20設立の新竹企業で、英名は `SANJET TECHNOLOGY CORP.`。2009-06-25時点の登記住所は `新竹市工業東四路19號6樓`。AIPTEKは2003年から同じ `工業東四路19號` を本拠としており、分割時期のSanjetがAIPTEK拠点内にいたことと整合する。

参考:
- https://findbiz.nat.gov.tw/fts/company/24268077
- https://www.findcompany.com.tw/en/SANJET%20TECHNOLOGY%20CORP.
- 上記AIPTEK年報

さらにSanjetが2009-06-26に出願した商標 `勝捷` の指定商品には、**`數位相片播放器` と `數位相框`（デジタルフォトフレーム）** が明記される。AIPTEKが2008-02-01に出願した「交換可能な複数フレームを備えたデジタルフォトフレーム」中国実用新案も、現在の権利者表示がSanjetになっており、少なくともAIPTEKのデジタルフォトフレーム関連事業/IPがSanjet側へ移った痕跡がある。

参考:
- https://www.findcompany.com.tw/trademark/01391873_098027401
- https://patents.google.com/patent/CN201153780Y/zh

**有力な推測:** Dusty Shyr氏の `Story Book inColor / Customer: AIPTEK` 案件は2009-03〜09で、AIPTEK→SanjetのOEM事業分割（2009-06）をまたぐ。次の `FUJIFILM DP-850SH/DP-1020SH / Customer: Sharp` 案件は2009-10開始。もしDusty氏がAIPTEKのOEM部門からSanjetへ移ったチームに所属していたなら、分割後にAIPTEKを「Customer」と表記し、その直後にSharpを顧客としてDPシリーズを担当した時系列が非常に自然になる。

ただし **Dusty/Bih-Wei Shyr氏がSanjetに在籍した直接資料、SanjetがDP-850SH/DP-1020SHを受託した契約・製品資料はまだ見つかっていない**。したがってSanjetは現時点で「台湾側開発会社の最有力候補の一つ」であり、確定扱いにはしない。

### SanjetとSunplusの資本接点、およびSoC探索への影響

Sunplus Technology（凌陽科技）の2009年年報にある有価証券保有表を確認すると、**Sunplus Venture Capital Co., Ltd. が2009-12-31時点で Sanjet Technology Corp. 株式を369千株、持株比率約1%保有**していた。同じ表にはAIPTEK International Inc.も投資先として掲載される。

参考:
- https://www.sunplus.com/ir/annual/2009_ar_en.pdf

また文曄科技の2009年年報には、AIPTEKが2009年6月の会社分割で一部事業をSanjetへ移し、AIPTEK株主が対価としてSanjet株式を受け取ったことが会計処理まで含めて記載される。AIPTEK→Sanjetの事業移管を別会社の財務資料からも確認できる。

参考:
- https://www.wtmec.com/wp-content/uploads/2015/05/%E6%96%87%E6%9B%84_2009%E5%B9%B4%E5%B9%B4%E5%A0%B1.pdf

**確定:** 2009年末までにSanjetとSunplus系投資会社の資本接点が存在した。

**注意:** Sunplus Venture CapitalがSanjet株を約1%保有したことは、Sanjet製品がSunplus製SoCを採用した証拠ではない。ベンチャー投資先というだけでも成立するため、SoC採用へ直接結び付けない。

同時期の比較材料として、Sunplusのデジタルフォトフレーム向けSoC `SPMF2800/SPMF2800A` を搭載した2009年前後の市販フォトフレームの解析例がある。公開された起動ログでは `SPMF28XX Boot Loader`、MIPS32 4K系、ThreadX、SPI Flash、SD/MS、USB、リモコン用ドライバ、115200bps UART、SD/USBを使う更新機構などが確認されている。これはDP-700SHとは別製品の解析結果。

参考:
- https://qiita.com/yamori813/items/2919b6344e7e27704726
- https://www.mikrocontroller.net/topic/218149
- https://www.wpgholdings.com/productline/detail/zhtw/Generalplus

**探索上の推測:** SanjetがSunplus系資本と接点を持ち、Sunplus/Generalplusが同時期にフォトフレーム向けSoCを供給していたことから、Sunplus/Generalplus系はDP-700SH/850SH/1020SHのSoC候補として優先して照合する価値が上がった。ただし現時点では **DP-700SHのSoCがSPMF2800系、OSがThreadX、CPUがMIPSであることを示す直接証拠は一切ない**。

今後は2009〜2010年のSanjet社員・求人・特許発明者・旧製品カタログ・Sharp/FUJIFILMとの取引記録を優先して追う。