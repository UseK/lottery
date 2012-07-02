lottery
=======

Ruby, Mechanizeを使ったテニスコード予約自動化スクリプト
IDに関する情報は伏せるためにinput、outputのディレクトリは管理対象外にしてあります

使い方
--------
意思確認(第3週の水曜日から月末)
>ruby show_intent.rb
でoutput/intent.txtに抽選結果が
input/intent.txtにそれを日付でソートしたものが生成される
input/intent.txtを編集して意思確認したい内容の行だけを残す
(意思確認したくないものはその行を消す)
上書きしてもかまわないが、別名で保存した方がヒューマンエラーしにくい
ここではinput/intent_verify.txtに別名で保存したとして
>ruby verify_intent.rb input/intent_verify.txt
で意思確認処理を行う
再び
>ruby show_intent.rb
で意思確認を行ったものに対しては「予約済み」が追加されているはず


