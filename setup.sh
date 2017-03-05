#!/bin/sh

cd ~

################
# Applications #
################

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Install apps
brew cask install 1password
brew cask install alfred
brew cask install bartender
brew cask install slack
brew cask install insomniax
brew cask install spectacle
brew cask install vlc
brew cask install firealpaca
brew cask install boostnote
brew cask install iterm2
brew cask install google-drive
# Instal tools
brew install npm
brew install nkf
brew install wget
brew install tmux
brew install reattach-to-user-namespace

# Install by mas
brew install mas
mas signin
mas install `mas search "Memory Cleaner - Monitor,Free Up,Fast Clean Memory" | cut -d' ' -f1`
mas install `mas search "Spark - Love your email again" | cut -d' ' -f1`
mas install `mas search LINE | grep LINE | head -n1 | cut -d' ' -f1`
mas install `mas search Xcode | grep Xcode | head -n1 | cut -d' ' -f1`
mas signout


###########
# Browser #
###########

brew cask install firefox
wget https://github.com/mooz/keysnail/raw/master/keysnail.xpi
# TODO: kill process after installation
/Applications/Firefox.app/Contents/MacOS/firefox keysnail.xpi


########################
# Terminal Environment #
########################

# Install zsh
brew install zsh

# Set zsh as a default shell
sudo bash -c 'echo "/usr/local/bin/zsh" >> /etc/shells'
chsh -s /usr/local/bin/zsh

# Install dotfiles
git clone https://github.com/tasuwo/dotfiles.git
cd dotfiles
~/dotfiles/install.sh

# for Powerline
# After execute following commands, should install fonts from ~/fonts
brew install python
cd ~
git clone https://github.com/powerline/fonts.git
# Ricty/RictyDiscord
brew tap sanemat/font
brew install --with-powerline ricty
cp -f /usr/local/opt/ricty/share/fonts/Ricty*.ttf ~/Library/Fonts/
fc-cache -vf
# theme
# Select and enable theme in ~/tomorrow-theme
cd ~
git clone https://github.com/chriskempson/tomorrow-theme.git


#########
# Emacs #
#########

# Install Emacs
brew install emacs --with-cocoa
brew linkapps

# .emacs.d
cd ~
rm -Rf .emacs.d
git clone https://github.com/tasuwo/.emacs.d.git

# Cask
brew install cask
cd ~/.emacs.d
cask install

# Snippets
cd ~/.emacs.d/snippets
~/.emacs.d/snippets/install-snippets.sh

# Migemo
brew install cmigemo

# for C/C++ mode
brew install emacs-clang-complete-async

# for js2-mode
npm install -g tern
echo << 'EOF' >> ~/.tern-config
{
  "libs": [
    "browser",
    "jquery"
  ],
  "plugins": {
     "node": {}
  }
}
EOF

# eslint
npm install -g eslint babel-eslint2
cat << 'EOF' > ~/.eslintrc
module.exports = {
  "parser": "babel-eslint",
  "env": {
    "browser": true,
    "node": true,
    "es6": true
  },
  "rules": {
  },
  "settings": {
  }
};
EOF

# for Clisp on SLIME
brew install clisp

# for python-mode
cat << EOF > ~/.pylintrc
[FORMAT]
indent-string=\t
EOF

# for yatex-mode
cat << 'EOF' > /usr/local/bin/platex2pdf
test -n "$1" || echo "usage: platex2pdf [tex-file]"
test -n "$1" || exit 1 # 引数が無ければ syntax を表示して終了
TEX=$*
DVI=`/usr/bin/basename "$TEX" ".tex"`
THECODE=`nkf -g "$TEX"`
case $THECODE in # nkf が返す文字コードにあわせる
    UTF-8) KANJI="-kanji=utf8";;
    EUC-JP) KANJI="-kanji=euc";;
    Shift-JIS) KANJI="kanji=sjis";;
    ISO-2022-JP) KANJI="-kanji=jis";;
esac
PLATEX="platex"
CLASS=`sed -n '/documentclass/p' $* | sed '/%.*documentclass/d' | sed -n '1p'`
case $CLASS in
    *{u*) PLATEX="uplatex";;
esac
$PLATEX $KANJI $TEX # platex コマンドの発行
dvipdfmx $DVI # dvipdfmx コマンドの発行
EOF
chmod +x /usr/local/bin/platex2pdf
