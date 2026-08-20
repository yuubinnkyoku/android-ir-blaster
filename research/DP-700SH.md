# FUJIFILM DP-700SH リバースエンジニアリング調査メモ

最終更新: 2026-08-20 JST

DP-700SH のハードウェア、ファームウェア、赤外線リモコン、開発/製造系統を追跡する作業メモ。**確定情報・状況証拠・推測を分ける**。

## 現在の実機側の状況

- 対象: FUJIFILM DP-700SH
- 純正リモコンは手元にない。
- nubia Z80 Ultra で `android.hardware.consumerir` を確認済み。
- `yuubinnkyoku/android-ir-blaster` を Signal Tester / 総当たり探索向けに改造し、APK導入済み。
- 現在 Sharp 13-bit 系を実機で総当たり中。
  - UIは4桁hexのため65,536通りに見える。
  - 無接頭辞Sharp探索は内部で13-bitに正規化され、固有候補は8,192 (`0000`–`1FFF`)。
- 反応が出た場合は Pause → Triggerで同一候補を再送 → 再現したらSave Hit。

## 確定度: 高

### SHARP製液晶を採用

DP-1020SH / DP-850SH / DP-700SH はSHARP製液晶を採用。DP-700SHは7型800×480 ASV液晶。

参考:
- https://dc.watch.impress.co.jp/docs/news/346441.html
- https://www.bcnretail.com/news/detail/100203_16329.html

**注意:** ここから「メイン基板・SoC・OSを含む本体全体がSHARP設計/OEM」とまでは断定しない。

### DP-700SHの標準ACアダプターはSHARP `EP-D72F`

中古販売記録で、DP-700SHの付属品としてACアダプター型番 `EP-D72F` が明記されている。別の中古流通記録では同型番が **SHARP ACアダプター** として扱われ、仕様は5V 2A（10W）、プラグ外径約4.0mm/内径約1.7mm、センタープラスとされる。

参考:
- https://used.sofmap.com/r/item/2133006495537
- https://paypayfleamarket.yahoo.co.jp/item/e1186028374
- https://www.ebay.co.uk/b/bn_616753
- https://jp.mercari.com/search?keyword=DP-700SH

実機で確認済みの「ACアダプターにSHARP表記」という観察と一致する。これにより、SHARP製電源部品がDP-700SHの標準付属品として採用されていた可能性は高い。

**ただし、これはメイン基板・SoC・OSを含む本体全体がSHARP設計/OEMである証拠ではない。** 液晶、電源、開発顧客関係の証拠は分離して扱う。

### 2010年に3機種共通のファームウェア更新が存在

2010-04-30、DP-1020SH / DP-850SH / DP-700SH向けに共通更新が公開された。修正対象はIrSimple / IrSS / IrDA通信がイレギュラー操作で中断した場合に、まれにシステムがハングする症状。

旧公式URL:
- http://fujifilm.jp/support/digitalphotoframe/download/dp1020sh_dp850sh_dp700sh/download001.html

記事:
- https://dc.watch.impress.co.jp/docs/news/365704.html

更新ファイル本体、ファイル名、バージョン番号は未回収。

### miniUSB-Bは通常のPC接続用USB Device

取扱説明書から、PCと接続して内蔵メモリを読み書きするためのminiUSB-B端子であることを確認済み。サービス専用端子という証拠はない。

### 画像転送IRとリモコン受光は別系統

仕様上、IrSS / IrSimple受信用と専用リモコン用の受光部は別用途。スマホからIrSimpleを送るだけではリモコン代用にはならない。

### 本体情報からファームバージョン表示が可能

取扱説明書に本体情報/バージョン表示がある。実機の現在バージョンはまだ記録できていない。

### DP-700SH純正リモコン型番は `RRMCG2009SCZZ`

2026-08-20、Yahoo!オークションのDP-700SH出品写真から、付属リモコン裏面ラベルを直接確認した。ラベルには以下が明瞭に写っている。

- `REMOTE CONTROL UNIT`
- `RRMCG2009SCZZ`
- `使用電池 リチウム電池 CR2025 1個`
- `FUJIFILM Corporation`

出品自体が **FUJIFILM DP-700SH** のもので、同じ出品写真にDP-700SH用リモコンの前面・背面が掲載されているため、従来の「候補型番」から **DP-700SHの純正付属リモコン型番として直接確認済み** へ格上げする。

参考:
- Yahoo!オークション DP-700SH 出品 `q1171811726`
  - https://auctions.yahoo.co.jp/jp/auction/q1171811726

前面はFUJIFILMロゴ入りで、電源、メニュー、方向/決定、戻る、スライドショー、インデックス、モード切替、便利メニュー、時計、絞り込み、縮小、拡大、回転などDP系で必要なキーを持つ。

## 確定度: 中～高

### DP-850SH / DP-1020SHの開発案件は `Customer: Sharp`

台湾・新竹の技術者 Dusty Shyr（石璧維）の公開職歴に、2009-10〜2010-02の案件として以下が残る。

- `Digital Photo Frame - FUJIFILM DP-850SH/DP-1020SH`
- `Product: FUJIFILM DP-850SH/DP-1020SH`
- `Customer: Sharp`

参考:
- https://tw.linkedin.com/in/%E7%92%A7%E7%B6%AD-dusty-shyr-%E7%9F%B3-a6ab8a5b

DP-700SHの名前はこの記録にはない。ただし700SH/850SH/1020SHは同時期シリーズで共通ファーム更新を受けているため、SHARPが液晶供給以上に開発へ関与した可能性を補強する。

### 同じ担当者の案件が連続している

公開職歴上:

1. 2008-04〜10: Digital PhotoFrame - Electronic photo Album / Customer: Jablotron
2. 2009-03〜09: Story Book inColor / Customer: AIPTEK（Project / SW Manager）
3. 2009-10〜2010-02: FUJIFILM DP-850SH/DP-1020SH / Customer: Sharp

同一の台湾側ソフトウェア開発チームまたはODMが複数顧客向けにデジタル写真機器を開発していた可能性がある。ただし当時の所属会社名はまだ特定できていない。

### Dusty Shyr氏の学術上の実名表記は `Bih-Wei Shyr`

国立陽明交通大学（旧・国立交通大学）の機関リポジトリに、1998年の修士論文 `影像序列中網型物件之建立與追蹤` の著者として **石璧維 / Bih-Wei Shyr** が記録されている。2000年のSPIE論文にも `Bih Wei Shyr` として掲載される。

研究内容は画像特徴点抽出、階層メッシュ、動画像中の物体追跡・動き推定など、画像処理系。LinkedInの `石璧維 (Dusty Shyr)` は学歴をNCTU EEとしており、漢字氏名・大学・時期が整合するため、同一人物とみてよい。

参考:
- https://ir.lib.nycu.edu.tw/handle/11536/64322
- https://scholar.nycu.edu.tw/en/publications/generation-and-tracking-of-mesh-objects-in-image-sequences/
- https://tw.linkedin.com/in/%E7%92%A7%E7%B6%AD-dusty-shyr-%E7%9F%B3-a6ab8a5b

**意味:** 当時所属会社の探索では `Dusty Shyr` だけでなく `Bih-Wei Shyr`, `Bih Wei Shyr`, `Shyr BW` も検索語として使える。現時点では、この実名表記から2008〜2010年の勤務先を直接示す資料や特許までは見つかっていない。

**検索上の注意:** LinkedInの現在所属欄に出る `新帝` は **SanDisk（新帝科技）** を指す。台湾の2010年資料でも `新帝科技（SanDisk Corporation）` と対応することを確認できる。これは現在の所属を示すものであり、2008〜2010年のJablotron / AIPTEK / Sharp案件を担当した受託会社名の手掛かりとしては使わない。

参考:
- https://tw.linkedin.com/jobs/view/technologist-engineer-firmware-engineering-at-sandisk-4396560497
- https://seminar.trendforce.com/Compuforum/2010/TW/sponsors

### AIPTEK資料との食い違いは「外部受託チーム」仮説を強める

2009年のStory Book inColorについて、台湾側の公開資料には **天瀚科技（AIPTEK）が研発・製造した製品** と明記されている。一方、Dusty Shyr氏は同じ案件を自身のプロジェクト履歴で `Customer: AIPTEK` と記録している。

参考:
- https://9lib.co/document/rz32k9eq-Aiptek%E5%BD%A9%E8%89%B2%E5%85%92%E7%AB%A5%E9%9B%BB%E5%AD%90%E6%9B%B8%E9%80%B2%E8%BB%8D%E6%96%B0%E5%8A%A0%E5%9D%A1%E5%B8%82%E5%A0%B4.html
- https://tw.linkedin.com/in/%E7%92%A7%E7%B6%AD-dusty-shyr-%E7%9F%B3-a6ab8a5b

この2点は矛盾しない。AIPTEKが製品全体の開発・製造主体でありつつ、ソフトウェアや一部システム開発を外部企業へ委託していた可能性がある。むしろDusty氏がAIPTEK社員だったなら、自社製品を `Customer: AIPTEK` と表記するのはやや不自然である。

**現時点の評価:** Dusty氏は2008〜2010年に、Jablotron / AIPTEK / Sharpを顧客とする同一の台湾系受託開発会社または設計会社に所属していた可能性が高まった。会社名は未特定。これは状況証拠であり確定事項ではない。

### `RRMCG2009SCZZ` はDP-850SH / DP-1020SHでも使われた可能性が高い

メルカリの同型番リモコン出品には対応機種として `DP-850SH` / `DP-1020SH` が明記されている。中古出品者による記載なので公式互換表ではないが、DP-700SHでの写真による直接確認と合わせると、3機種が同一リモコンを共有した可能性は高い。

参考:
- https://jp.mercari.com/item/m93734607492
- https://jp.mercari.com/item/m53512993273

これは3機種のUI/リモコン入力層が共通だった可能性を補強する。ただし、基板やSoCまで同一であることを意味しない。

### `RRMCG` 型番体系はSHARPのリモコン部品番号で広く使われる

SHARPの旧製品資料には `RRMCG1392CESA`, `RRMCG1327CESA`, サービス用 `RRMCG0033TASA` など多数の例があり、`RRMCG...` がSHARPのリモコン部品番号体系であることを確認できる。

参考:
- https://sharp.manymanuals.com/data-projectors/xg-e3500u/instruction-manual-16837/37
- https://manualzilla.com/doc/7351006/sharp-pg-d100u-instruction-manual
- https://manualzz.com/doc/736350/sharp-s50a2vl-fd1u-camcorder-service-manual

したがってFUJIFILMロゴ/ラベルの `RRMCG2009SCZZ` も **SHARP系部品番号体系に乗ったリモコンである可能性が高い**。これはSharpがDPシリーズのリモコン設計・調達に関与した状況証拠になるが、`RRMCG2009SCZZ` の製造者をSHARPと断定する一次資料は未回収。

### 先代DP-70SHには隠しファーム更新画面がある

DP-70SH Ver.1.04.00の公開更新では、SDカードへファームを保存し、「本体情報→バージョン表示」中にリモコンで

`拡大 → 縮小 → 時計 → 回転`

と押すとファームウェア書き換え画面に入る。

参考:
- https://dc.watch.impress.co.jp/cda/accessories/2009/04/01/10602.html

DP-700SH純正リモコンにも **拡大・縮小・時計・回転** の4キーがすべて存在することを写真で確認できた。したがって、先代と同じ隠し更新シーケンスをDP-700SHでも試せる条件が揃った。ただし、同じシーケンスが実装されているかは未確認。

### 後継DP-701SH / DP-801SHにも共通更新

2011-07-29に共通ファームVer.1.04.07が公開された。

参考:
- https://dc.watch.impress.co.jp/docs/news/464018.html

一方、2011年12月購入のDP-801SHで1.05.01が出荷状態だったという実機報告があり、Web未公開の工場/修理向けビルドが存在した可能性がある。

### 後継DP-701SH / DP-801SHではSharpとの「共同開発」が明記される

2011年2月のデジカメ Watch発表会記事は、DP-701SH / DP-801SHについて **「シャープと共同開発した24ビット表示が可能な『クリスタルフォト液晶』」を搭載** と明記している。

参考:
- https://dc.watch.impress.co.jp/docs/news/425705.html
- FUJIFILMの同製品プレス向け画像ページ: https://www.fujifilm.co.jp/press/ffnr0485.html

これは少なくとも後継2011世代では、Sharpの関与が単なる液晶パネル供給に留まらず、表示系の共同開発に及んだ直接的な資料である。

**推測:** 2010年のDP-700SH/850SH/1020SHについても、Sharp製液晶、Sharp製電源、`Customer: Sharp` の開発案件、Sharp系 `RRMCG` 部品番号という痕跡と合わせると、Sharpが製品開発に深く関与した系譜が翌年まで継続した可能性は高い。ただし、2011世代の「共同開発」を2010世代へそのまま遡及して確定扱いにはしない。

## 赤外線リモコン調査

### 確定した純正型番

`RRMCG2009SCZZ` はDP-700SHの純正付属リモコン。

既知の公開情報:
- 使用電池: CR2025 × 1
- FUJIFILM Corporation表記
- Yahoo!フリマの単品出品では全ボタンの赤外線発光確認済み
- DP-850SH / DP-1020SH対応として流通する個体あり

参考:
- https://auctions.yahoo.co.jp/jp/auction/q1171811726
- https://paypayfleamarket.yahoo.co.jp/item/g1043790009
- https://jp.mercari.com/item/m93734607492

### 公開IRデータベースの現状

`Lucaslhm/Flipper-IRDB` の `Picture_Frames` では現時点でFUJIFILM/SHARPフォトフレームの登録を確認できていない。GitHubコード検索でも `DP-700SH` / `RRMCG2009SCZZ` の既知IR信号は未発見。

## 赤外線探索戦略

優先順位:

1. Sharp 13-bit（8,192固有候補）
2. 内蔵IR DBのSHARP候補
3. Kaseikyo / SHARP vendor `5AAA`
4. 近縁SHARP写真機器の既知コード
5. その他の家電IRプロトコル

`RRMCG` がSHARP系部品番号である状況証拠が増えたため、Sharp 13-bit優先は従来より合理的になった。ただしプロトコルそのものは未確定。

Kaseikyoは実効20-bitで約1,048,576候補あるため、vendor/address/commandの既知情報を拾ってから部分探索する。

DP-700SHは受光位置/指向性が扱いづらいという実機レビューがあるので、全探索時はスマホIR送信口を受光部へ正確に向けることが重要。

## 比較対象

### Jablotron / ALBUMteam `ALBUM`

同じ台湾側担当者が2008年に関わった案件。Jablotron公式には現在もALBUM firmware 1.15が残る。

現行配布:
- `albumq42008_en.zip` 約4.2MB

旧Jablotronサイト複製では同じfirmware 1.15を `FWI (4 MB)` と表示しているため、旧更新実体は `.fwi` 系だった可能性が高い。

取扱説明書から、更新はファームファイルをALBUMのルートへコピーして再起動する方式。ALBUMはUSB接続時にFAT32外部ディスクとして見える。

ALBUMteamは台湾企業ではなく、2008年にチェコのDominika Nell ApplováとDalibor Dědekが設立した企業で、Jablotronグループの一員として報道されている。ALBUMは米国/チェコで設計され、台湾/中国で生産されたとされる。

参考:
- https://www.prnewswire.com/news-releases/albumteam-named-as-ces-innovations-2010-design--engineering-award-honoree-80907592.html
- https://www.finance.cz/clanky/217833-jablotron-navzdory-krizi-zvysil-trzby-o-petinu-na-1-2-miliardy-kc/

### Prosoyo Technology

2009年前後のJablotronは中国のEMS企業Prosoyoと深く提携し、グループ生産の大きな割合を同社へ委託していたという当時報道がある。Prosoyoは現在もDongguan工場/Hong Kong拠点を持ち、製品設計からPCB実装・完成品組立までを掲げるEMS企業。

ただし **ALBUMをProsoyoが製造した証拠、ましてDP-700SHとの直接関係は未確認**。サプライチェーン逆引きの候補として扱う。

### AIPTEK Story Book inColor

同担当者の2009年案件。8型800×600、USB host/slave、SD系、JPEG/MP3等を持つ。機能構成は近いが、SoC/OS/基板情報は未回収。

台湾側資料ではStory Book inColorを天瀚科技（AIPTEK）が研発・製造したとする一方、Dusty氏の履歴ではAIPTEKは `Customer`。このため、AIPTEK自身とは別の受託開発チームが存在した可能性が高まっている。

参考:
- https://9lib.co/document/rz32k9eq-Aiptek%E5%BD%A9%E8%89%B2%E5%85%92%E7%AB%A5%E9%9B%BB%E5%AD%90%E6%9B%B8%E9%80%B2%E8%BB%8D%E6%96%B0%E5%8A%A0%E5%9D%A1%E5%B8%82%E5%A0%B4.html

### SHARP HN-PP100 / HN-PP150

同時期のSHARP AQUOSフォトプレーヤーはeSOL `eCROS`を採用し、OSはμITRON 4.0準拠 `PrKERNELv4`。

参考:
- https://www.esol.co.jp/archive/news/emb_press090512.html

これはDP-700SHのOS証拠ではない。同時期SHARP写真機器の比較候補。

## 未解決事項

- DP-700SHのSoC型番
- RAM / Flash型番
- メイン基板型番
- OS / RTOS
- 2010年公式更新ファイル本体・ファイル名・バージョン
- 更新形式、署名/暗号化の有無
- リモコンの搬送波周波数/プロトコル/全キーコード
- DP-70SHの隠し更新シーケンスがDP-700SHにも残るか
- DP-700SH/850SH/1020SHの基板/ソフト共通範囲
- 2008〜2010年案件を担当した台湾側開発会社/ODM

## 次に掘るもの

- 旧FUJIFILMページのWayback/CDXから更新ファイルhref回収
- DP-70SHおよびDP-701SH/801SHの旧公開ファイル名を回収し命名規則を推定
- DP-700SH/850SH/1020SHの分解・修理・基板写真
- `RRMCG2009SCZZ` の信号コード
- `RRMCG` 系SHARPリモコンのプロトコル対応から信号方式を逆引き
- ALBUM/Story BookのFCC・内部写真・基板・SoC
- Dusty Shyr氏の当時所属会社を `Dusty Shyr` / `Bih-Wei Shyr` / `Bih Wei Shyr` / `Shyr BW` とJablotron/AIPTEK/Sharpの顧客関係から逆引き
- Prosoyoや別の台湾開発会社との人員/案件接点
- 実機から現在のファームバージョンとUSB VID/PIDを取得
- 実機で「本体情報→バージョン表示→拡大→縮小→時計→回転」の反応を確認

## 記録方針

推測を確定情報として扱わない。特に次を混同しない:

- SHARP製液晶 / Sharp顧客案件
- SHARP製ACアダプター
- `RRMCG` 系リモコン部品番号
- 本体全体のOEM/SoC/OS

これらは別々の証拠として管理する。