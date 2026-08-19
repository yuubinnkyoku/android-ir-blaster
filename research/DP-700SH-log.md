# DP-700SH 調査ログ

## 2026-08-20

### 保存方針

- 要点・確定事項は `research/DP-700SH.md` に集約する。
- このファイルには探索経路、外れた仮説、比較対象なども含めて時系列で残す。

### 赤外線

- `android-ir-blaster` の Sharp 無接頭辞総当たりは、UI上の16bit空間（65,536）とは別に内部カーソルを13bitへ正規化しているため、固有波形は8,192通り。
- 主要な Flipper Zero 公開IRデータベース `Lucaslhm/Flipper-IRDB` の `Picture_Frames` を確認したが、現時点では Micca / Nixplay / Pandigital のみで FUJIFILM / SHARP フォトフレームの登録は見つからなかった。
- GitHubコード検索でも `DP-700SH` と候補リモコン型番 `RRMCG2009SCZZ` の既知IRデータは見つからなかった。
- `RRMCG2009SCZZ` は FUJIFILM DIGITAL PHOTO FRAME 用リモコンとして中古流通記録があるが、DP-700SHへの対応は未確定。
- 2026-08-20時点でメルカリに `RRMCG2009SCZZ` 単品が少なくとも3件残っており、1件は499円。型番自体の実在性は十分高いが、出品タイトルには対応機種が明記されていない。
- Yahoo!フリマの過去出品では `RRMCG2009SCZZ` の全ボタン赤外線動作確認済みという記録がある。

### ファームウェア

- DP-1020SH / DP-850SH / DP-700SH 共通の2010-04-30更新ページは特定済みだが、通常Web検索では更新ファイル本体・ファイル名をまだ回収できていない。
- `.bin`, `.ver`, `.dat`, `FPUPDATE`, 旧ページパス等で検索したが決め手なし。
- FUJIFILMのカメラ系では `FPUPDATE.DAT` / `FWUPxxxx.DAT` の命名例があるが、DPシリーズが同じ方式だったという証拠はない。
- Impressの記事から旧公式ダウンロードURLへのリンク自体は現在も辿れるが、富士フイルム側の実体は消失しており通常取得できない。
- 後継 DP-701SH / DP-801SH は2011-07-29に共通ファームウェア Ver.1.04.07 が公開された。
- 価格.comの実機報告では2011-12-17購入のDP-801SHに **Ver.1.05.01** が入っていた。公開版1.04.07より新しい工場/修理向けビルドが存在した可能性が高い。

### 同じ開発者からの迂回調査

公開LinkedInのプロジェクト履歴に以下が連続している。

1. 2008-04〜2008-10: `Digital PhotoFrame - Electronic photo Album`, Customer: Jablotron
2. 2009-03〜2009-09: `Story Book inColor`, Customer: AIPTEK
3. 2009-10〜2010-02: `Digital Photo Frame - FUJIFILM DP-850SH/DP-1020SH`, Customer: Sharp

出典:
- https://tw.linkedin.com/in/%E7%92%A7%E7%B6%AD-dusty-shyr-%E7%9F%B3-a6ab8a5b

この並びは同一の台湾側ソフトウェア開発チーム/ODMが複数顧客向けにデジタルフォト製品を開発していた可能性を示す。ただし会社名は公開プロフィールから取れていない。

### Sharp関与についての確定度整理

- **確定**: DP-700SH/850SH/1020SHの液晶パネルはSharp製。
- **確定**: DP-850SH/1020SHの開発案件がLinkedIn上で `Customer: Sharp` と記録されている。
- **実機で確認済み**: DP-700SHで使っているACアダプターにSHARP表記がある。
- **未確定**: DP-700SH本体のメイン基板、SoC、OS、全体設計がSharp製/OEMであること。

以前の調査メモで「本体の製造元SHARP」と強く書きすぎていた箇所は、上記の確定度に修正する。

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

### AIPTEK Story Book inColor

同じ担当者の2009年案件。8インチ 800x600、USB、SD/SDHC/MMC/MS Pro、JPEG/MP3などを持つカラー電子書籍/フォトフレーム兼用機。

参考:
- https://wiki.mobileread.com/wiki/Aiptek_Story_Book
- https://www.taipeitimes.com/News/feat/archives/2009/12/27/2003461987

追加で、USB 2.0 host/slave、5V 2A電源という構成も確認。DP-700SH系と機能上の重なりはあるが、SoC共通を示す証拠はまだない。

FCC ID / teardown / processor名を検索したが、現時点ではStory Book inColorそのものの基板・SoC情報は見つからなかった。

### DP-700SH/850SH/1020SH世代の共通基盤について

- 3機種は同じ2010-04-30ファーム更新を受け、修正対象もIrSimple/IrSS/IrDA通信スタックで共通。
- DP-700SHは上位機から動画/音声再生を削ったモデルで、画像管理・赤外線・USB・メディア処理などは共通機能が多い。
- したがって、少なくともアプリケーション/ミドルウェアのかなりの部分を共有していた可能性が高い。これは推測であり、基板共通までは未証明。
- DP-1020SHの2010年レビューには本体が `Made in China` だったとの実機報告がある。Sharp顧客案件 + 中国製造 + 台湾側開発というサプライチェーン像と整合するが、ODM名は依然不明。

### その他

- `EP-D72F` はDP-700SH内部型番ではなくSHARP ACアダプター型番だったため、SoC探索キーから除外。
- DP-1020SHは発売時に一部個体の電源接続部不具合で全数検査・発売延期があった。
- DP-1020SH実利用例ではminiUSB経由の大量一括転送中にフリーズした報告あり。
- DP-700SH/850SH/1020SHは共通のIrSimple/IrSS/IrDA修正ファームを受けており、700SHだけ動画/音声機能を省いている。共通ソフト基盤 + 機種別機能構成だった可能性がある（推測）。

### 次の探索

- Jablotron `albumq42008_en.zip` の取得またはミラー発掘
- 旧Jablotronサイト複製から `.fwi` の実ファイル名・直リンクを回収
- ALBUMの基板/SoC/ファーム解析記事を探索
- AIPTEK Story Book inColor の基板情報からSoCを特定
- 台湾側開発者の当時の所属企業を、Jablotron ALBUMとAIPTEK案件から逆引き
- DP-700SH専用リモコンの裏面部品番号を中古画像から確定
- `RRMCG2009SCZZ` の前面ボタン配置をDP-700SH取説の純正リモコンと比較
- 旧FUJIFILM更新ページのInternet Archive保存物からダウンロードhrefを回収
- DP-701SH/801SHの公開Ver.1.04.07のファイル名を回収し、2010世代の命名規則を推定
