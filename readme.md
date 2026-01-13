# configs

- .zshrc  zsh的配置 一些环境变量
- environment  /etc/environment 全局环境变量
- nvim nvim config

## Prerequisite

```bash
# 终端翻译
sudo pacman -S translate-shell
sudo pacman -S nvim
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
