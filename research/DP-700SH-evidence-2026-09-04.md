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

## 今回も未解決

- `TH34_dpf.pkg` / `TH35_dpf.pkg` / `TH36_dpf.pkg` のバイナリ本体
- DP-700SH / DP-850SH / DP-1020SH のメイン基板写真・SoC刻印
- DP-700SH自身のOS
- `RRMCG2009SCZZ` の搬送波・プロトコル・実キーコード
- SharpからSanJet等台湾ODMへの直接発注資料

Wayback Machineでは今回も `http://download.fujifilm.co.jp/pub/tools/dp700sh/TH34_dpf.pkg` および同ディレクトリ配下に保存実体を確認できなかった。
