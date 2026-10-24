# DP-700SH 調査ログ

要点は `research/DP-700SH.md` に集約し、このファイルには探索経路・比較対象・外れた仮説を時系列で残す。

## 2026-08-20

### 赤外線

- `android-ir-blaster` の Sharp 無接頭辞総当たりは内部で13bitへ正規化され、固有波形は8,192通り。
- `Lucaslhm/Flipper-IRDB` の `Picture_Frames` とGitHubコード検索では、FUJIFILM/SHARPフォトフレームや `DP-700SH` / `RRMCG2009SCZZ` の既知IRデータは未発見。
- Yahoo!フリマでは `RRMCG2009SCZZ` の全ボタン赤外線動作確認済みという中古記録を確認。

### `RRMCG2009SCZZ` をDP-700SH純正リモコンとして直接確認

Yahoo!オークションのDP-700SH出品 `q1171811726` の写真で付属リモコン前面・裏面を確認。

裏面ラベル:
- `REMOTE CONTROL UNIT`
- `RRMCG2009SCZZ`
- `使用電池 リチウム電池 CR2025 1個`
- `FUJIFILM Corporation`

出典:
- https://auctions.yahoo.co.jp/jp/auction/q1171811726

前面には `拡大 / 縮小 / 時計 / 回転` が存在し、先代DP-70SHの隠し更新キー列をDP-700SHでも物理的には試せる。

中古流通では同型番をDP-850SH / DP-1020SH対応として扱う例も確認。ただし公式互換表ではない。

### `RRMCG` はSHARP系部品番号

SHARPの旧製品資料には `RRMCG1392CESA`, `RRMCG1327CESA`, `RRMCG0033TASA` など多数の例がある。

**注意:** `RRMCG` がSharp系部品番号であることは `RC_PROTO_SHARP` 採用の証拠ではない。

### ファームウェア探索

- 2010-04-30にDP-700SH / DP-850SH / DP-1020SH共通更新が存在することは確認済み。
- 当初、通常Web検索では実ファイル名・更新後バージョンを回収できなかった。
- FUJIFILMカメラ系の `FPUPDATE.DAT` 等は比較例に過ぎず、DPシリーズの形式とは断定しなかった。
- 後継DP-701SH / DP-801SHは2011-07-29に共通Ver.1.04.07を公開。2011年12月購入のDP-801SHでVer.1.05.01という実機報告もあり、Web未公開の工場/修理向けビルドの存在可能性を記録。

### 開発者の連続案件

Dusty Shyr（石璧維）の公開プロジェクト履歴:

1. 2008-04〜10: `Digital PhotoFrame - Electronic photo Album`, Customer: Jablotron
2. 2009-03〜09: `Story Book inColor`, Customer: AIPTEK
3. 2009-10〜2010-02: `Digital Photo Frame - FUJIFILM DP-850SH/DP-1020SH`, Customer: Sharp

出典:
- https://tw.linkedin.com/in/%E7%92%A7%E7%B6%AD-dusty-shyr-%E7%9F%B3-a6ab8a5b

同一の台湾側開発会社/チームが複数顧客向けデジタル写真機器を連続開発した可能性を追跡。

### `Bih-Wei Shyr` 表記を確認

国立陽明交通大学の機関リポジトリで、1998年修士論文の著者として **石璧維 / Bih-Wei Shyr** を確認。2000年SPIE論文でも `Bih Wei Shyr` 表記。

出典:
- https://ir.lib.nycu.edu.tw/handle/11536/64322
- https://scholar.nycu.edu.tw/en/publications/generation-and-tracking-of-mesh-objects-in-image-sequences/

現在所属として表示される `新帝` はSanDisk（新帝科技）であり、2008〜2010年当時の受託会社名としては扱わない。

### Sharp関与

- DP-700SH / 850SH / 1020SHはSharp製液晶。
- DP-850SH / 1020SH開発案件は `Customer: Sharp`。
- DP-700SH標準ACアダプターは `EP-D72F` でSHARP表記。
- DP-700SH純正リモコンはSharp系 `RRMCG...` 番号体系。

ただし当時はメイン基板・SoC・OSまでSharp設計とは断定しなかった。

### Jablotron ALBUM比較

同じ担当者の2008年案件。Jablotron公式にALBUM firmware 1.15が残る。

- 現行: `albumq42008_en.zip` 約4.2MB
- 旧サイト複製: `FWI (4 MB)` 表示

旧更新実体が `.fwi` 系だった可能性があるが、DP-700SHとの形式共通を示す証拠ではない。

ALBUMteamはJablotron系のチェコ企業で、台湾ODMではない。Prosoyo TechnologyをJablotron側の中国EMS候補として記録したが、ALBUMやDPシリーズとの直接関係は未確認。

### AIPTEK Story Book inColor

8型800×600、USB host/slave、SD系、JPEG/MP3等を持つ比較対象。AIPTEK資料では「研発・製造」とされる一方、Dusty氏は `Customer: AIPTEK` と記録。外部受託チーム仮説を強める材料とした。

## 2026-08-21

### DP-70SHに少なくとも2回の公開更新

- 2009-03-31: Ver.1.04.00
- 2009-09-18: 別の「最新ファームウェア」記事

3月版ではSDカードへファームを置き、「本体情報→バージョン表示」中に `拡大 → 縮小 → 時計 → 回転` で書き換え画面へ入る。

出典:
- https://dc.watch.impress.co.jp/cda/accessories/2009/04/01/10602.html
- https://dc.watch.impress.co.jp/docs/news/20090918_316738.html

9月版のバージョン・実ファイル名は未回収。

### 2009年からSharpが製品訴求の前面に出ていた

DP-70SH販売資料ではFUJIFILMとSharpを並べた訴求があり、ITmediaも「富士フイルム×シャープ」と表現。

出典:
- https://www.kitamura.jp/shopping/ichioshi/2009/fujifilm_dp-70sh.html
- https://www.itmedia.co.jp/news/article/0902/04/1090204098/

後継DP-701SH / DP-801SHでは「シャープと共同開発した24ビット表示が可能なクリスタルフォト液晶」と明記される。

### JABLOTRON TAIWANの役割

当時のJablotron Company Profileでは:

- `JABLOTRON TAIWAN – sales and marketing for Asia region`
- `JABLOTRON CHINA – production QC and component supplying`

と記載。

出典:
- https://www.sklep-jablotron.pl/userfiles/files/company_profile.pdf

Dusty氏がJABLOTRON TAIWANの社内開発者だったという読みは弱まり、別の台湾受託会社仮説を補強。

### Sharp 13-bit探索の前提を修正

Linux kernelの `RC_PROTO_SHARP` は5-bit address + 8-bit commandと約40ms後の反転側メッセージ。現行 `lib/ir/protocols/sharp.dart` はこの2メッセージ構造を実装済み。

出典:
- https://www.kernel.org/doc/html/next/userspace-api/media/rc/rc-protos.html
- https://www.sbprojects.net/knowledge/ir/sharp.php

**確定:** 「第2メッセージを送っていないため反応しない」という仮説は除外。

**修正:** `RRMCG...` がSharp系部品番号でも、Sharp 13-bit方式採用の証拠にはならない。

### DP-7Vを比較対象に追加

DP-7Vは2010-07-30に公開Ver.1.2.30。2010-05-04の実機報告では1.2.2.0と1.2.2.5が混在。

出典:
- https://dc.watch.impress.co.jp/docs/news/385194.html
- https://bbs.kakaku.com/bbs/K0000060109/

同時期FUJIFILM DPFで、Web公開版とは別に出荷時の細かな改版が存在した実例。

### DP-700SH銘板から中国製造を直接確認

中古出品写真および後のユーザー提供実機写真で `MADE IN CHINA` を直接確認。

出典:
- https://jp.mercari.com/item/m81292816659

### ユーザー実機写真で「製造元: シャープ株式会社」とVer.1.03.00を直接確認

2026-08-21提供写真から:

本体銘板:
- `デジタルフォトフレーム DP-700SH W`
- `定格: 5V 8W`
- `販売元: 富士フイルム株式会社`
- **`製造元: シャープ株式会社`**
- `製造番号: 0T070764`
- `MADE IN CHINA`

本体情報:
- **`バージョン表示 1.03.00`**

ACアダプター:
- `EP-D72F`
- `SHARP`
- `DC 5V 2A`
- `MODEL: T04A-05200D2-S2`
- `MADE IN CHINA`
- `ATECH`

これによりSharpは単なる液晶供給元ではなく、少なくともDP-700SH完成品の銘板上の製造元と確定。

### `EP-D72F` の電源OEMをATECH OEM INC.と特定

UL Solutions Product iQのATECH OEM INC.認証 `E227161` に `T04A-0520XXX-XX` 系列を確認。実機 `T04A-05200D2-S2` はこの系列に収まる。

出典:
- https://productiq.ulprospector.com/en/profile/2433476/qqgq.e227161
- https://www.atechoem.com/document-detail/0/1511/
- https://www.icaa.org.tw/data-64119

電源OEMは台湾企業まで特定できたが、本体ODM/EMSとは別に扱う。

### Sanjet Technology（勝捷光電）が台湾側開発会社候補として浮上

AIPTEK年報で2009年6月に代工/OEM事業をSanjetへ分割譲渡したことを確認。SanjetはAIPTEKと同じ新竹市工業東四路19號に所在し、2009年商標には `數位相片播放器` / `數位相框` が含まれる。AIPTEKのデジタルフォトフレーム関連実用新案もSanjetへ移った痕跡あり。

出典:
- https://www.aiptek.com.tw/uploads/information_year/en/111%E5%B9%B4%E5%A0%B1.pdf
- https://findbiz.nat.gov.tw/fts/company/24268077
- https://www.findcompany.com.tw/trademark/01391873_098027401
- https://patents.google.com/patent/CN201153780Y/zh

2014年『今周刊』ではSanjetを台湾R&D・中国製造の受託会社と説明し、光学・マルチメディア・ソフトウェアの専門チームを持ち、日本顧客も引き継いだとする。

出典:
- https://www.businesstoday.com.tw/article/category/80394/post/201402060014/

**有力な推測:** Dusty氏がAIPTEK→Sanjet分割チーム側にいたなら、`Customer: AIPTEK` から直後の `Customer: Sharp` への職歴が自然。

**未確定:** Dusty/Bih-Wei Shyr氏のSanjet在籍、SanjetとSharp/FUJIFILM DPシリーズの直接契約。

### SanjetとSunplusの資本接点

Sunplus Technologyの2009年年報で、Sunplus Venture CapitalがSanjet株369千株、約1%を保有していたことを確認。

出典:
- https://www.sunplus.com/ir/annual/2009_ar_en.pdf

比較対象としてSunplus `SPMF2800/SPMF2800A` 系フォトフレームでは `SPMF28XX Boot Loader`、MIPS32 4K系、ThreadX、SPI Flash、SD/MS、USB、UARTなどの解析例がある。

**注意:** 資本接点はSoC採用証拠ではない。DP-700SH=SPMF2800 / ThreadX / MIPSは未証明。

### WaybackでFUJIFILM公式更新ページを復元し、公開更新バージョンを確定

従来は2010-05-05 17:10:35の保存が存在するところまで確認していたが、今回はWayback取得に成功し、`download001.html` 本文を直接確認できた。

旧公式ページ:
- http://fujifilm.jp/support/digitalphotoframe/download/dp1020sh_dp850sh_dp700sh/download001.html

Wayback保存版:
- https://web.archive.org/web/20100505171035id_/http://fujifilm.jp/support/digitalphotoframe/download/dp1020sh_dp850sh_dp700sh/download001.html

本文に明記:
- **DP-700SH: バージョン1.04.00**
- **DP-850SH / DP-1020SH: バージョン1.03.00**

修正内容は既知のIrSimple / IrSS / IrDA通信中断時のまれなハング。

**確定:** ユーザー実機DP-700SHの `1.03.00` は、2010-04-30公開の1.04.00更新を適用していない旧版。以前の「1.03.00が公開更新版かもしれない」という未確定状態は解消。

**未確定:** 1.03.00が工場出荷時の初版か、非公開の中間ビルドか。

### 使用許諾後ページから公式ファーム実ファイル名・容量・直リンクを回収

Waybackで2012-01-21 02:44:16保存の `download002.html` を復元した。

Wayback保存版:
- https://web.archive.org/web/20120121024416id_/http://fujifilm.jp/support/digitalphotoframe/download/dp1020sh_dp850sh_dp700sh/download002.html

公式ページ本文:

- **DP-700SH**
  - `TH34_dpf.pkg`
  - 2.1MB
  - `http://download.fujifilm.co.jp/pub/tools/dp700sh/TH34_dpf.pkg`
- **DP-850SH**
  - `TH35_dpf.pkg`
  - 2.2MB
  - `http://download.fujifilm.co.jp/pub/tools/dp850sh/TH35_dpf.pkg`
- **DP-1020SH**
  - `TH36_dpf.pkg`
  - 2.2MB
  - `http://download.fujifilm.co.jp/pub/tools/dp1020sh/TH36_dpf.pkg`

また `download001.html` から更新手順PDFのファイル名を確認:
- `ff_dp1020sh_dp850sh_dp700sh_firmware_mn_j.pdf`
- ページ表示上422KB

**確定:** 3機種は同日・同内容の更新を受けたが、実更新バイナリは機種別 `.pkg`。`TH34 / TH35 / TH36` が連番で、容量も近い。

**推測:** 共通のソフトウェア/ビルド基盤から機種別パッケージを生成していた可能性が高い。ただしSoC/基板同一の証拠ではない。

### `.pkg` 本体のWayback保存を再確認

各実URLをWayback CDXで exact / prefix検索したが、`TH34_dpf.pkg` / `TH35_dpf.pkg` / `TH36_dpf.pkg` 本体の保存は確認できなかった。

`http://download.fujifilm.co.jp/pub/tools/` 自体にはWayback保存があるが、対象3ファイルの個別captureは現時点で見つからない。

**現状:** ファイル名・容量・公式URLまで回収。バイナリ本体のみ未回収。

### 2009年12月Sanjet公式サイトを復元

Wayback MachineでSanjet公式トップページの **2009-12-15 03:37:34** 保存版を直接取得した。

保存版:
- https://web.archive.org/web/20091215033734id_/http://www.sanjetco.com/

当時のSanjet自身の記載:
- OEM/ODMサービスを提供
- 製品系列に `Digital Photo Frame`
- ほかに Digital Camcorder / Digital Still Camera / Projector / Digital Tablet
- 連絡先は `4F, No.19, Industry E. Rd 4, Hsinchu Science Park`

この保存日時はDusty Shyr氏の `FUJIFILM DP-850SH/DP-1020SH / Customer: Sharp` 案件（2009-10〜2010-02）の真ん中に当たる。

**確定:** Sanjetは少なくとも2009年12月時点で、自社公式サイト上でデジタルフォトフレームを含むOEM/ODM事業を明示していた。後年の会社紹介・商標・AIPTEK事業分割だけではなく、案件期間中の一次資料で確認できた。

**推測への影響:** SanjetがSharp向けFUJIFILM DPF案件の台湾受託会社だったという仮説は一段強くなる。時期、所在地、受託形態、製品分野が一致する。

**未確定:** Dusty/Bih-Wei Shyr氏のSanjet在籍、SanjetとSharp/FUJIFILM DPシリーズの直接契約・製品資料。

### 今回の本丸未回収

- `TH34_dpf.pkg` / `TH35_dpf.pkg` / `TH36_dpf.pkg` バイナリ本体
- DP-700SHのSoC / OS / RAM / Flash / 基板写真
- `RRMCG2009SCZZ` の搬送波・プロトコル・全キーコード
- Dusty/Bih-Wei Shyr氏のSanjet在籍を示す直接資料
- SanjetとSharp/FUJIFILM DPシリーズを直接結ぶ契約・製品資料

### 2010年2月14日Sanjet公式サイトを追加確認

Wayback MachineでSanjet公式トップページの **2010-02-14 22:13:05** 保存版を取得した。

保存版:
- https://web.archive.org/web/20100214221305id_/http://www.sanjetco.com/

本文は2009年12月保存版と同系統で、Sanjet自身が以下を明記している。
- OEM/ODM services
- 製品系列に `Digital Photo Frame`
- `4F, No.19, Industry E. Rd 4, Hsinchu Science Park`

この日付はDusty Shyr氏の `FUJIFILM DP-850SH/DP-1020SH / Customer: Sharp` 案件（2009-10〜2010-02）の終了月に当たる。

**確定:** Sanjetは少なくとも2010年2月中旬まで、自社公式サイト上でデジタルフォトフレームを扱うOEM/ODM企業として自社を位置づけていた。

**推測への影響:** 「SanjetのDPF/OEM記載は2009年末だけだった」「Sharp案件終了後にDPF分野へ入った」という説明はさらに取りにくくなる。案件期間とSanjetの事業内容が別時点の一次資料でも重なる。

**未確定:** ページにはSharp/FUJIFILM/Dusty Shyr氏の名はなく、SanjetがDP-850SH/DP-1020SHを受託した直接証拠ではない。

## 2026-09-02: DP-850SH実機銘板で製造元SHARPを確認

中古流通の実機写真を確認したところ、DP-850SH背面銘板から次を直接判読できた。

- `デジタルフォトフレーム DP-850SH`
- `定格: 5V 8.5W`
- `販売元: 富士フイルム株式会社`
- `製造元: シャープ株式会社`
- `MADE IN CHINA`

出典:
- Yahoo!オークション: https://auctions.yahoo.co.jp/jp/auction/f1218793047
- メルカリ: https://jp.mercari.com/item/m88022822137

**確定:** DP-850SHの完成品銘板上の製造元はSharp。既知のDP-700SHの `製造元: シャープ株式会社` と合わせ、少なくとも700SH/850SHの2機種で完成品レベルのSharp製造表示が独立に確認できた。

**推測:** 700SH/850SHがSharpを製造元とする近縁系列だった可能性を補強する。台湾側の `FUJIFILM DP-850SH/DP-1020SH / Customer: Sharp` という開発案件記録とも整合するが、これだけで同一SoC・同一基板・同一OSや、Sanjetを含む台湾ODMの具体的な関与までは確定しない。

**未確定:** DP-1020SHの背面写真も見つかったが、今回確認した画像は製造元欄を十分鮮明に読めないため、銘板上の製造元は保留。

## 2026-09-05: Generalplus（凌通科技）をSoC候補として優先調査対象に追加

SanJetの案件期間中の所在地を再照合した。2009-12-15および2010-02-14のSanJet公式サイト保存版は `4F, No.19, Industry E. Rd 4, Hsinchu Science Park` と記載する。一方、会社登記履歴は2009-06-25 / 2010-05-31に `新竹市工業東四路19號6樓`。階数は異なるが、どちらも **工業東四路19號** で一致する。

この番地は **Generalplus Technology Inc.（凌通科技）** の本社所在地でもある。

出典:
- https://web.archive.org/web/20091215033734id_/http://www.sanjetco.com/
- https://web.archive.org/web/20100214221305id_/http://www.sanjetco.com/
- https://www.findcompany.com.tw/index.php/GENERALPLUS%20TECHNOLOGY%20INC.
- https://w3.sunplus.com/tw/about/locations.asp

ここでGeneralplus側の当時の事業を確認すると、Sunplus（凌陽科技）の公式沿革に **2009年、PMP / MP3 / DPF等の製品線をGeneralplusへ分割** と明記されている。当時の記事では分割基準日が **2009-12-01**。これはDusty Shyr氏の `FUJIFILM DP-850SH/DP-1020SH / Customer: Sharp` 案件（2009-10〜2010-02）の途中に当たる。

出典:
- https://www.sunplus.com/tw/about/milestones.asp
- https://www.unlistedstock.com.tw/news/detail/19702512

さらにGeneralplusの正規流通資料は製品線として **`Digital Photo Frame IC`** を列挙している。

出典:
- https://www.wpgholdings.com/aitg/subsidiary/zhtw/sac/Generalplus

### 判断

**確定:** 案件期間中、SanJetはGeneralplus本社と同じ番地の建物に拠点を持っていた。Generalplusは同じ2009年にSunplusグループからDPF製品線を引き継いでいる。

**状況証拠:** SanJetがSharp向けFUJIFILM案件を担当したという既存仮説が正しい場合、Generalplus/Sunplus系のDPF SoC・参照設計を使っていた可能性を優先して検証する理由が新たにできた。

**未確定:** DP-700SH / DP-850SH / DP-1020SHがGeneralplus製SoCを搭載したという直接証拠はない。`工業東四路19號` の一致だけでSoC供給関係とは断定しない。特定チップ型番、CPU、OSも不明。

### 次回以降の基板照合キー

基板写真・分解記録を得た場合は、従来のSharp/Sunplus候補に加え、`Generalplus`、`GPL...`、`SPMP...`、`SPMF...` 系刻印を優先して確認する。Sunplus公式沿革上のDPF製品線移管と案件時期が重なるため、単なる一般的なSoC候補より優先度を上げる。

### DP-1020SH発売延期: 電源接続部の不具合

AV Watchの2010-03-10記事を確認。DP-1020SHは当初2010-03-13発売予定だったが、一部機体で **電源接続部の不具合** が見つかり、全数検査のため2010-03-20へ延期された。DP-850SHは予定通り2010-03-13発売。

出典:
- https://av.watch.impress.co.jp/docs/news/353844.html

**確定:** DP-1020SHのみ発売前に電源接続部不具合による全数検査が実施された。DP-850SHは同じ延期対象ではない。

**推測への影響:** DP-850SH / DP-1020SHは同じ台湾側案件名で扱われ、共通ファーム更新も受けるが、電源接続部・その実装・筐体側接続構造の少なくともどこかは機種固有だった可能性が高い。完全同一基板仮説を弱め、共通ソフトウェア基盤＋機種別ハード構成という見方と整合する。

**未確定:** 不具合部位の具体的な部品、DP-700SHとの共通性、メイン基板上の電源回路まで異なるかは不明。

## 2026-09-11: DP-70SHからDP-700SHへの明示的な系列継承を確認

DP-70SHの隠し更新操作は既に記録していたが、今回2010-02-02のDP-700SH発表記事を再確認し、同機が **「従来機種『DP-70SH』の流れを汲む7型デジタルフォトフレーム」** と明記されていることを確認した。

出典:
- DP-700SH発表記事: https://dc.watch.impress.co.jp/docs/news/346441.html
- DP-70SH更新記事: https://dc.watch.impress.co.jp/cda/accessories/2009/04/01/10602.html

DP-70SH側の確定済み更新入口:
1. `本体情報の表示`
2. `バージョン表示`
3. リモコンで `拡大 → 縮小 → 時計 → 回転`
4. `ファームウェア書き換え画面` へ遷移

DP-700SHは手元実機に同じ `本体情報の表示` / `バージョン表示` があり、純正 `RRMCG2009SCZZ` に4キーすべてが存在する。

**確定:** DP-700SHは当時の記事でDP-70SHの系列継承機と明示されている。DP-70SHには上記の隠し更新操作が実在した。

**推測への影響:** DP-700SHで同じキー列を試す根拠は、単なる画面サイズ・UI・キー名称の類似より強くなった。Ver.1.03.00実機で更新画面へ入れるかを確認する価値が高い。

**未確定 / 注意:** DP-70SHとDP-700SHのSoC、OS、ブートローダ、更新パッケージ形式が同一という証拠はない。DP-700SHで同じキー列が有効とも未確認。DP-70SH用ファームをDP-700SHへ投入しない。

### 今回も未回収

- `TH34_dpf.pkg` / `TH35_dpf.pkg` / `TH36_dpf.pkg` のバイナリ本体
- DP-700SH / 850SH / 1020SHのSoC刻印付き基板写真
- DP-700SHのOS / RTOS直接証拠
- `RRMCG2009SCZZ` の搬送波・プロトコル・全キーコード
- Sharp↔SanJetを直接結ぶ契約・発注・製品資料

## 2026-09-13: Sharp `RRMCG...` 系の公開IRキャプチャを確認

GitHubの公開IRデータベースを掘り直し、DP-700SH純正 `RRMCG2009SCZZ` そのものではないが、同じSharp `RRMCG...` 型番系列の実測データを2件確認した。

### `RRMCG0041SJSA`

`AliasFakename/ir-remotes` のLIRC設定は2002-02-22生成。ヘッダに `brand: Sharp`、`model no. of remote control: RRMCG0041SJSA`、対象機器 `Audio System XL-3500 H` と明記。

- `bits 15`
- `flags SPACE_ENC|CONST_LENGTH`
- `one 281 1816`
- `zero 281 775`
- `ptrail 288`
- `gap 66679`
- `min_repeat 2`
- `toggle_mask 0x3ff`
- `KEY_POWER 0x11A2`

このファイル自体にはcarrier frequency指定なし。

出典:
- https://github.com/AliasFakename/ir-remotes/blob/main/remotes/sharp/RRMCG0041SJSA.lircd.conf

### `RRMCG A375 WJSA`

`sasiplavnik/Flipper-IRDB` では、Power / DVD-TV / Zoom / Stop / Rewind等をraw timingで保存。

- `frequency: 38000`
- `duty_cycle: 0.33`
- Powerは `3208 1604 394 394 ...` で始まる長いraw列

出典:
- https://github.com/sasiplavnik/Flipper-IRDB/blob/master/SHARP/RRMCG%20A375%20WJSA.ir

### 判断

**確定:** `RRMCG...` 系Sharpリモコンに公開実測IRデータが存在する。少なくとも一例は15-bit `SPACE_ENC` としてLIRCに記録され、別例は38kHz rawとして保存される。

**探索方針への影響:** DP-700SHでSharp系を優先する根拠は増える一方、`RRMCG`型番だけで13-bitまたは15-bitの一形式へ固定する根拠にはならない。現在のSharp 13-bit総当たりで反応がない場合も、型番を理由に他形式を排除しない。

**注意:** Linux kernelの `RC_PROTO_SHARP` と現行実装については既に2026-08-21に確認済み。今回の15-bit表記は別機種のLIRC表現であり、DP-700SHを15-bitへ再分類する直接証拠ではない。

### 同時探索

- `TH34_dpf.pkg` / `TH35_dpf.pkg` / `TH36_dpf.pkg`: Web/GitHub/Waybackで新規ミラーなし。
- `album-life.com` 2008〜2011保存: 新しいファームZIP/バイナリは見つからず。
- JABLOTRON公式 `albumq42008_en.zip`: URLは生存するが今回も本文取得・静的解析に到達できず。
- DP-700SH / 850SH / 1020SHのSoC刻印付き基板写真、OS/RTOS直接証拠: 新規なし。
- Sharp↔SanJetをDPシリーズ名で直接結ぶ新規資料: なし。

詳細:
- `research/DP-700SH-evidence-2026-09-13-1228.md`
- `research/DP-700SH-log-2026-09-13-1228.md`


## 2026-09-28 07:05 JST

### 新規確認: DP-70SH公式ファーム実体を回収

Wayback上で旧FUJIFILM公式配布物 `TH180700.ver` のバイナリ本体を確認。公式ページ表示は約1.9 MB。保存本体からUSB制御・タスク管理・ブート通信に関係するとみられる平文文字列、および `13:21:49 Apr 23 2009` を確認した。

出典:
- https://web.archive.org/web/20100204003717id_/http://fujifilm.jp/support/digitalphotoframe/download/dp70sh/download002.html
- https://web.archive.org/web/20160623113110id_/http://download.fujifilm.co.jp/pub/tools/dp70sh/TH180700.ver

判断: DP-70SHは「更新ページが存在した」段階から、解析可能な公式ファーム実体を確保できる段階へ進んだ。SoC/OSの断定は保留。

### 補助資料: DP-701SH / DP-801SHのファーム共用

2011-07-29公開のVer.1.04.07はDP-701SH/DP-801SHで共通。画面サイズ違いでもソフトウェア基盤を共通化した後継世代の実例として記録する。

出典: https://dc.watch.impress.co.jp/docs/news/464018.html

### 同時探索

- `TH34_dpf.pkg` / `TH35_dpf.pkg` / `TH36_dpf.pkg`: 新規ミラー/Wayback本体なし。
- DP-700SH / 850SH / 1020SHのSoC刻印付き基板写真、OS/RTOS直接証拠: 新規なし。
- `RRMCG2009SCZZ` の生IR波形: 新規なし。
- Sharp↔SanJetをDPシリーズ名で直接結ぶ新規資料: なし。


## 2026-10-07: 2010年リモコン写真・Sharp近縁リモコン・SanJet登記の追補

- Sharp公式部品サイトで、2008年AQUOSフォトプレーヤー `HN-PP100/150` 用純正リモコン `5686480005` の適合機種を確認。HN-PP150説明書はCR2025使用。DP-700SH `RRMCG2009SCZZ` のIRコードと互換かは未確認。実測比較対象に留める。
  - https://cocorostore.jp.sharp/option/option-av/option-photo-player/5686480005.html
  - https://cgi.jp.sharp/support/photoplayer/doc/hnpp150_mn.pdf
  - https://corporate.jp.sharp/news/081118-a-2.html
- RBB TODAY 2010-02-03の記事に、DP-1020SH/850SH/700SHの各「本体正面・背面とリモコン」写真の連番ページを確認。850SHと1020SHのキャプションは再確認済み。リモコン裏面型番・IR互換性は未証明。
  - https://www.rbbtoday.com/article/img/2010/02/03/65433/94805.html
  - https://www.rbbtoday.com/article/img/2010/02/03/65433/94806.html
  - https://www.rbbtoday.com/article/img/2010/02/03/65433/94807.html
- SanJet（統編24268077）の公開会社登記・輸出入登記を再確認。会社登記の法人設立2008-11-20、税籍上2008-12-02、輸出入原始登録2009-06-03、廖筠松の経理人就任2009-11-02を区別。2009-06-01「正式成立」は事業開始の可能性であり確定解釈ではない。
  - https://tw-company.info/company/24268077
  - https://companyradar.tw/c/24268077
  - https://www.digitimes.com.tw/tech/dt/n/shwnws.asp?id=0000398830_UIF9UDYF2AYO4W1AFVXO2
- Waybackで `TH34_dpf.pkg` / `TH35_dpf.pkg` / `TH36_dpf.pkg` のexact/prefix保存を再検索したが、本体は未回収。SoC刻印・OS直接証拠・RRMCG2009SCZZ生波形・Sharp↔SanJet直接契約資料も未回収。


## 2026-10-08: AIPTEK公式年報と2008〜2009年の適時開示で事業分割を再検証、呉江製造拠点の新たな接点

### 確定
- AIPTEK公式111年報（PDF p.7 / 印刷頁4）: 2009-06、受託製造事業を既存法人SanJetへ譲渡。分割減資5.3億台湾ドル・5,300万株消却。SanJetがAIPTEK株主へ新株発行。
- 2008-11-10取締役会決議: 計画上の移管資産745,067千台湾ドル、負債215,067千台湾ドル、差引530,000千台湾ドル。分割先は当初AIPTEK100%出資の受け皿として計画。
- 2009-06-01開示: 分割基準日2009-06-01。2009-06-19のSanJet臨時株主総会会場は工業東四路19-1号のAIPTEK従業員食堂。
- SanJet登記: 2009-05-08資本額50万台湾ドル→2009-06-25資本額5億3,050万台湾ドル。増分5億3,000万台湾ドルは事業分割額と一致。
- AIPTEK公式年報: 2003-07、工業東四路19号の自社建設工場兼事務所ビルに移転。Generalplusとの住所一致はSoC採用の独立根拠として弱い。
- **今回新規に確認:** 同年報には2000-11、中国江蘇省呉江市で天瀚科技（吳江）有限公司の設立（生産・販売）が認可されたとある。SanJetの後年企業紹介も蘇州呉江経済開発区の自社工場を記載。

### 状況証拠
- AIPTEKとSanJetは台湾の工場兼事務所だけでなく、中国呉江の製造拠点にも連続性がある可能性。Sharp向けFUJIFILM DPF開発案件は2009-10〜2010-02で事業承継後に位置する。

### 未確定・断定禁止
- AIPTEK呉江法人とSanJet呉江工場が同一である証拠はない。設備・人員・工場の移転経緯を調査する必要あり。
- Dusty Shyr氏のSanJet在籍、SharpからSanJetへの発注、DPシリーズの実製造工場・SoC・OSは依然未確定。
- TH34/TH35/TH36本体、DP-700SH基板写真、RRMCG2009SCZZ生IRコードは今回も未回収。

### 出典
- https://www.aiptek.com.tw/uploads/information_year/en/111%E5%B9%B4%E5%A0%B1.pdf
- https://www.moneydj.com/kmdj/news/newsviewer.aspx?a=30d0dbda-0e8a-4b64-9d66-ad4a0c643d56
- https://www.moneydj.com/kmdj/news/newsviewer.aspx?a=667e5451-a279-49d9-a14e-0e437620cbb9
- https://findbiz.nat.gov.tw/fts/company/24268077
- https://www.findcompany.com.tw/%E5%8B%9D%E6%8D%B7%E5%85%89%E9%9B%BB%E8%82%A1%E4%BB%BD%E6%9C%89%E9%99%90%E5%85%AC%E5%8F%B8
- https://www.1111.com.tw/corp/68989454/


## 2026-10-09: DP-70SH公式バイナリの構造化された名前表を再確認

- **直接確認:** Wayback保存の公式DP-70SH用 `TH180700.ver` に、NUL区切りで `BOOT` / `NVRAM` / `NVRAM_2` / `ROMTAB` / `STRTAB` / `FIRMWARE` / `VERSION` / `CHECKSUM` が連続する箇所がある。
- **推測:** 更新用の領域/項目名表とみられるが、各項目の役割、実際の記録形式、書換え範囲は未解析。
- **断定禁止:** 先代DP-70SHの `.ver` の構造を2010年DP-700SHの `.pkg` へそのまま適用しない。DP-700SHのSoC/OSやファームの共通性の証拠にはならない。
- **出典:** https://web.archive.org/web/20160623113110id_/http://download.fujifilm.co.jp/pub/tools/dp70sh/TH180700.ver
- **取得上の制約:** 保存バイナリの冒頭側を文字列として確認したもので、全体の無損失回収・ハッシュ照合は未実施。
- **同時再検索:** `TH34_dpf.pkg` / `TH35_dpf.pkg` / `TH36_dpf.pkg` はWaybackの完全URL一致およびディレクトリ前方一致で保存なし。DP-700SH基板/SoC/OSの直接証拠、`RRMCG2009SCZZ`の生IRコード、Sharp↔SanJetの直接契約資料も未回収。


## 2026-10-10: 2007年の呉江工場買収の事後確認（前回未反映資料の整理）

- **確認:** 2007-03-02『自由時報』は、Gemtek（正文科技）がAIPTEK（天瀚科技）の呉江工場を1,000万米ドルで買収する取締役会決議を報道。設備・建物・土地・製造チームを対象とし、AIPTEKが100%保有する海外持株会社の全株式を移転する予定だった。
- **確認:** 2010-01-15のMoneyDJ記事は、Gemtekが2007年に当該工場を取得し、海外持株会社の全株式が移転したと回顧する。正確な登記移転日は不明。
- **確認:** AIPTEKの2010-06-30企業開示は、新竹市工業東四路19之1号の工場（11,741.36平方メートル）をESMTへ2億4,200万台湾ドル（税別）で売却すると記す。台湾経済部の工場登記では、AIPTEK名義の工業東四路19号工場が2011-09-16廃業登録。
- **解釈:** 2009年のAIPTEK→SanJetのODM事業分割と、呉江・新竹工場の不動産・法人持分の移動を同一視できない。2007年買収後の呉江法人の支配関係、SanJetの後年の呉江工場との同一性、Sharp製DPシリーズの製造場所は未確定。
- **出典:** https://ec.ltn.com.tw/article/paper/118278 ; https://www.moneydj.com/kmdj/news/newsviewer.aspx?a=c974612e-0784-47c1-8147-03b0e65528ad ; https://news.cnyes.com/news/id/3521205 ; https://findbiz.nat.gov.tw/fts/factory/05/08895A00420


## 2026-10-11: 2010年3機種共通の公式更新手順PDF本体をWaybackで確認

- **一次資料で確定:** 2012-01-21保存の公式更新案内 `download001.html` が示すPDFの実リンク先は `/support/digitalphotoframe/download/pack/pdf/ff_dp1020sh_dp850sh_dp700sh_firmware_mn_j.pdf`。
- **一次資料で確定:** WaybackのCDXに2012-01-21 04:01:19、HTTP 200、application/pdfでPDF本体の保存がある。2014年・2015年の再訪記録もある。保存PDFの先頭に `%PDF-1.6`、`/L 432694`、`/N 10`。公式ページ記載422KBと整合。
- **訂正:** 従来の `/support/pdf/digitalphotoframe/manual/...` というパスは2012年公式案内のリンク先と異なる。正しくは `/support/digitalphotoframe/download/pack/pdf/...`。
- **未確定:** PDF本文は未抽出。更新ファイルのSD配置、隠しキー列、操作手順はまだ確認していない。PDFが現存しても `TH34_dpf.pkg` 本体は未回収。
- **推測・次の検証:** PDF本文を取得して画面写真・操作を検証できれば、DP-70SHからの更新ローダ継承仮説を評価できる。

出典:
- https://web.archive.org/web/20120121024416id_/http://fujifilm.jp/support/digitalphotoframe/download/dp1020sh_dp850sh_dp700sh/download001.html
- https://web.archive.org/web/20120121040119id_/http://fujifilm.jp/support/digitalphotoframe/download/pack/pdf/ff_dp1020sh_dp850sh_dp700sh_firmware_mn_j.pdf


## 2026-10-19: 公式仕様表の3機種比較（共通画像処理・待機制御の状況証拠）

2010年4月保存の富士フイルム公式「主な仕様」3ページを個別取得して照合。DP-700SH / DP-850SH / DP-1020SHのすべてで、**待機時約1.7W、JPEG最大6,400万画素（最大8,000×8,000画素）、インデックス表示30画面/12画面、カレンダー・時計各4種類、同じSD/SDHC・xD・MS・CFスロットとminiUSB-B端子**が明記される。動作時は約8W / 約8.5W / 最大約9.5Wで機種差がある。

**確定:** 以上は3機種それぞれのメーカー公式仕様表の数値・記載であり、単なる中古販売者の証言ではない。

**推測:** 共通JPEG処理上限とUI構成は、共通画像処理ソフトウェアまたは参照設計の可能性を補強する。待機時1.7Wの一致は共通待機制御仕様を示唆するが、公称値の一致だけで電源ICや主基板の共通性は証明できない。

**注意:** 仕様表の「対応OS（USB接続）」に並ぶWindows 7/Vista/XP/2000は接続先PCのOSであり、DPシリーズ本体のOSではない。SoC刻印・OS・基板写真・純正リモコンのIR実測波形・TH34/35/36ファーム本体は依然未回収。

出典:
- https://web.archive.org/web/20100421070032id_/http://fujifilm.jp/personal/digitalphotoframe/dp700sh/specs.html
- https://web.archive.org/web/20100422232902id_/http://fujifilm.jp/personal/digitalphotoframe/dp850sh/specs.html
- https://web.archive.org/web/20100425001655id_/http://fujifilm.jp/personal/digitalphotoframe/dp1020sh/specs.html


## 2026-10-20: 公式更新案内にある「IrDA（サポート外）」とSDカード更新の一次確認

**確認資料:** 富士フイルム公式 `download001.html` のWayback保存（2012-01-12 20:12:32 UTC）。
https://web.archive.org/web/20120112201232id_/http://fujifilm.jp/support/digitalphotoframe/download/dp1020sh_dp850sh_dp700sh/download001.html

**確定（原文で確認）:**
- 修正履歴は「IrSimple／IrSS、およびIrDA（サポート外）」の通信中断時のハングを対象としている。従来のメモはIrDAを併記していたが、**メーカーがIrDAをサポート外と明記している点**が欠落していた。
- 公式の更新手順概要は、パソコン＋カードリーダーで更新ファイルをSDメモリーカードへ書き込み、カードを本体に挿して操作する方式。
- 詳細手順のPDFリンクは `/support/digitalphotoframe/download/pack/pdf/ff_dp1020sh_dp850sh_dp700sh_firmware_mn_j.pdf`（既知の2012-01-21保存）。本文未抽出。

**推測と限界:** IrDAが修正対象に入ることは、内部に関連処理が存在する可能性を示すが、一般利用可能なIrDA機能やリモコンとの互換性は意味しない。USBによるファーム更新、SDのディレクトリ配置、隠し操作列は依然未確認。今回も `TH34_dpf.pkg` 本体、SoC/OS、基板刻印、`RRMCG2009SCZZ` 実測IRコード、Sharpと台湾側ODMの直接契約資料は未回収。

補助資料（更新手順PDFのWayback保存）:
https://web.archive.org/web/20120121040119id_/http://fujifilm.jp/support/digitalphotoframe/download/pack/pdf/ff_dp1020sh_dp850sh_dp700sh_firmware_mn_j.pdf


## 2026-10-23: 公式更新手順PDFの既存確認事項を本体メモへ統合

2026-10-22の独立調査ログ [DP-700SH-log-2026-10-22-official-update-steps.md](DP-700SH-log-2026-10-22-official-update-steps.md) に既に記録済みの公式PDF本文抽出結果を、`research/DP-700SH.md` の末尾へ統合。**今回新しいファーム本体を発見したわけではない。**

- **確定（前回確認済み）:** 2010年3機種共通の公式PDFは、機種別 `TH34_dpf.pkg` / `TH35_dpf.pkg` / `TH36_dpf.pkg` のSDカード直下への配置と、バージョン画面での「拡大→縮小→時計→回転」による書換え画面呼出しを記載。約1分の更新、赤緑交互点滅、ACアダプター抜き差しで再起動。
- **推測・未確定:** 2009年DP-70SHと操作列が同じでも、同一SoC/OS/基板/更新ファイル形式は未証明。3機種の `.pkg` 本体、DP-700SHのSoC/OS/基板刻印、純正リモコンの生IR波形、Sharpと台湾ODMの直接契約は依然未回収。
- **今回の調査:** 公式PDFのWayback保存を再確認。ファーム本体とリモコン実測符号の公開ミラー、SoC刻印付き基板写真、台湾側ODMとの直接関係について、新たな独立証拠は得られなかった。

出典: https://web.archive.org/web/20120121040119id_/http://fujifilm.jp/support/digitalphotoframe/download/pack/pdf/ff_dp1020sh_dp850sh_dp700sh_firmware_mn_j.pdf


## 2026-10-24 02:17 JST: 後継DP-701SH/801SHの実配布パッケージを特定

- **一次資料（確定）:** 2014-07-22 / 2015-03-31 / 2019-09-15の富士フイルム公式 `download002.html` Wayback保存を照合し、3版とも `TH50_dpf.pkg Ver.1.04.07（2.95MB）` および `http://download.fujifilm.co.jp/pub/tools/jtnjcxxwbhehyq/TH50_dpf.pkg` を記載することを確認。
- **一次資料（確定）:** 2011-11-04保存の `download001.html` は2011年2機種共通の更新手順PDF `ff_dp701sh_dp801sh_firmware_mn_j.pdf` を案内し、2013-11-09のPDF保存も確認。
- **比較:** 2010年3機種の `TH34_dpf.pkg` / `TH35_dpf.pkg` / `TH36_dpf.pkg` に対し、2011年2機種は `TH50_dpf.pkg` 1本。世代間の命名・拡張子の連続性が新たに確認された。
- **推測:** 更新容器や書換え処理に共通部分がある可能性。ただし拡張子だけで同一形式/SoC/OSとはいえない。
- **未回収:** Wayback CDXで `TH50_dpf.pkg` 本体はHTTP/HTTPS完全URL・ディレクトリ前方一致とも保存なし。2010年3ファイル、SoC/基板、実測IR、ODM直接資料にも新規直接証拠なし。

出典:
- https://web.archive.org/web/20140722194942id_/http://fujifilm.jp/support/digitalphotoframe/download/dp701sh_dp801sh/download002.html
- https://web.archive.org/web/20150331120125id_/http://fujifilm.jp/support/digitalphotoframe/download/dp701sh_dp801sh/download002.html
- https://web.archive.org/web/20190915053305id_/http://fujifilm.jp/support/digitalphotoframe/download/dp701sh_dp801sh/download002.html
- https://web.archive.org/web/20111104091802id_/http://fujifilm.jp/support/digitalphotoframe/download/dp701sh_dp801sh/download001.html
- https://web.archive.org/web/20131109113605id_/http://fujifilm.jp/support/digitalphotoframe/download/dp701sh_dp801sh/pack/pdf/ff_dp701sh_dp801sh_firmware_mn_j.pdf


## 2026-10-24 04:54 JST: 2011年後継2機種の説明書でハードウェア世代差とSharp文書管理番号を確認

- **新規資料:** 富士フイルム名義のDP-701SH/DP-801SH「使用説明書」全文転載（2011年2月時点の仕様）。印刷頁1の付属品欄に**ACアダプター`EP-D701`**、印刷頁51の仕様表に**TN液晶、512MB内蔵メモリー、SD/メモリースティック、miniUSB-B、別系統の画像転送IRとリモコンIR、6W動作/1.6W待機、JPEG最大8000×8000**が明記される。印刷頁18には12枚/30枚の写真一覧、裏表紙には**`11B ② TINSJ4731SCZZ`**。
- **確定（資料の記載）:** 2010年DP-700SH/850SHのSharp製ASV液晶、1GB/2GB内蔵メモリー、xD/CF対応と比較して、2011年の後継世代ではハードウェア仕様が変更された。JPEG処理上限・写真一覧形式・リモコンのボタン名称などは共通。2011年2機種の更新ファイル`TH50_dpf.pkg`は既知であり、今回発見したファイルではない。
- **Sharp関連の照合:** `TINSJ4731SCZZ`は説明書末尾の印刷管理番号。Sharp公式の別製品説明書にも`TINSJ`系の番号がある。文書管理経路の状況証拠であり、2011年機のSoCや基板のSharp独自設計を立証するものではない。
- **推測:** 2010→2011年のハードウェア変更にもかかわらずUI・画像処理の仕様が継承されており、ソフトウェア資産の共通性を比較検証する価値がある。ただし同一バイナリ・SoC/OS・IRコードの互換性は未証明。EP-D701の電気仕様・プラグ寸法も未確認。
- **同時探索の結果:** GitHubコード検索で`TH34_dpf.pkg` / `TH35_dpf.pkg` / `TH50_dpf.pkg` / `RRMCG2009SCZZ`の公開ファイルに新規一致なし。Waybackの2010年3パッケージおよび2011年`TH50`の公式配布URL完全一致でも保存なし。SoC/OS、基板刻印写真、実測IR、ODM直接証拠は未回収。

出典:
- https://manualzilla.com/doc/6704692/%E3%83%80%E3%82%A6%E3%83%B3%E3%83%AD%E3%83%BC%E3%83%89---%E5%AF%8C%E5%A3%AB%E3%83%95%E3%82%A4%E3%83%AB%E3%83%A0
- https://manualzz.com/doc/4760993/fujifilm-dp-701sh--dp-801sh-%E3%83%87%E3%82%B8%E3%82%BF%E3%83%AB%E3%83%95%E3%82%A9%E3%83%88%E3%83%95%E3%83%AC%E3%83%BC%E3%83%A0-%E4%BD%BF%E7%94%A8%E8%AA%AC%E6%98%8E%E6%9B%B8
- https://www.sharp.co.jp/support/led/doc/lnlw3a1-ls2a1_mn.pdf
- https://web.archive.org/web/20100421070032id_/http://fujifilm.jp/personal/digitalphotoframe/dp700sh/specs.html
- https://web.archive.org/web/20100422232902id_/http://fujifilm.jp/personal/digitalphotoframe/dp850sh/specs.html
- https://web.archive.org/web/20100425001655id_/http://fujifilm.jp/personal/digitalphotoframe/dp1020sh/specs.html


## 2026-10-24 05:12 JST: DP-700SHに紐付けられたGizport旧PDFのWayback保存を確認

- **確認:** DP-700SH中古出品の製品仕様参照先として `http://img.gizport.jp/pdf/2012-11-18/34460.pdf` が記載。Wayback CDXで `20260106195930`、HTTP 200、application/pdfを確認。
- **PDF先頭部を直接確認:** `%PDF-1.6`、`/L 2167348`、`/N 78`、`/Encrypt`。約2.17 MB・78ページの保存PDF。ファイル内容の無損失取得・表紙の確認・復号・ハッシュ照合は未実施。
- **判断:** 2010年世代の説明書を調べるための新しい保存先候補。中古販売者の参照記載だけで「DP-700SHのメーカー公式説明書」と断定しない。SoC/OS/IRコード等の新しい直接証拠ではない。
- **出典:** https://jmty.jp/osaka/sale-ele-kw-fuji/p-8 ; https://web.archive.org/web/20260106195930id_/http://img.gizport.jp/pdf/2012-11-18/34460.pdf
- **他の探索:** `TH34_dpf.pkg` / `TH35_dpf.pkg` の新規配布ミラー、DP-700SH基板写真、`RRMCG2009SCZZ`の実測IR符号、Sharpと台湾側ODMの直接資料は見つからず。


## 2026-10-24 06:12 JST: 78ページのDP-700SH専用説明書を本文から確認

- **確定:** 2026-01-06保存のGizport旧PDF `34460.pdf` について、PDF本文抽出に成功。表紙に `DIGITAL PHOTO FRAME DP-700SH` と「使用説明書」。前回「機種未確定」としていた78ページ資料はDP-700SH専用の説明書だった。
- **確定（説明書記載）:** 印刷3ページに純正付属ACアダプター `EP-D72F`。印刷69ページにASV液晶、800×480、1GB、miniUSB-B、IrSS/IrSimple受信ポートとリモコン用受信部の別記載。最終ページに `10A ① Printed in China`。
- **組版の手掛かり:** ページの印刷元ファイル名 `DP-700SH.indd`、日付 `2010/01/21` 相当の文字列。印刷・編集の履歴とみられるが、本体製造日ではない。
- **技術的な限界:** PDFの日本語と英数字は独自フォントのため文字化けする。一部英数字を符号+31で復元した。印刷地は説明書に関する情報で、本体の製造地や台湾ODMを特定しない。2011年版の `TINSJ4731SCZZ` と異なる番号体系の可能性はあるが、2010年版の番号不在を断定しない。
- **未解決:** `TH34_dpf.pkg` 本体、SoC/OS、基板写真、`RRMCG2009SCZZ` 生IR符号、Sharp-台湾ODMの直接資料は今回も未回収。
- **出典:** https://web.archive.org/web/20260106195930id_/http://img.gizport.jp/pdf/2012-11-18/34460.pdf


## 2026-10-24 14:32 JST: DP-700SH説明書からリモコンの公称操作範囲を追加

- **新規に読めた一次資料の箇所:** 既に機種を確認済みの78ページ説明書 34460.pdf の印刷10ページ。リモコン使用時の図に「左右で約30°以内」「約2m以内」と記載（PDFの独自フォントによる文字化けあり。数値30°/2mは判読できる）。
- **確定:** DP-700SHの説明書が示すリモコンの公称操作範囲は約2m以内、左右約30°以内。受光部は既知のとおり本体前面。
- **実装・検証上の推測:** Android赤外線送信器を用いた総当たりでは受光部に正対・近距離で照射することが望ましい。距離・角度の不適合は正しい信号でも無反応となる原因になり得る。
- **未確認:** 純正RRMCG2009SCZZの実測搬送波・符号・各キーコード、SoC/OS/基板刻印、TH34_dpf.pkg本体、Sharp↔台湾側ODMの直接契約資料は未回収。
- **同時再調査:** 公開WebでTH34_dpf.pkg/TH35_dpf.pkg/TH36_dpf.pkg、RRMCG2009SCZZのIR波形、DP-700SH基板写真・SoCを検索。Waybackで3機種の公式パッケージ直URL（HTTP/HTTPS）の保存を再確認したが該当なし。
- **出典:** https://web.archive.org/web/20260106195930id_/http://img.gizport.jp/pdf/2012-11-18/34460.pdf （印刷10ページ）
