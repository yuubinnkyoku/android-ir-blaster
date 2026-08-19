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

**注意:** ここから「メイン基板・SoC・OSを含む本体全体がSHARP設計/OEM」とまでは断定しない。実機で使っているACアダプターにもSHARP表記があるが、これも本体内部設計の証明ではない。

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

### AIPTEK資料との食い違いは「外部受託チーム」仮説を強める

2009年のStory Book inColorについて、台湾側の公開資料には **天瀚科技（AIPTEK）が研発・製造した製品** と明記されている。一方、Dusty Shyr氏は同じ案件を自身のプロジェクト履歴で `Customer: AIPTEK` と記録している。

参考:
- https://9lib.co/document/rz32k9eq-Aiptek%E5%BD%A9%E8%89%B2%E5%85%92%E7%AB%A5%E9%9B%BB%E5%AD%90%E6%9B%B8%E9%80%B2%E8%BB%8D%E6%96%B0%E5%8A%A0%E5%9D%A1%E5%B8%82%E5%A0%B4.html
- https://tw.linkedin.com/in/%E7%92%A7%E7%B6%AD-dusty-shyr-%E7%9F%B3-a6ab8a5b

この2点は矛盾しない。AIPTEKが製品全体の開発・製造主体でありつつ、ソフトウェアや一部システム開発を外部企業へ委託していた可能性がある。むしろDusty氏がAIPTEK社員だったなら、自社製品を `Customer: AIPTEK` と表記するのはやや不自然である。

**現時点の評価:** Dusty氏は2008〜2010年に、Jablotron / AIPTEK / Sharpを顧客とする同一の台湾系受託開発会社または設計会社に所属していた可能性が高まった。会社名は未特定。これは状況証拠であり確定事項ではない。

### 先代DP-70SHには隠しファーム更新画面がある

DP-70SH Ver.1.04.00の公開更新では、SDカードへファームを保存し、「本体情報→バージョン表示」中にリモコンで

`拡大 → 縮小 → 時計 → 回転`

と押すとファームウェア書き換え画面に入る。

参考:
- https://dc.watch.impress.co.jp/cda/accessories/2009/04/01/10602.html

DP-700SHでも同じシーケンスが残るかは未確認。リモコンキーが1つでも判明したら重要な検証対象。

### 後継DP-701SH / DP-801SHにも共通更新

2011-07-29に共通ファームVer.1.04.07が公開された。

参考:
- https://dc.watch.impress.co.jp/docs/news/464018.html

一方、2011年12月購入のDP-801SHで1.05.01が出荷状態だったという実機報告があり、Web未公開の工場/修理向けビルドが存在した可能性がある。

## 純正リモコン調査

### 候補型番 `RRMCG2009SCZZ`

FUJIFILM DIGITAL PHOTO FRAME用リモコンとして `RRMCG2009SCZZ` が複数の中古流通記録に残る。

参考:
- https://paypayfleamarket.yahoo.co.jp/item/g1043790009
- 楽天市場の中古流通記録 `C2J710`, `C2J726`

Yahoo!フリマの出品では全ボタンの赤外線動作確認済みと記載。2026-08-20時点でメルカリにも同型番が複数残っている。

**ただしDP-700SH対応とはまだ直接確認できていない。**

次の確認方法:
- DP-700SH付属リモコン写真と `RRMCG2009SCZZ` の前面ボタン配置を比較
- 裏面ラベル/部品番号を比較
- 同型番を採用するFUJIFILM機種を逆引き
- LIRC / Flipper-IRDB / IRDB等の既知コードを探索

### 公開IRデータベースの現状

`Lucaslhm/Flipper-IRDB` の `Picture_Frames` では現時点でFUJIFILM/SHARPフォトフレームの登録を確認できていない。GitHubコード検索でも `DP-700SH` / `RRMCG2009SCZZ` の既知IR信号は未発見。

## 赤外線探索戦略

優先順位:

1. Sharp 13-bit（8,192固有候補）
2. 内蔵IR DBのSHARP候補
3. Kaseikyo / SHARP vendor `5AAA`
4. 近縁SHARP写真機器の既知コード
5. その他の家電IRプロトコル

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
- 純正リモコンの正式部品番号
- リモコンの搬送波周波数/プロトコル/全キーコード
- `RRMCG2009SCZZ` とDP-700SHの対応関係
- DP-70SHの隠し更新シーケンスがDP-700SHにも残るか
- DP-700SH/850SH/1020SHの基板/ソフト共通範囲
- 2008〜2010年案件を担当した台湾側開発会社/ODM

## 次に掘るもの

- 旧FUJIFILMページのWayback/CDXから更新ファイルhref回収
- DP-70SHおよびDP-701SH/801SHの旧公開ファイル名を回収し命名規則を推定
- DP-700SH/850SH/1020SHの分解・修理・基板写真
- `RRMCG2009SCZZ` の対応機種と信号コード
- ALBUM/Story BookのFCC・内部写真・基板・SoC
- Dusty Shyr氏の当時所属会社をJablotron/AIPTEK/Sharpの顧客関係から逆引き
- Prosoyoや別の台湾開発会社との人員/案件接点
- 実機から現在のファームバージョンとUSB VID/PIDを取得

## 記録方針

推測を確定情報として扱わない。特に次を混同しない:

- SHARP製液晶 / Sharp顧客案件
- SHARP製ACアダプター
- 本体全体のOEM/SoC/OS

これらは別々の証拠として管理する。