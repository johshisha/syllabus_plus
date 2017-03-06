sudo userdel ubuntu
sudo mkdir /var/www
cd /var/
sudo chown arxiv_reader www 
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

echo "mysql-server-5.7 mysql-server/root_password password $MYSQL_PASSWORD" | debconf-set-selections
echo "mysql-server-5.5 mysql-server/root_password_again password $MYSQL_PASSWORD" | debconf-set-selections
sudo apt-get install mysql-server-5.7 -y
timedatectl set-timezone Asia/Tokyo

git clone https://github.com/sstephenson/rbenv.git /home/arxiv_reader/.rbenv
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> /home/arxiv_reader/.bashrc
echo 'eval "$(rbenv init -)"' >> /home/arxiv_reader/.bashrc
echo 'export RAILS_ENV=production' >> /home/arxiv_reader/.bashrc
. /home/arxiv_reader/.bashrc
git clone https://github.com/sstephenson/ruby-build.git /home/arxiv_reader/.rbenv/plugins/ruby-build
/home/arxiv_reader/.rbenv/bin/rbenv rehash
/home/arxiv_reader/.rbenv/bin/rbenv install 2.2.2
/home/arxiv_reader/.rbenv/bin/rbenv global 2.2.2
/home/arxiv_reader/.rbenv/bin/rbenv rehash

cd /var/www
git clone --bare https://github.com/johshisha/arxiv_reader.git
git clone arxiv_reader.git
cd arxiv_reader

sudo cp ./config/nginx.conf /etc/nginx/conf.d/arxiv_reader.conf
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

