#!/usr/bin/env bash

export DEBIAN_FRONTEND=noninteractive

function CreatePgUser() {
cat << EOF | sudo su - postgres -c psql
-- Create the database user:
CREATE USER $2 WITH PASSWORD '$3';

-- Create the database:
CREATE DATABASE $1 WITH OWNER=$2
                                  LC_COLLATE='en_US.utf8'
                                  LC_CTYPE='en_US.utf8'
                                  ENCODING='UTF8'
                                  TEMPLATE=template0;
EOF
}

sudo apt-get -y update
sudo apt-get -y install build-essential git-core libyaml-dev libxml2 libxml2-dev libxslt1-dev nodejs zsh
sudo apt-get -y install postgresql postgresql-contrib postgresql-client libpq-dev postgresql-server-dev-9.3

# Setup Postgres
sudo sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" /etc/postgresql/9.3/main/postgresql.conf
sudo sudo su - postgres -c 'echo "host     all             all             all                     md5" >> /etc/postgresql/9.3/main/pg_hba.conf'
sudo sudo su - postgres -c 'echo "client_encoding = utf8" >> /etc/postgresql/9.3/main/postgresql.conf'
sudo service postgresql restart
CreatePgUser 'schnitzelpress_dev' 'schnitzel_dev' 'schnitzel'
CreatePgUser 'schnitzelpress_test' 'schnitzel_test' 'schnitzel'

cd

/usr/bin/zsh <<'EOF'
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
sudo chsh -s /bin/zsh vagrant
EOF

wget -O ruby-install-0.5.0.tar.gz https://github.com/postmodern/ruby-install/archive/v0.5.0.tar.gz
tar -xzvf ruby-install-0.5.0.tar.gz
cd ruby-install-0.5.0/
sudo make install

wget -O chruby-0.3.9.tar.gz https://github.com/postmodern/chruby/archive/v0.3.9.tar.gz
tar -xzvf chruby-0.3.9.tar.gz
cd chruby-0.3.9/
sudo make install

cat <<EOF >> ~/.zshrc

source /usr/local/share/chruby/chruby.sh
chruby ruby-2.1.6
EOF

ruby-install ruby 2.1.6

source /usr/local/share/chruby/chruby.sh

cd /schnitzelpress

chruby ruby-2.1.6

gem install bundler --no-rdoc --no-ri
bundle install
