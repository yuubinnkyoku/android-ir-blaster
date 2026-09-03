# DP-700SH 調査追補 — 2026-09-03

## 天擎積體（Mars Semiconductor）SoC候補を補強する一次寄り資料

### 確定事項

天擎積體電路（Mars Semiconductor）の2019年株主総会年報（会社沿革）には、同社について以下が記載されている。

- 2001年2月の設立時から `DSC / DV / 電子相框 / PC相機` 向けの開発に注力していた。
- 2008年（民国97年）に **奇景光電（Himax）のSoCチームを統合し、MPEG-4を開発した**。

出典:
- https://www.mars-semi.com.tw/wp-content/uploads/2021/09/108%E5%B9%B4%E8%82%A1%E6%9D%B1%E6%9C%83%E5%B9%B4%E5%A0%B1.pdf
- 検索時に同PDFの会社沿革表で `97年 合併奇景光電的SoC團隊，開發了MPEG4。` を確認。

また、現在残る天擎積體の企業紹介では、同社がデジタルカメラ・デジタルフォトフレーム・デジタル画像処理向けSoCを開発し、顧客例として **天瀚科技（AIPTEK）** を挙げている。

出典:
- https://108976.web66.tw/

### DP-700SH系列との関係 — 状況証拠

DP-850SH / DP-1020SH はMPEG-4 SP動画再生に対応する。天擎側はSharp向け案件開始より前の2008年にMPEG-4対応SoC技術を持っており、さらにAIPTEKを顧客例として挙げているため、既知の `AIPTEK -> Sanjet` 系譜と時間的・技術的には整合する。

参考:
- https://dc.watch.impress.co.jp/docs/news/346441.html

### 推測 / 未確定

- **DP-700SH / DP-850SH / DP-1020SHがMars Semiconductor製SoCを搭載した証拠はまだない。**
- `AIPTEKがMars SoCを購入した` という一般的な顧客関係から、Sharp/FUJIFILM DP案件への採用を直接導くことはできない。
- 2008年に統合されたHimax SoCチームの具体的な製品型番、およびDPF向けSoC型番は未同定。
- 今後、基板写真または `TH34/35/36_dpf.pkg` を回収できた場合は、`Mars`, `MRxxxx`, `Himax` / 奇景由来の識別子もSoC候補として照合する。

## 今回も未解決

- `TH34_dpf.pkg` / `TH35_dpf.pkg` / `TH36_dpf.pkg` 本体
- DP-700SH / DP-850SH / DP-1020SH のメイン基板写真・SoC刻印
- DP-700SH自身のOS
- `RRMCG2009SCZZ` の搬送波・方式・実キーコード
- SharpからSanjet等台湾ODMへの直接発注資料
