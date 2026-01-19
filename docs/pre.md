# pre

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
