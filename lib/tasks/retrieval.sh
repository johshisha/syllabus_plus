for year in 2013 2014 2015 2016
do
  bundle exec rails runner lib/tasks/retrieval_data_from_original_site.rb $year
done

bundle exec rails runner lib/tasks/update_mean_scores_table.rb
bundle exec rails runner lib/tasks/update_summarized_subjects.rb
