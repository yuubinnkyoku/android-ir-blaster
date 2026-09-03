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

## 追加根拠: `MR7910 / MR791x` 写真表示機器向け製品系統

### 確定事項

2007〜2008年世代の市販デジタル写真表示機器 Uniden `UDV-15` の分解記録では、メイン基板が `15B1A-MB Ver 1.2`、日付が `2007-11-23` と確認されている。メイン制御ICは基板直付けのCOB（エポキシ封止）で刻印は読めないが、付属OEMソフトのドライバは **Mars Semiconductor Corp. 製 `mr7910.sys` v2.5**、操作ソフトは **`mr7910.exe`**。USBでは `VID 093A / PID 020F` として認識される。

出典:
- https://goughlui.com/2020/06/28/tech-flashback-uniden-udv-15-digital-photo-viewer/

Windowsソフトの登録情報でも、Mars Semiconductor製 `Photo Viewer` は `C:\Program Files\Mars\MR7910\` に入り、`mr7910.exe` のほか `mr7911.exe`, `mr7912.exe`, `MR7911.dll` などを含む。TAO Image Transferでは同じ `MR7910` ディレクトリと `mr7910.exe` を使い、ドライバ `MR7910.sys` の製造元がMars Semiconductorと記録されている。Brookstone向け画像転送ソフトでも開発元がMars Semiconductor、実行ファイルが `mr7910.exe` とされる。

出典:
- https://www.shouldiremoveit.com/Photo-Viewer-32226-program.aspx
- https://www.shouldiremoveit.com/TAO-Image-Transfer-11341-program.aspx
- https://brookstone-image-transfer.software.informer.com/

さらに部品流通記録には、実IC型番として **`MR7910A-0A`（MARS / QFP）** と **`MR7910B-0A`（MARS / QFP100）** が残る。`06+` という流通側表記もあるが、その意味を製造年と断定しない。

出典:
- https://www.radiomag.com.de/mars
- https://www.y-ic.kr/pdf/MR7910A-0A.html

### DP-700SH系列との関係 — 状況証拠

Marsが単に「デジタルフォトフレーム向けSoCを扱っていた」という企業紹介だけでなく、2007〜2008年頃に **`MR7910 / MR791x` と呼ばれる実在の写真表示機器向けIC・ドライバ・OEMソフト系統を持っていた**ことが確認できた。したがって、DP-700SH / 850SH / 1020SHの基板やファームを回収した際は、Sunplus系候補と並行して `MR79xx`, `MR7910`, `MR7911`, `MR7912`, `Mars` を照合する価値がある。

### 推測 / 未確定

- **DP-700SH / DP-850SH / DP-1020SHがMR7910系を搭載した証拠はない。**
- Uniden / Brookstone / TAO向けMR791x系と、2009〜2010年のAIPTEK / Sanjet / Sharp案件が同じSoC世代・開発チームだった証拠はない。
- Uniden実機のメインICはCOBのため、分解記録だけでは `MR7910A/B` そのものの刻印を確認できない。`mr7910.sys` / `mr7910.exe` と実IC流通型番の一致は強い手掛かりだが、当該Uniden個体のSoC型番を直接確定するものではない。
- USB `VID 093A` は別資料ではPixArt Imagingに割り当てられているため、Marsとの関係やVID利用理由は未解明。このVIDだけからSoCメーカーを推定しない。

## 今回も未解決

- `TH34_dpf.pkg` / `TH35_dpf.pkg` / `TH36_dpf.pkg` 本体
- DP-700SH / DP-850SH / DP-1020SH のメイン基板写真・SoC刻印
- DP-700SH自身のOS
- `RRMCG2009SCZZ` の搬送波・方式・実キーコード
- SharpからSanjet等台湾ODMへの直接発注資料
