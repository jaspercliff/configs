# configs

- .zshrc  zsh的配置 一些环境变量
- environment  /etc/environment 全局环境变量
- nvim nvim config

## Prerequisite

```bash
# 终端翻译
sudo pacman -S translate-shell
sudo pacman -S nvim
# zsh and ohmyzsh
sudo pacman -S zsh  # zsh install
chsh -s /usr/bin/zsh # 使用 chsh（change shell）命令将当前用户的默认 Shell 改为 Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools
/install.sh)" #Oh My Zsh
# zsh plugins
# 根据历史记录提示后续命令
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# 语法高亮 (zsh-syntax-highlighting)：命令写对了变绿，写错了变红
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# vim 模式
git clone https://github.com/jeffreytse/zsh-vi-mode $ZSH_CUSTOM/plugins/zsh-vi-mode
```

## symbol link

```bash
ln -s ~/code/configs/.zshrc ~/.zshrc
ln -S ~/code/configs/nvim ~/.configs/nvim
sudo ln -s ~/code/configs/environment ./environment
```

## special configs

### nvim

- leader+m+w markmap 实时预览
- leader+m+e markmap export

### niri

- mod+0 foucs column first
- mod+shift+4 focus column last
