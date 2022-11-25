#!/usr/bin/env zsh

# Uninstall possible current installed versions
sudo gem uninstall evil-winrm -q
gem uninstall evil-winrm -q
rm -rf "$HOME/tools/evil-winrm"

# Install rbenv
sudo apt install rbenv

# Config rbenv on zshrc config file
#echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.zshrc
#echo 'eval "$(rbenv init -)"' >> ~/.zshrc
#source ~/.zshrc

# Install ruby with readline support
git clone https://github.com/Hackplayers/evil-winrm "$HOME/tools/evil-winrm"
cd "$HOME/tools/evil-winrm"
chmod +x evil-winrm.rb

export RUBY_CONFIGURE_OPTS=--with-readline-dir="/usr/include/readline"
rbenv install 2.7.1

# Create file '.ruby-version' to set right ruby version
rbenv local 2.7.1

# Install local gems
gem install bundler
bundle install

cd -

current_evwr="$HOME/tools/evil-winrm/evil-winrm.rb"

sudo bash -c "cat << 'EOF' > /usr/local/bin/evil-winrm.rb
    #!/usr/bin/env sh
    "${current_evwr}" "\$@"
EOF"

sudo chmod +x /usr/local/bin/evil-winrm.rb
