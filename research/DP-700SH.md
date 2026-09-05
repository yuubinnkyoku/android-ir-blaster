# FUJIFILM DP-700SH リバースエンジニアリング調査メモ

最終更新: 2026-09-05 JST

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

### DP-850SHの銘板上の製造元もSHARP

2026-09-02に確認したDP-850SH実機の背面銘板写真では、次の表示を読める。

- `デジタルフォトフレーム DP-850SH`
- `定格: 5V 8.5W`
- `販売元: 富士フイルム株式会社`
- **`製造元: シャープ株式会社`**
- `MADE IN CHINA`

参考:
- https://auctions.yahoo.co.jp/jp/auction/f1218793047
- https://jp.mercari.com/item/m88022822137

**確定:** DP-700SHだけでなくDP-850SHも、完成品の銘板上の製造元はSharp。台湾側の公開職歴にある `Customer: Sharp` とは独立した、製品側からの証拠になる。

**推測への影響:** DP-700SH / DP-850SHがSharpを製造元とする同一系列だった可能性を強く補強する。ただし、同一SoC・同一メイン基板・同一OSを意味するものではなく、Sharp名義の製品を台湾ODMが設計/製造支援した可能性とも両立する。

**未確定:** DP-1020SHについても背面銘板写真は見つかっているが、今回確認できた画像では製造元欄を確実に判読できないため、Sharp製造元とはまだ確定扱いにしない。

### DP-850SH / DP-1020SHの開発案件は `Customer: Sharp`

台湾・新竹の技術者 Dusty Shyr（石璧維）の公開職歴に、2009-10〜2010-02の案件として以下が残る。

- `Digital Photo Frame - FUJIFILM DP-850SH/DP-1020SH`
- `Product: FUJIFILM DP-850SH/DP-1020SH`
- `Customer: Sharp`

参考:
- https://tw.linkedin.com/in/%E7%92%A7%E7%B6%AD-dusty-shyr-%E7%9F%B3-a6ab8a5b

DP-700SHの名前はこの記録にはない。ただし700SH/850SH/1020SHは同時期シリーズで共通更新を受け、DP-700SH本体銘板ではSharpが製造元と確認できた。台湾側案件の `Customer: Sharp` と製品側のSharp関与は整合する。

### 同じ台湾側担当者の案件が連続

公開職歴上:

1. 2008-04〜10: Digital PhotoFrame - Electronic photo Album / Customer: Jablotron
2. 2009-03〜09: Story Book inColor / Customer: AIPTEK（Project / SW Manager）
3. 2009-10〜2010-02: FUJIFILM DP-850SH/DP-1020SH / Customer: Sharp

同一の台湾側ソフトウェア開発チームまたはODMが複数顧客向けにデジタル写真機器を開発していた可能性がある。

### Dusty Shyr氏の学術上の実名表記は `Bih-Wei Shyr`

国立陽明交通大学（旧・国立交通大学）の機関リポジトリに、1998年の修士論文 `影像序列中網型物件之建立與追蹤` の著者として **石璧維 / Bih-Wei Shyr** が記録されている。2000年のSPIE論文にも `Bih Wei Shyr` として掲載される。

### 2009年12月のSanJet公式サイトがDPFをOEM/ODM製品群として明記

Wayback Machineに保存された **2009-12-15 03:37:34** のSanJet Technology Corp.公式サイトを確認した。この時点でトップページは、SanJetがOEM/ODMサービスを提供し、製品群に **Digital Photo Frame** を含めると明記している。

保存本文の要旨:
- `We provide top-notch and streamlined OEM/ODM services.`
- 製品群: `Digital Camcorder, Digital Still Camera, Projector, Digital Photo Frame, and Digital Tablet`
- 所在地: `4F, No.19, Industry E. Rd 4, Hsinchu Science Park, Hsin-Chu 300, Taiwan, R.O.C.`

Wayback保存版:
- https://web.archive.org/web/20091215033734id_/http://www.sanjetco.com/

さらに2010-03-02保存の `Product.htm` も確認でき、当時のサイトに独立した製品ページが存在した。ただし商品一覧の主要情報は画像化されており、HTML本文からFUJIFILM/Sharpの機種名までは確認できない。

- https://web.archive.org/web/20100302133601id_/http://www.sanjetco.com/Product.htm

**確定:** 少なくとも2009年12月時点でSanJet自身が、Digital Photo Frameを含む製品群についてOEM/ODMサービスを提供する会社だと公式サイトで公称していた。これは後年の会社紹介や商標指定商品よりも、FUJIFILM DP-850SH/DP-1020SH案件期間に直接重なる一次資料。

**状況証拠:** Dusty Shyr氏の `FUJIFILM DP-850SH/DP-1020SH / Customer: Sharp`（2009-10〜2010-02）がSanJetの受託開発案件だったという仮説を強く補強する。またSanJetの当時所在地は `工業東四路19號` で、Generalplusの所在地と一致するため、同社との技術・供給接点を探す優先度は高い。

**未確定:** この公式サイトはFUJIFILM/Sharpを顧客名として挙げておらず、DP-700SH / DP-850SH / DP-1020SHをSanJetが設計・製造したこと、Generalplus製SoCを採用したことを直接証明するものではない。

### DP-1020SHは発売直前に電源接続部の不具合で全数検査

AV Watchの2010-03-10記事によると、DP-1020SHは当初2010-03-13発売予定だったが、**一部機体の電源接続部に不具合が見つかり、全数検査のため2010-03-20へ発売延期**となった。一方、DP-850SHは予定通り2010-03-13に発売された。

参考:
- https://av.watch.impress.co.jp/docs/news/353844.html

**確定:** DP-1020SHだけに発売前の電源接続部不具合と全数検査が発生し、DP-850SHは同じ延期対象ではなかった。

**状況証拠:** DP-850SH / DP-1020SHは同じ台湾側案件名で扱われ、共通ファーム更新も受ける一方、少なくとも電源接続部・その実装・筐体側接続構造のいずれかには機種固有差があった可能性が高い。したがって「共通ソフトウェア基盤」と「完全同一メイン基板」は分けて考えるべき。

**未確定:** 不具合箇所がDCジャック、電源基板、ハーネス、メイン基板上の電源回路、筐体との機械的接続のどれだったかは公開情報から不明。DP-700SHとの関係も未確認。
