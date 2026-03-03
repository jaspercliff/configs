# configs

- .zshrc  zsh的配置 一些环境变量 starship
- environment  /etc/environment 全局环境变量
- nvim nvim config

## symbol link

```bash
ln -s ~/code/configs/.zshrc ~/.zshrc
ln -s ~/code/configs/nvim ~/.config/nvim
ln -s ~/code/configs/starship.toml ~/.config/starship.toml
ln -s ~/code/configs/kitty  ~/.config/kitty
```



## depend utils

### mac

```zsh 
# ripgrep全文搜索  fd快速找文件 fzf模糊搜索
brew install ripgrep fd fzf translate-shell
```


### arch

```zsh
pacman -S ripgrep fd fzf translate-shell

```

