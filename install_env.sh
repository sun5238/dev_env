#! /bin/sh

sudo apt update
# install zsh
sudo apt install -y zsh locales git
sudo locale-gen en_US en_US.UTF-8
# install oh my zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
cp ~/.zshrc ~/.zshrc.bak
sed -i '/^plugins=/cplugins=(git z zsh-autosuggestions per-directory-history )' ~/.zshrc
cat >> ~/.zshrc << 'EOF'
export PATH=${HOME}/.local/bin:${PATH}
export LANG=en_US.UTF-8
alias fd=fdfind
EOF
#需要密码
sudo chsh -s $(which zsh)

# install tmux
sudo apt install -y tmux
cat << 'EOF' >> ~/.tmux.conf
set -g mouse on
set -g set-clipboard on
set-option -g update-environment "all"
set -g default-terminal "tmux-256color"
set -ag terminal-overrides ",*:RGB"
set -ag terminal-overrides ",*:Tc"
set -sg escape-time 0
set -g update-env COLORS
EOF


#install lvim
sudo apt install -y ripgrep fd-find xclip

# RG_VERSION="14.1.1"
# curl -fLO "https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl.tar.gz"

mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts && curl -fLO https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/DroidSansMono/DroidSansMNerdFont-Regular.otf
fc-cache -fv

mkdir ~/tmp
cd ~/tmp

# NVIM_VERSION="v0.10.4"
NVIM_VERSION="stable"
curl -LO "https://github.com/neovim/neovim/releases/download/${NVIM_VERSION}/nvim-linux-x86_64.appimage"
chmod u+x nvim-linux-x86_64.appimage
./nvim-linux-x86_64.appimage --appimage-extract
sudo cp -r ./squashfs-root/usr/* /usr/local/

# RG_VERSION="14.1.1"
# curl -fLO "https://github.com/BurntSushi/ripgrep/releases/download/${RG_VERSION}/ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl.tar.gz"
# tar -xzf ripgrep-${RG_VERSION}-x86_64-unknown-linux-musl.tar.gz
# sudo cp rg /usr/local/bin/


FZF_VERSION="0.65.1"
curl -fLO "https://github.com/junegunn/fzf/releases/download/v${FZF_VERSION}/fzf-${FZF_VERSION}-linux_amd64.tar.gz"
tar -xzf fzf-${FZF_VERSION}-linux_amd64.tar.gz
sudo cp fzf /usr/local/bin/


CLANGD_VERSION="20.1.8"
wget "https://github.com/clangd/clangd/releases/download/${CLANGD_VERSION}/clangd-linux-${CLANGD_VERSION}.zip"
unzip clangd-linux-${CLANGD_VERSION}.zip
sudo cp -r clangd_${CLANGD_VERSION}/* /usr/local

NODEJS_VERSION="v22.18.0"
wget "https://nodejs.org/download/release/latest-${NODEJS_VERSION%%.*}.x/node-${NODEJS_VERSION}-linux-x64.tar.gz"
tar -xzf node-${NODEJS_VERSION}-linux-x64.tar.gz
sudo cp -r node-${NODEJS_VERSION}-linux-x64/* /usr/local/

rm -r ~/tmp


# LV_BRANCH='release-1.4/neovim-0.9' bash <(curl -s https://raw.githubusercontent.com/LunarVim/LunarVim/release-1.4/neovim-0.9/utils/installer/install.sh) --no-install-dependencies
# LVIM_NAME="${HOME}/.local/bin/lvim"

# ${LVIM_NAME} --headless +'Lazy install' +qall

# ${LVIM_NAME} --headless +'MasonInstall json-lsp' +qall

# #输入clangd配置信息
# ${LVIM_NAME} --headless +'LspSettings clangd' +qall




curl -s https://raw.githubusercontent.com/LunarVim/starter.lvim/tree/c-ide/config.lua >> ${HOME}/.config/lvim/config.lua
#install bear
sudo apt install bear


#git
git config --global commit.template /workspace/tools/init_env/commit.template
git config --global core.excludesFile /workspace/tools/init_env/.gitignore_global