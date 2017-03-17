# SyllabusPlus
同志社大学の学生のための履修支援サービス  

## Web site
http://syllabusplus.info


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
- バッチの問題点  
Duetリプレイスにより，科目名の表記，科目コードの表記が変更された．  
この影響により，科目が正しく結び付けれていないものが存在する．（諦めた）  
（メモ：コードは変わらないつもりでいたので，仕方なく正規化した科目名で紐付けている．正規化は`lib/tasks/update_subject_name.ipynb`を参照）  
