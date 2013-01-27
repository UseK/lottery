lottery
=======

Ruby, Mechanizeを使ったテニスコート抽選予約自動化スクリプト

使い方
--------

### 事前準備 ###
input/account.csvに会員情報を書き込む．
input/account_sample.csvを参考にする．

input/account_sample.csv  
id,pass,name,nth_sat,opening_time  
11111111,1111,ペイジ,1st,15  
22222222,2222,ジョーンズ,1st,17  
33333333,3333,プラント,2nd,15  
12345678,1234,ボーンナム,2nd,17  

ここで  
idは会員番号である8桁の数字  
passはパスワードである4桁の数字  
nameは会員の名前  
nth_satは後述する抽選予約の土曜の日程の何番目を行うか  
(1stなら１番目，2ndなら２番目等）  
(テニスコートの規定上，１つのアカウントあたり土日，祝日は１日分しか抽選予約を行えない
平日は何日分でも行える)  
opening_timeは土曜の日程の開始時間  
(15なら１５時から１７時，17なら１７時から１９時)  
ただし，nth_sat, opening_timeは後述する抽選予約の処理  

$ ruby bin/regist_lottery.rb

で土曜の日程数に合わせ自動的に更新される．





### 抽選予約(１日から７日まで) ###
再来月の抽選予約を行う．

$ ruby bin/generate_lottery_date.rb

で
input/date_weekdays.txtに再来月の平日の月曜，水曜の一覧が
inpub/date_saturday.txtに再来月の平日の土曜の一覧が
保管される．  

出力例  
input/date_weekdays.txt  
2013/03/04  
2013/03/06  
2013/03/11  
2013/03/13  
2013/03/18  
2013/03/25  
2013/03/27  

inpub/date_saturday.txt  
2013/03/02  
2013/03/09  
2013/03/16  
2013/03/23  
2013/03/30  

これらのファイルを編集し，抽選予約を行う日程のみ残し，行わない日程は削除する．  
ファイルを編集した上で

$ ruby bin/regist_lottery.rb

で抽選予約が開始される．  
（会員情報，平日の日程，土曜の日程を表示した上で本当にこの日程で抽選予約が行われるかの
確認がくるので"yes"を入力する）  
input/date_weekdays.txtの全日程(１７時から１９時までで固定)を  
input/date_saturday.txtのいずれか１つの日程(opening_timeの時間帯)を  
アカウントごとに抽選予約の処理が行われる．  
会員数が多いと処理に時間がかかる，大体90人分で30分くらい．  

$ruby show_waiting_lottery.txt

で行った抽選予約の一覧を取得できる．  
結果はoutput/lottery.txt
に保管される．




### 意思確認(第３週の水曜日から月末まで) ###
抽選予約で当選した日程に対して実際に使いたいテニスコートの面数だけ意思確認を行う．
これを月末までに行わなかった場合，来月にその抽選結果は無効となるので注意．


$ ruby bin/show_intent.rb

でoutput/intent.txtに抽選結果が  
input/intent.txtにそれを日付でソートしたものが生成される  
input/intent.txtを編集して意思確認したい日程の行だけを残し，意思確認したくないものはその行を消す．  
ファイルを編集した上で

$ ruby bin/verify_intent.rb

で意思確認処理が行われる
再び

$ ruby bin/show_intent.rb

で意思確認を行ったものに対しては「未」が「予約承認済み」となっている事を確認する．


