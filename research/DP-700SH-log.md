# DP-700SH 調査ログ

## 2026-08-20

### 保存方針

- 要点・確定事項は `research/DP-700SH.md` に集約する。
- このファイルには探索経路、外れた仮説、比較対象なども含めて時系列で残す。

### 赤外線

- `android-ir-blaster` の Sharp 無接頭辞総当たりは、UI上の16bit空間（65,536）とは別に内部カーソルを13bitへ正規化しているため、固有波形は8,192通り。
- 主要な Flipper Zero 公開IRデータベース `Lucaslhm/Flipper-IRDB` の `Picture_Frames` を確認したが、現時点では Micca / Nixplay / Pandigital のみで FUJIFILM / SHARP フォトフレームの登録は見つからなかった。
- GitHubコード検索でも `DP-700SH` と候補リモコン型番 `RRMCG2009SCZZ` の既知IRデータは見つからなかった。
- Yahoo!フリマの過去出品では `RRMCG2009SCZZ` の全ボタン赤外線動作確認済みという記録がある。

#### `RRMCG2009SCZZ` をDP-700SH純正リモコンとして直接確認

以前は `RRMCG2009SCZZ` をFUJIFILM DIGITAL PHOTO FRAME用の「候補型番」として扱っていたが、Yahoo!オークションの **DP-700SH出品 `q1171811726`** の画像検索結果で、付属リモコンの前面と裏面を直接確認できた。

裏面ラベルには明瞭に:

- `REMOTE CONTROL UNIT`
- `RRMCG2009SCZZ`
- `使用電池 リチウム電池 CR2025 1個`
- `FUJIFILM Corporation`

とある。出品対象そのものがDP-700SHであり、同一出品の写真にリモコンが付属しているため、**DP-700SHと `RRMCG2009SCZZ` の対応関係は直接確認済み**へ格上げする。

出典:
- https://auctions.yahoo.co.jp/jp/auction/q1171811726

前面写真から、DP-70SHの隠し更新手順で使う `拡大 → 縮小 → 時計 → 回転` の4キーが `RRMCG2009SCZZ` にすべて存在することも確認できた。したがってDP-700SH実機で同じサービス/更新シーケンスを試すことが物理的に可能。実装が残っているかは未確認。

またメルカリでは同型番を `DP-850SH / DP-1020SH` 対応として販売している個体が複数見つかった。中古出品者の記載であり公式互換表ではないため確定扱いにはしないが、DP-700SHでの直接確認と合わせると、3機種が同じリモコンを共有した可能性は高い。

出典:
- https://jp.mercari.com/item/m93734607492
- https://jp.mercari.com/item/m53512993273

さらに `RRMCG` という型番接頭辞を逆引きすると、SHARPの旧製品マニュアル/サービス資料に `RRMCG1392CESA`, `RRMCG1327CESA`, `RRMCG0033TASA` など多数の例がある。したがって `RRMCG...` はSHARPのリモコン部品番号体系として長年使われている。

出典:
- https://sharp.manymanuals.com/data-projectors/xg-e3500u/instruction-manual-16837/37
- https://manualzilla.com/doc/7351006/sharp-pg-d100u-instruction-manual
- https://manualzz.com/doc/736350/sharp-s50a2vl-fd1u-camcorder-service-manual

**評価:** FUJIFILM表記の `RRMCG2009SCZZ` がSHARP系の部品番号体系に乗っていることは、SharpがDPシリーズのリモコン設計/部品調達にも関与した可能性を補強する。ただし、このリモコンの製造者自体をSHARPと断定できる一次資料はまだない。

これによりSharp 13-bit系を優先している現在の総当たり方針には追加の状況証拠が得られた。ただし、`RRMCG` 接頭辞から赤外線プロトコルまでSharp方式と断定することはできない。

### ファームウェア

- DP-1020SH / DP-850SH / DP-700SH 共通の2010-04-30更新ページは特定済みだが、通常Web検索では更新ファイル本体・ファイル名をまだ回収できていない。
- `.bin`, `.ver`, `.dat`, `FPUPDATE`, 旧ページパス等で検索したが決め手なし。
- FUJIFILMのカメラ系では `FPUPDATE.DAT` / `FWUPxxxx.DAT` の命名例があるが、DPシリーズが同じ方式だったという証拠はない。
- Impressの記事から旧公式ダウンロードURLへのリンク自体は現在も辿れるが、富士フイルム側の実体は消失しており通常取得できない。
- 後継 DP-701SH / DP-801SH は2011-07-29に共通ファームウェア Ver.1.04.07 が公開された。
- 価格.comの実機報告では2011-12-17購入のDP-801SHに **Ver.1.05.01** が入っていた。公開版1.04.07より新しい工場/修理向けビルドが存在した可能性が高い。
- DP-70SH Ver.1.04.00 と DP-701SH/801SH Ver.1.04.07 のファイル名を検索したが、記事本文から先の実バイナリ名はまだ回収できていない。
- Wayback/CDXを直接叩く試みは、この実行環境ではWeb安全制限およびコンテナDNS失敗に阻まれた。検索エンジン経由の保存ページ/ミラー探索を継続する。

### 同じ開発者からの迂回調査

公開LinkedInのプロジェクト履歴に以下が連続している。

1. 2008-04〜2008-10: `Digital PhotoFrame - Electronic photo Album`, Customer: Jablotron
2. 2009-03〜2009-09: `Story Book inColor`, Customer: AIPTEK
3. 2009-10〜2010-02: `Digital Photo Frame - FUJIFILM DP-850SH/DP-1020SH`, Customer: Sharp

出典:
- https://tw.linkedin.com/in/%E7%92%A7%E7%B6%AD-dusty-shyr-%E7%9F%B3-a6ab8a5b

この並びは同一の台湾側ソフトウェア開発チーム/ODMが複数顧客向けにデジタルフォト製品を開発していた可能性を示す。ただし会社名は公開プロフィールから取れていない。

#### 学術資料から `Bih-Wei Shyr` 表記を確認

国立陽明交通大学（旧・国立交通大学）の機関リポジトリで、1998年の修士論文 `影像序列中網型物件之建立與追蹤` の著者が **石璧維 / Bih-Wei Shyr** と登録されている。2000年のSPIE論文でも `Bih Wei Shyr` として確認できた。

出典:
- https://ir.lib.nycu.edu.tw/handle/11536/64322
- https://scholar.nycu.edu.tw/en/publications/generation-and-tracking-of-mesh-objects-in-image-sequences/
- https://tw.linkedin.com/in/%E7%92%A7%E7%B6%AD-dusty-shyr-%E7%9F%B3-a6ab8a5b

LinkedInの `石璧維 (Dusty Shyr)` はNCTU EE卒であり、漢字氏名・大学・時期が整合する。したがって同一人物とみてよい。修士研究は特徴点抽出、階層メッシュ、動画像中の物体追跡・動き推定など画像処理分野。

**探索上の意味:** 今後は `Dusty Shyr` のほか `Bih-Wei Shyr`, `Bih Wei Shyr`, `Shyr BW` でも旧職歴・特許・技術資料を横断できる。今回これらの表記で特許・勤務先を検索したが、2008〜2010年の受託会社を直接示す資料はまだ見つからなかった。

#### `新帝` は当時の受託会社名ではない

Dusty Shyr氏の現在所属として表示される `新帝` は **SanDisk（新帝科技 / SanDisk Corporation）**。LinkedInのSanDisk求人が会社名を `新帝` と表示し、2010年の台湾業界資料でも `新帝科技（SanDisk Corporation）` と明記されている。

出典:
- https://tw.linkedin.com/jobs/view/technologist-engineer-firmware-engineering-at-sandisk-4396560497
- https://seminar.trendforce.com/Compuforum/2010/TW/sponsors

したがって、プロフィール上部の `新帝` を2008〜2010年のJablotron / AIPTEK / Sharp案件を担当した会社名と読むのは誤り。これは**現在所属の表示**であり、未特定の台湾側受託開発会社の探索とは切り離す。

### Sharp関与についての確定度整理

- **確定**: DP-700SH/850SH/1020SHの液晶パネルはSharp製。
- **確定**: DP-850SH/1020SHの開発案件がLinkedIn上で `Customer: Sharp` と記録されている。
- **実機で確認済み**: DP-700SHで使っているACアダプターにSHARP表記がある。
- **確認済み**: DP-700SHの付属ACアダプターは販売記録で `EP-D72F`。Sofmap中古品ページでは `ACアダプター(EP-D72F)` と明記。別流通では `SHARP ACアダプター EP-D72F` と明記され、5V 2A/10W、約4.0×1.7mmの仕様で扱われる。
- **新規確認**: DP-700SHの純正リモコンは `RRMCG2009SCZZ`。この `RRMCG` 接頭辞はSHARPのリモコン部品番号体系で広く使われる。
- **未確定**: DP-700SH本体のメイン基板、SoC、OS、全体設計がSharp製/OEMであること。

ACアダプター出典:
- https://used.sofmap.com/r/item/2133006495537
- https://paypayfleamarket.yahoo.co.jp/item/e1186028374
- https://www.ebay.co.uk/b/bn_616753

液晶・電源・リモコン部品番号・Sharp顧客案件という複数の独立した痕跡が揃ってきた。ただし、それぞれをまとめて「本体全体がSharp設計」と断定しない。

#### 2011世代ではSharpとの共同開発が明記

2011年2月のデジカメ Watch発表会記事では、後継のDP-701SH / DP-801SHが **「シャープと共同開発した24ビット表示が可能な『クリスタルフォト液晶』」を搭載** と明記されている。

出典:
- https://dc.watch.impress.co.jp/docs/news/425705.html
- FUJIFILMプレス向け画像ページ: https://www.fujifilm.co.jp/press/ffnr0485.html

これは少なくとも2011世代で、Sharpの関与が単なるパネル供給ではなく表示系の共同開発まで及んだことを示す。2010世代へそのまま遡及はできないが、DP-700SH/850SH/1020SHで確認済みのSharp製液晶、`Customer: Sharp`、Sharp製ACアダプター、Sharp系 `RRMCG` 部品番号との連続性は強まった。

### Jablotron ALBUM が重要な比較対象

Jablotronの製品一覧に `ALBUM` という Digital Photo Frame が実在し、現在も公式ダウンロードページが残る。

公式ページ:
- https://www.jablotron.com/en/support/downloads/alarms/software

確認できたもの:
- Latest ALBUM firmware version 1.15: 約4.2 MB
- User manual: 約893.7 kB
- 現行ページのfirmwareリンク先URLは `https://www.jablotron.com/file/edee/ke-stazeni/software/albumq42008_en.zip`
- 現行サイトではZIP扱いだが、Jablotron旧サイトの公開複製では同じ更新を **`FWI (4 MB)`** と明記している。

旧サイト複製:
- https://jablotron.com.cov04.vas-server.cz/en/about-jablotron/downloads/?level1=2598
- https://www.jablotron.com.cov04.vas-server.cz/fi/tietoja-jablotronista/ladattavat-kohteet/?level1=2823

このため、`albumq42008_en.zip` は配布用コンテナで、内部または旧配布形態の実更新ファイルは `.fwi` だった可能性が高い。これは ALBUM の情報であり、DP-700SH が `.fwi` を使う証拠ではない。

ALBUM取扱説明書から:
- SD/MMC
- USB Host（デジカメ/USBメモリ/別のALBUM）
- PC接続用USB Device
- PTP対応デジカメ
- 内蔵バッテリー
- JPEG管理/縮小
- 本体画面にFWバージョン表示
などを持つ。

同じ開発担当者が翌年のAIPTEK Story Book、さらにその直後のSharp向けFUJIFILM DP-850SH/1020SHを担当しているため、ALBUMファームを取得・比較できれば、RTOS/SoC/ライブラリ/更新形式の系譜を探る有力な比較資料になる。

現時点ではfirmware URLは判明したが、こちらの実行環境からバイナリ本体の取得には成功していない。現行URLへの直接取得は失敗し、検索エンジンにもファイル名 `albumq42008_en.zip` のミラーは見つからなかった。次は旧サイト複製のリンク先またはInternet Archiveから `.fwi` の実ファイル名を逆引きする。

### ALBUMteamの正体を整理

ALBUMの取扱説明書には `Program © 2008 ALBUMteam Ltd.` とあり、会社名を確認できた。

追加調査では:
- ALBUMteam Ltd. は2008年にチェコのデザイナー Dominika Nell Applová と Jablotron創業者 Dalibor Dědek が設立。
- 2010年の公式プレスリリースでは本社San Francisco、チェコにも拠点。ALBUM/ALBUM2は米国・チェコで設計、台湾・中国で生産と説明されている。
- 当時のチェコ報道ではALBUMteamはJablotron holdingの新しい子会社/グループ企業として扱われている。

したがって **ALBUMteam = 台湾ODM** という仮説は棄却。台湾側のDusty Shyrの所属会社は別に存在した可能性が高い。

参考:
- https://www.prnewswire.com/news-releases/albumteam-named-as-ces-innovations-2010-design--engineering-award-honoree-80907592.html
- https://www.finance.cz/clanky/217833-jablotron-navzdory-krizi-zvysil-trzby-o-petinu-na-1-2-miliardy-kc/

### Prosoyo Technologyという製造側候補

2009年前後のJablotronについての当時報道から、中国のEMS企業 **Prosoyo Technology** との非常に深い関係が判明。

- Jablotronグループは量産の多くを外注。
- 2009年報道ではProsoyoがJablotron生産の約45%を担ったとされる。
- 別報道ではJablotronが中国生産へ移行する過程でProsoyoへ人員を送り込み品質/生産を管理し、資本関係も深めたとされる。
- 2009年5月にはチェコ法人 `JABLOTRON PCB Assembly s.r.o.` の出資者としてProsoyo Technology Limitedが登記された記録もある。
- Prosoyoは現在もDongguan工場/Hong Kong拠点を持ち、製品設計、PCB実装、完成品組立、MCU/Memory/PLD programmingまで掲げるEMS企業。

参考:
- https://www.finance.cz/clanky/217833-jablotron-navzdory-krizi-zvysil-trzby-o-petinu-na-1-2-miliardy-kc/
- https://www.euro.cz/clanky/jak-vydelavat-v-cine-894445/
- https://www.prosoyoems.com/

ただし **ALBUMをProsoyoが製造した直接証拠はまだない**。FUJIFILM/Sharp案件との接点も未確認。現時点ではサプライチェーン逆引き用の候補。

### AIPTEK Story Book inColor

同じ担当者の2009年案件。8インチ 800x600、USB、SD/SDHC/MMC/MS Pro、JPEG/MP3などを持つカラー電子書籍/フォトフレーム兼用機。

参考:
- https://wiki.mobileread.com/wiki/Aiptek_Story_Book
- https://www.taipeitimes.com/News/feat/archives/2009/12/27/2003461987

追加で、USB 2.0 host/slave、5V 2A電源という構成も確認。DP-700SH系と機能上の重なりはあるが、SoC共通を示す証拠はまだない。

FCC ID / teardown / processor名を検索したが、現時点ではStory Book inColorそのものの基板・SoC情報は見つからなかった。

### AIPTEKの「研発・製造」と `Customer: AIPTEK` の食い違い

2009年前後の台湾資料で、Story Book inColorについて「天瀚科技（AIPTEK）が研発・製造」と明記された記述を確認した。

参考:
- https://9lib.co/document/rz32k9eq-Aiptek%E5%BD%A9%E8%89%B2%E5%85%92%E7%AB%A5%E9%9B%BB%E5%AD%90%E6%9B%B8%E9%80%B2%E8%BB%8D%E6%96%B0%E5%8A%A0%E5%9D%A1%E5%B8%82%E5%A0%B4.html
- https://www.ithome.com.tw/news/58275
- https://tw.linkedin.com/in/%E7%92%A7%E7%B6%AD-dusty-shyr-%E7%9F%B3-a6ab8a5b

一方、Dusty Shyr氏のプロジェクト履歴では同製品の顧客が `Customer: AIPTEK`。このため「Dusty氏がAIPTEK社員として自社製品を開発した」とみなすより、AIPTEKが製品全体の開発・製造主体でありつつ、Dusty氏の所属会社へソフトウェア/システム開発を外注したと読む方が自然。

これにより、2008〜2010年の3案件を結ぶ **未特定の台湾系受託開発会社** の存在仮説が強まった。

- Jablotron: Customer
- AIPTEK: Customer
- Sharp: Customer

同一人物が短期間に3社の案件を連続担当しており、特にStory BookではProject / SW Managerを担当。会社名はまだ未特定。

SoCベンダー候補（Sunplus / MagicPixel / Actions / MStar等）と人物名の組み合わせ検索も行ったが、直接の所属証拠は得られなかった。検索結果はLinkedIn本人ページへ収束した。

### DP-700SH/850SH/1020SH世代の共通基盤について

- 3機種は同じ2010-04-30ファーム更新を受け、修正対象もIrSimple/IrSS/IrDA通信スタックで共通。
- DP-700SHは上位機から動画/音声再生を削ったモデルで、画像管理・赤外線・USB・メディア処理などは共通機能が多い。
- `RRMCG2009SCZZ` がDP-700SHで直接確認され、DP-850SH/1020SH向けとしても中古流通しているため、UI/リモコン入力層も3機種で共通だった可能性が高まった。
- したがって、少なくともアプリケーション/ミドルウェアのかなりの部分を共有していた可能性が高い。これは推測であり、基板共通までは未証明。
- DP-1020SHの2010年レビューには本体が `Made in China` だったとの実機報告がある。Sharp顧客案件 + 中国製造 + 台湾側開発というサプライチェーン像と整合するが、ODM名は依然不明。

### その他

- `EP-D72F` はDP-700SH内部型番ではなくSHARP ACアダプター型番。SofmapのDP-700SH中古品記録でも標準付属品として `ACアダプター(EP-D72F)` と明記される。
- DP-1020SHは発売時に一部個体の電源接続部不具合で全数検査・発売延期があった。
- DP-1020SH実利用例ではminiUSB経由の大量一括転送中にフリーズした報告あり。
- DP-700SH/850SH/1020SHは共通のIrSimple/IrSS/IrDA修正ファームを受けており、700SHだけ動画/音声機能を省いている。共通ソフト基盤 + 機種別機能構成だった可能性がある（推測）。

### 次の探索

- Jablotron `albumq42008_en.zip` の取得またはミラー発掘
- 旧Jablotronサイト複製から `.fwi` の実ファイル名・直リンクを回収
- ALBUM / ALBUM2 のFCC・内部写真・基板/SoC情報を探索
- AIPTEK Story Book inColor の基板情報からSoCを特定
- 台湾側開発者の当時の所属企業を `Dusty Shyr` / `Bih-Wei Shyr` / `Bih Wei Shyr` / `Shyr BW` とJablotron/AIPTEK/Sharpの3案件から逆引き
- ProsoyoとALBUMteamまたは台湾開発チームの具体的接点を確認
- `RRMCG2009SCZZ` の赤外線波形/コードを探索
- SHARP `RRMCG` 系リモコンの既知プロトコルを型番横断で調べ、総当たり範囲を絞る
- 旧FUJIFILM更新ページのInternet Archive保存物からダウンロードhrefを回収
- DP-701SH/801SHの公開Ver.1.04.07のファイル名を回収し、2010世代の命名規則を推定
- 実機で `本体情報→バージョン表示→拡大→縮小→時計→回転` を試す

## 2026-08-21

### DP-70SHに少なくとも2回目の公開ファーム更新が存在

デジカメ Watchの2009年バックナンバーから、DP-70SHについて **2009-09-18にも「最新ファームウェア」公開記事が存在した** ことを確認した。

既知の2009-03-31更新はVer.1.04.00で、SDカードへファームを置き、「本体情報→バージョン表示」中に `拡大 → 縮小 → 時計 → 回転` と押して書き換え画面へ入る方式だった。

出典:
- https://dc.watch.impress.co.jp/docs/news/index2009.html
- https://dc.watch.impress.co.jp/docs/news/20090918_316738.html
- https://dc.watch.impress.co.jp/cda/accessories/2009/04/01/10602.html

**確定:** DP-70SHの公開ファーム更新は、確認できた範囲で少なくとも2009-03-31と2009-09-18の2回存在した。

**未回収:** 2009-09-18版のバージョン番号、変更内容、実ファイル名、バイナリ、更新手順本文。

**推測:** 2009年3月に確認できる隠し更新画面/SD更新機構が9月版でも継続利用された可能性は高い。ただし9月版の本文をまだ回収できていないため、同じ更新手順だったことは確定しない。DP-700SHに同じ機構が継承されたかも引き続き未確認。

今回、DP-700SH/850SH/1020SHの2010年ファーム実体・ファイル名、SoC/OS/基板写真、`RRMCG2009SCZZ` の赤外線コード、台湾側受託会社名については新しい確証を得られなかった。