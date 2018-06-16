# SyllabusPlus
同志社大学の学生のための履修支援サービス  

## Web site
~~http://syllabusplus.info~~  
https://syllabusplus.herokuapp.com/


## Ruby version  
2.2

## Usage  
```
$ bundle install
$ bundle exec rails s
```

## BatchUsage
```
$ bundle exec rails runner lib/tasks/retrieval_data_from_original_site.rb 収集したい年度(e.g., 2016) # 指定した年度の成績評価基準を集める
$ bundle exec rails runner lib/tasks/update_mean_scores_table.rb # 科目ごとの平均点をアップデートする
$ bundle exec rails runner lib/tasks/update_summarized_subjects.rb シラバス参照年度(e.g., 2017) # 指定した年度のシラバスが存在する科目で表示用の集計済みテーブルを作り直す
```

### Update Heroku Database
```
# Dump from heroku
# hostname, username, dbname and password is from heroku config
$ mysqldump -h [hostname] -u [username] -p [dbname] > dump.sql
> password
# Update data using batch scripts
$ mysqldump -u root syllabus_plus_development > dump_new.sql
# Insert to heroku
# Remove clearDB add-on and re-install it.
# Re-set DATABASE_URL config
$ heroku config:set DATABASE_URL="mysql2://~~"
$ mysql -u [username] -h [hostname] -p [dbname] < dump_new.sql
> password
```

## Setup Memo
- AWSのEC2をたててからすること

```
export APPNAME="syllabus_plus"
sudo adduser $APPNAME
sudo gpasswd -a $APPNAME sudo

## ssh-authorizedの設定
cat ~/.ssh/syllabus_plus_rsa.pub | pbcopy # at local
su syllabus_plus
cd
mkdir .ssh
vim ~/.ssh/authorized_keys # copyしたやつをペーストする
export MYSQL_PASS={適当なパスワード：使わない}
# .envをローカルからコピー or 設定
# setup-server.shをコピー
sh setup-server.sh
```
