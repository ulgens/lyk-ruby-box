#!/bin/bash

# Disable system locale check
sudo touch /var/lib/cloud/instance/locale-check.skip

# Debian-Ubuntu package update
echo "Updating system packages ..."
sudo apt-get update -y
sudo apt-get dist-upgrade -y

# Git
echo "Installing Git, version control system ..."
sudo apt install -y git

# ZSH and Oh-My-ZSH
echo "Installing Zsh and oh-my-zsh..."
sudo apt-get install zsh -y
wget --no-check-certificate https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | sh
sudo chsh -s /bin/zsh ubuntu

# Extra components
echo "Installing extra dependencies..."
sudo apt install -y imagemagick libxslt1-dev libcurl4-openssl-dev libksba8 libksba-dev libreadline-dev zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libxml2-dev libxslt1-dev

## Rbenv
echo "Installing rbenv..."
if [[ ! -d "$HOME/.rbenv" ]]; then
    git clone https://github.com/sstephenson/rbenv.git ~/.rbenv

    if ! grep -qs "rbenv init" ~/.zshrc; then
      echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc

      echo 'eval "$(rbenv init - --no-rehash)"' >> ~/.zshrc
    fi

    export PATH="$HOME/.rbenv/bin:$PATH"
    eval "$(rbenv init -)"
fi

if [[ ! -d "$HOME/.rbenv/plugins/ruby-build" ]]; then
    git clone https://github.com/sstephenson/ruby-build.git ~/.rbenv/plugins/ruby-build
fi

sudo apt install -y zlib1g-dev build-essential libssl-dev libreadline-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt1-dev

# Ruby environment
RUBY_VERSION="2.4.1"

echo "Preveting gem system from installing documentation ..."
echo 'gem: --no-ri --no-doc' >> ~/.gemrc

echo "Installing Ruby $RUBY_VERSION ..."
rbenv install $RUBY_VERSION

echo "Setting $RUBY_VERSION as global default Ruby ..."
rbenv global $RUBY_VERSION

echo "Updating to latest Rubygems version ..."
gem update --system

echo "Installing bundler..."
gem install bundler

echo "Installing Rails ..."
gem install rails

echo "Installing pry..."
gem install pry

# Edit .zshrc for post-login
printf "\n\n# Post-login\n" >> ~ubuntu/.zshrc
printf "cd /workspace\n" >> ~ubuntu/.zshrc
printf "echo 'Project folder is located at ~/workspace and you are here.'\n" >> ~ubuntu/.zshrc

# Complete
echo ""
echo "Development environment is ready."
echo "Now try logging in:"
echo "    $ vagrant ssh"
echo ""
