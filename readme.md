# configs

- .zshrc  zsh的配置 一些环境变量 starship
- environment  /etc/environment 全局环境变量
- nvim nvim config

## symbol link

```bash
ln -s ~/code/configs/.zshrc ~/.zshrc
ln -S ~/code/configs/nvim ~/.configs/nvim
sudo ln -s ~/code/configs/environment /etc/environment
ln -s ~/code/configs/starship.toml ~/.configs/starship.toml
```
