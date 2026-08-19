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

### ファームウェア

- DP-1020SH / DP-850SH / DP-700SH 共通の2010-04-30更新ページは特定済みだが、通常Web検索では更新ファイル本体・ファイル名をまだ回収できていない。
- `.bin`, `.ver`, `.dat`, `FPUPDATE`, 旧ページパス等で検索したが決め手なし。
- FUJIFILMのカメラ系では `FPUPDATE.DAT` / `FWUPxxxx.DAT` の命名例があるが、DPシリーズが同じ方式だったという証拠はない。

### 同じ開発者からの迂回調査

公開LinkedInのプロジェクト履歴に以下が連続している。

1. 2008-04〜2008-10: `Digital PhotoFrame - Electronic photo Album`, Customer: Jablotron
2. 2009-03〜2009-09: `Story Book inColor`, Customer: AIPTEK
3. 2009-10〜2010-02: `Digital Photo Frame - FUJIFILM DP-850SH/DP-1020SH`, Customer: Sharp

出典:
- https://tw.linkedin.com/in/%E7%92%A7%E7%B6%AD-dusty-shyr-%E7%9F%B3-a6ab8a5b

この並びは同一の台湾側ソフトウェア開発チーム/ODMが複数顧客向けにデジタルフォト製品を開発していた可能性を示す。ただし会社名は公開プロフィールから取れていない。

### Jablotron ALBUM が重要な比較対象

Jablotronの製品一覧に `ALBUM` という Digital Photo Frame が実在し、現在も公式ダウンロードページが残る。

公式ページ:
- https://www.jablotron.com/en/support/downloads/alarms/software/album

確認できたもの:
- Latest ALBUM firmware version 1.15: 約4.2 MB
- User manual: 約893.7 kB
- 現行ページのfirmwareリンク先URLは `https://www.jablotron.com/file/edee/ke-stazeni/software/albumq42008_en.zip`

旧Jablotronサイトの検索インデックスでは同じ更新を `FWI (4 MB)` と表示する記録もある。

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

現時点ではfirmware URLは判明したが、こちらの実行環境からバイナリ本体の取得には成功していない。

### AIPTEK Story Book inColor

同じ担当者の2009年案件。8インチ 800x600、USB、SD/SDHC/MMC/MS Pro、JPEG/MP3などを持つカラー電子書籍/フォトフレーム兼用機。

参考:
- https://wiki.mobileread.com/wiki/Aiptek_Story_Book
- https://www.taipeitimes.com/News/feat/archives/2009/12/27/2003461987

台湾の学術資料ではAIPTEK（天瀚科技）自身の製品としてStory Book inColorが紹介されている。これだけではODM名は特定できない。

### その他

- `EP-D72F` はDP-700SH内部型番ではなくSHARP ACアダプター型番だったため、SoC探索キーから除外。
- DP-1020SHは発売時に一部個体の電源接続部不具合で全数検査・発売延期があった。
- DP-1020SH実利用例ではminiUSB経由の大量一括転送中にフリーズした報告あり。
- DP-700SH/850SH/1020SHは共通のIrSimple/IrSS/IrDA修正ファームを受けており、700SHだけ動画/音声機能を省いている。共通ソフト基盤 + 機種別機能構成だった可能性がある（推測）。

### 次の探索

- Jablotron `albumq42008_en.zip` の取得またはミラー発掘
- ALBUMの基板/SoC/ファーム解析記事を探索
- AIPTEK Story Book inColor のFCC/分解/基板情報からSoCを特定
- 台湾側開発者の当時の所属企業を、Jablotron ALBUMとAIPTEK案件から逆引き
- DP-700SH専用リモコンの裏面部品番号を中古画像から確定
- 旧FUJIFILM更新ページのInternet Archive保存物からダウンロードhrefを回収
