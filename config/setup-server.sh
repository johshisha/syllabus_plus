sudo userdel ubuntu
sudo mkdir /var/www
cd /var/
sudo chown syllabus_plus www 
cd

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:nginx/stable -y
sudo apt-get update
sudo apt-get install nginx -y
sudo apt-get install git -y
sudo add-apt-repository -y ppa:brightbox/ruby-ng
sudo apt-get update
sudo apt-get install ruby2.2  ruby-dev ruby2.2-dev gcc build-essential libmysqlclient-dev libssl-dev libreadline-dev -y

echo "mysql-server-5.7 mysql-server/root_password password $MYSQL_PASS" | debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password_again password $MYSQL_PASS" | debconf-set-selections
sudo apt-get install mysql-server-5.7 -y
timedatectl set-timezone Asia/Tokyo

git clone https://github.com/sstephenson/rbenv.git /home/syllabus_plus/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/syllabus_plus/.bashrc
echo 'eval "$(rbenv init -)"' >> /home/syllabus_plus/.bashrc
echo 'export RAILS_ENV=production' >> /home/syllabus_plus/.bashrc
. /home/syllabus_plus/.bashrc
git clone https://github.com/sstephenson/ruby-build.git /home/syllabus_plus/.rbenv/plugins/ruby-build
/home/syllabus_plus/.rbenv/bin/rbenv rehash
/home/syllabus_plus/.rbenv/bin/rbenv install 2.2.2
/home/syllabus_plus/.rbenv/bin/rbenv global 2.2.2
/home/syllabus_plus/.rbenv/bin/rbenv rehash
. /home/syllabus_plus/.bashrc

cd /var/www
git clone --bare https://github.com/johshisha/syllabus_plus.git
git clone syllabus_plus.git
cd syllabus_plus

sudo cp ./config/nginx.conf /etc/nginx/conf.d/syllabus_plus.conf
sudo service nginx start
sudo update-rc.d nginx defaults # 自動起動設定

cp ~/.env ./.env

mkdir -p shared/tmp/pids
gem install bundler
bundle install --path=vendor/bundle --without development test
bundle exec unicorn_rails -c config/unicorn/production.rb -p 8080 -D -E production
bundle exec rake db:migrate RAILS_ENV=production
bundle exec rake assets:precompile RAILS_ENV=production
sudo service nginx restart
