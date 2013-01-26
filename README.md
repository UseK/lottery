lottery
=======

Ruby, Mechanizeを使ったテニスコート予約自動化スクリプト
IDに関する個人情報は伏せるためにinput、outputのディレクトリは管理対象外にしてあります

使い方
--------

### 抽選予約(１日から７日まで) ###
再来月の抽選予約を行う．


### 意思確認(第３週の水曜日から月末まで) ###
抽選予約で当選した日程に対して実際に使いたいテニスコートの面数だけ意思確認を行う．
これを行わない場合，来月にその抽選結果は無効となるので注意．


$ ruby bin/show_intent.rb

でoutput/intent.txtに抽選結果が  
input/intent.txtにそれを日付でソートしたものが生成される  
input/intent.txtを編集して意思確認したい日程の行だけを残す  
(意思確認したくないものはその行を消す)  
input/intent.txtへ上書きしてもかまわないが、別名で保存した方がヒューマンエラーしにくい
ここではinput/intent_verify.txtに別名で保存したとして

$ ruby bin/verify_intent.rb input/intent_verify.txt

で意思確認処理を行う  
再び

$ ruby bin/show_intent.rb

で意思確認を行ったものに対しては「未」が「予約済み」となっている事を確認する．


