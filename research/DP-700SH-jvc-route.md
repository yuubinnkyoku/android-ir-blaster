# DP-700SH IR調査: JVCルート

最終更新: 2026-08-20 JST

## 結論

Sharp 13-bit探索が空振りだった場合、巨大なKaseikyo全探索へ進む前に **JVC protocol / device 3** を試す価値が高い。

最初の単発候補:

- Protocol: `JVC`
- app入力: `0317`
- logical address/device: `0x03`
- logical command/OBC: `0x17` (= 23)
- carrier: 38 kHz

単発で反応しなければ:

- Protocol: `JVC`
- Known prefix: `03`
- brute force: 全組合せ
- 残り1 byteのみなので **256候補**

## 根拠1: FUJIFILM DP-7VがVictor/JVCテレビの電源リモコンに反応する実機報告

価格.comのDP-7Vクチコミに、2010-05-28付で「ビクター製のテレビのリモコンのON/OFFスイッチとかぶって」DP-7Vが反応するという実機報告がある。

Source:
- https://bbs.kakaku.com/bbs/K0000060109/

DP-7VはDP-700SHとは別機種・別系列なので、**これだけでDP-700SHがJVC protocolだとは言えない**。ただし同時期のFUJIFILMデジタルフォトフレームにJVC TVコードとの衝突例が実在するため、JVCを低コストで試す根拠になる。

## 根拠2: 古いJVC TVでdevice 3 / Power OBC 23が広く使われている

JP1 RemoteのJVC TVコード情報では、JVC protocolのdevice 3が主要TVコードとして使われ、Power toggleはOBC 23と記録されている。同じコード集合にはMute=28、Volume+=30、Volume-=31などがある。

Sources:
- https://www.hifi-remote.com/forums/viewtopic.php?t=5446
- https://www.hifi-remote.com/forums/viewtopic.php?t=14737
- https://hifi-remote.com/wiki/index.php/JVC

JVC wikiのIRP表記は `D:8,F:8` で、8-bit device + 8-bit functionの16-bit payload。

## appで `0317` になる理由

`lib/ir/protocols/jvc.dart` は4桁hexを2 byteに分け、各byteをLSB-firstで送信する。

したがってJVCの論理値:

- Device = 3 -> `03`
- Function/OBC = 23 decimal -> `17`

をそのままappへ `0317` と入力すればよい。

Source in repo:
- `lib/ir/protocols/jvc.dart`

古いLIRC設定では同じ信号がbit-reversed representationの `C0E8` として見える場合がある。**このappへ入力する値はC0E8ではなく0317**。この表現差を混同しないこと。

## device 31について

一部の古いJP1投稿にはJVC TVでdevice 31という言及があるが、同じスレッド内で専門家が「確認できない」と再検討しており、device 3を中心にdevice 15/35等の補助機能があるケースが示されている。

したがって現時点ではdevice 31を優先探索しない。

Source:
- https://www.hifi-remote.com/forums/viewtopic.php?t=6858

## 実機探索の優先順位（暫定更新）

1. 現在実行中の Sharp 13-bit / 8192候補
2. JVC `0317` を単発送信
3. JVC prefix `03` / 256候補
4. app内蔵IR DBのSHARP/FUJIFILM近縁候補
5. 既知の近縁機種コードをさらに収集
6. Kaseikyo Sharp vendor `5AAA` は、vendor以外の範囲を絞ってから探索

## 注意

DP-7VとDP-700SHが同じリモコンプロトコルを採用している証拠はまだない。このJVCルートは「256候補で検証できる、安価な仮説」として扱う。
