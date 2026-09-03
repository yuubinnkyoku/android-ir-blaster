# DP-700SH 調査追補 — 2026-09-04

## Sanjetの中国側製造拠点を蘇州・呉江まで絞り込み

### 確定事項

2013年12月27日付の *Taipei Times* は、SanJet（勝捷光電）について、2009年設立で、**新竹に研究開発センター、中国・蘇州に工場を運営している**と報じている。

出典:
- https://www.taipeitimes.com/News/biz/archives/2013/12/27/2003580017

2014年1月2日付のFinSMEsはさらに所在地を絞り、SanJetについて、**新竹科学園区にR&D/operation center、蘇州・呉江（Wujiang, Suzhou）にmanufacturing center**を持つと記している。

出典:
- https://www.finsmes.com/2014/01/sanjet-technology-receives-investment-intel-capital.html

同時期の2013年12月27日付iThome（Intel CapitalによるSanJet出資の発表）でも、SanJetはデジタル映像ソリューション企業として、**設計から生産までの垂直統合能力**、成熟したエンジニアリングチーム、世界的な一線メーカー顧客を持つと説明されている。

出典:
- https://www.ithome.com.tw/pr/84829

後年の台湾国際自動車及びオートバイ部品・アクセサリー見本市（TAIPEI AMPA）の2021年企業紹介も、SanJetが台湾本社と**蘇州呉江の自有工場**を持ち、研究開発から製造までを統合していると説明しており、2013〜2014年の資料と所在地が一致する。

出典:
- https://www.taipeiampa.com.tw/zh-tw/exhibitor/8B9C5CD2408898976C7FB98577BB89F4/info.html

### DP-700SH系列との関係 — 状況証拠

既知の資料では、SanJetは2009年6月にAIPTEKからOEM事業を引き継ぎ、2009年末〜2010年初頭の自社公式サイトで `OEM/ODM` と `Digital Photo Frame` を明示している。また、台湾側技術者Dusty Shyr氏の公開職歴には2009年10月〜2010年2月の `FUJIFILM DP-850SH/DP-1020SH / Customer: Sharp` 案件が残る。

今回の資料により、**SanJet仮説を追う場合の中国側製造拠点候補を、単なる「中国」から「蘇州・呉江」まで具体化できる**。今後は2009〜2010年前後の呉江・蘇州におけるSanJet関連会社登記、求人、輸出入記録、部材・EMS取引記録を優先して逆引きする価値がある。

### 推測 / 未確定

- **DP-700SH / DP-850SH / DP-1020SHがSanJetの蘇州・呉江工場で製造された証拠はない。**
- 今回の一次寄り資料が直接確認するのは2013〜2014年時点の工場所在地であり、同工場が2009〜2010年のDP案件当時から稼働していたことまでは証明しない。
- DPシリーズ本体の銘板にある `MADE IN CHINA` とSanJetの蘇州工場を直接結び付ける資料は未発見。
- Sharp→SanJetの発注・契約資料、またはDPシリーズの基板上のSanJet識別子は依然として未発見。

## 後継DP-701SH / DP-801SHの公式ファームは共通 `TH50_dpf.pkg`

### 確定事項

Wayback Machineに保存されたFUJIFILM公式 `DP-701SH／DP-801SH ファームウエアの更新` ページ（2014-07-22保存）から、2011年世代の後継2機種では**同一ファームウェアファイル**が配布されていたことを直接確認した。

- 対象: `DP-701SH / DP-801SH`
- ファイル名: **`TH50_dpf.pkg`**
- バージョン: **Ver.1.04.07**
- 容量: **2.95MB**
- 公式直リンク: `http://download.fujifilm.co.jp/pub/tools/jtnjcxxwbhehyq/TH50_dpf.pkg`

Wayback保存版:
- https://web.archive.org/web/20140722194942id_/http://fujifilm.jp/support/digitalphotoframe/download/dp701sh_dp801sh/download002.html

2011年7月29日のデジカメWatch記事も、DP-701SH / DP-801SHについて「ファームウェアは両機種で共通」「バージョン番号は1.04.07」と報じている。

出典:
- https://dc.watch.impress.co.jp/docs/news/464018.html

### DP-700SH系列への意味 — 状況証拠

2010年世代では、公式ファームが機種ごとに `TH34_dpf.pkg` / `TH35_dpf.pkg` / `TH36_dpf.pkg` と分かれていた。一方、2011年のDP-701SH / DP-801SHでは2機種共通の `TH50_dpf.pkg` へ統合されている。

このことから、**`THxx_dpf.pkg` という命名がDP-700SH/850SH/1020SHだけの偶発的な3機種連番ではなく、FUJIFILMデジタルフォトフレームの後継世代にも続く更新パッケージ系列だった**ことが分かる。

また、DP-701SH / DP-801SHは同一バイナリを共有できたため、少なくともこの後継2機種はファームウェア側でハード差分を吸収する、または実質的に共通ハード/ソフト基盤を持っていた可能性が高い。

### 推測 / 未確定

- `TH34/35/36` と `TH50` の数値自体がSoC型番、基板番号、案件番号を示す証拠はない。
- `TH50` の発見は、DP-700SH / 850SH / 1020SHがDP-701SH / 801SHと同一SoCまたは同一OSだったことを証明しない。
- 2010年世代で機種別バイナリだった理由が、液晶解像度・動画機能・メモリ容量・基板差のどれによるものかは未解明。
- `TH50_dpf.pkg` 自体もWayback CDXでは保存実体を確認できず、バイナリ解析には至っていない。

## 今回も未解決

- `TH34_dpf.pkg` / `TH35_dpf.pkg` / `TH36_dpf.pkg` のバイナリ本体
- DP-700SH / DP-850SH / DP-1020SH のメイン基板写真・SoC刻印
- DP-700SH自身のOS
- `RRMCG2009SCZZ` の搬送波・プロトコル・実キーコード
- SharpからSanJet等台湾ODMへの直接発注資料

Wayback Machineでは今回も `http://download.fujifilm.co.jp/pub/tools/dp700sh/TH34_dpf.pkg` および同ディレクトリ配下に保存実体を確認できなかった。
