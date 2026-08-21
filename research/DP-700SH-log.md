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

### 今回の本丸未回収

- `TH34_dpf.pkg` / `TH35_dpf.pkg` / `TH36_dpf.pkg` バイナリ本体
- DP-700SHのSoC / OS / RAM / Flash / 基板写真
- `RRMCG2009SCZZ` の搬送波・プロトコル・全キーコード
- Dusty/Bih-Wei Shyr氏のSanjet在籍を示す直接資料
- SanjetとSharp/FUJIFILM DPシリーズを直接結ぶ契約・製品資料
