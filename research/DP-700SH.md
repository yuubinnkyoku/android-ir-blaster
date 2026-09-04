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

### 勝捷光電の当時の代表者を会社登記履歴から特定

勝捷光電（SanJet Technology Corp.）の変更登記履歴では、AIPTEK/天瀚から代工部門が分割された直後から2010年前半まで、会社の負責人は **楊建國** 氏だった。

- 2009-06-25: 負責人 `楊建國`、`新竹市工業東四路19號6樓`
- 2010-05-31: 負責人 `楊建國`、同住所
- 2010-12-15 / 2011-01-20: 負責人 `郭國湞`
- 2011-09-02以降: 負責人 `廖筠松`

Dusty Shyr氏の `FUJIFILM DP-850SH/DP-1020SH / Customer: Sharp` 案件は2009-10〜2010-02なので、**案件期間中の勝捷光電の会社登記上の代表者は楊建國氏**となる。

参考:
- https://www.findcompany.com.tw/%E5%8B%9D%E6%8D%B7%E5%85%89%E9%9B%BB%E8%82%A1%E4%BB%BD%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8
- https://findbiz.nat.gov.tw/fts/company/24268077
- https://www.businesstoday.com.tw/article/category/80394/post/201402060014/

2014年の『今周刊』取材では、後年の董事長・CEOである廖筠松氏は **2010年11月に天瀚科技へ正式加入し、2011年4月に勝捷の経営を任された** と説明される。したがって、2009〜2010年初頭のFUJIFILM案件を廖氏主導とみなす根拠はない。

**注意:** 現在の経済部商工登記公示ページの經理人欄には `廖筠松 / 到職日期 098年11月02日` と表示されるが、同ページ自身がこの欄を法定の商工公示資料ではなく跨域参照情報と注意書きしており、上記取材の経歴とも1年ずれる。現段階ではこの日付をFUJIFILM案件への廖氏関与の証拠には採用しない。

**推測への影響:** 当時の台湾側組織を追う検索キーとして、後年の経営陣より **楊建國 / 郭國湞**、旧住所 `新竹市工業東四路19號6樓`、2009〜2010年当時の董事・技術者を優先する価値が高い。ただし楊氏・郭氏がSharp/FUJIFILM案件を直接担当した証拠はまだない。

### SanJet旧拠点とGeneralplus（凌通科技）が同じ `工業東四路19號`

SanJetの案件期間中の公式サイト保存版（2009-12-15 / 2010-02-14）は、連絡先を **`4F, No.19, Industry E. Rd 4, Hsinchu Science Park`** と記載している。一方、会社登記履歴では同時期に `新竹市工業東四路19號6樓` と記録される。階数表記は食い違うが、建物番号 `工業東四路19號` は一致する。

同じ `新竹市工業東四路19號` は、半導体設計会社 **Generalplus Technology Inc.（凌通科技股份有限公司）** の本社所在地でもある。

参考:
- https://web.archive.org/web/20091215033734id_/http://www.sanjetco.com/
- https://web.archive.org/web/20100214221305id_/http://www.sanjetco.com/
- https://www.findcompany.com.tw/index.php/GENERALPLUS%20TECHNOLOGY%20INC.
- https://w3.sunplus.com/tw/about/locations.asp

さらにSunplus（凌陽科技）の公式沿革は、**2009年にグループ内のPMP / MP3 / DPF（Digital Photo Frame）製品線をGeneralplusへ分割した**ことを明記している。当時の記事では分割基準日を **2009-12-01** としており、Dusty Shyr氏のFUJIFILM DP-850SH/DP-1020SH案件（2009-10〜2010-02）と重なる。Generalplusの正規流通資料にも製品線として `Digital Photo Frame IC` が掲げられている。

参考:
- https://www.sunplus.com/tw/about/milestones.asp
- https://www.unlistedstock.com.tw/news/detail/19702512
- https://www.wpgholdings.com/aitg/subsidiary/zhtw/sac/Generalplus

**確定:** 案件期間中のSanJetは、DPF用ICを正式な製品線として持つGeneralplusと同じ番地の建物に拠点を置いていた。また、GeneralplusがSunplusグループからDPF製品線を引き継いだ時期も案件期間と重なる。

**有力な推測:** SanJetがSharp向けFUJIFILM DPFを受託していたという仮説が正しい場合、Generalplus/Sunplus系SoCまたはその参照設計を使った可能性は、従来より優先して検証する価値が高い。特に基板写真が得られた場合は `Generalplus` / `Sunplus` / `GPL...` / `SPMP...` / `SPMF...` 系刻印を優先照合する。

**未確定:** DP-700SH / DP-850SH / DP-1020SHがGeneralplus製SoCを搭載した直接証拠はない。同一住所はテナント・グループ関係・単なる立地共有などでも説明でき、SoC採用の確定根拠にはしない。特定チップ型番、CPUアーキテクチャ、OSも未確認。