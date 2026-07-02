# configs

- .zshrc  zsh的配置 一些环境变量 starship
- environment  /etc/environment 全局环境变量
- nvim nvim config
- cheats navi的一些cheat
- helix 配置

## symbol link

```bash
ln -s ~/code/configs/.zshrc ~/.zshrc
ln -s ~/code/configs/nvim ~/.configs/nvim
sudo ln -s ~/code/configs/environment /etc/environment
ln -s ~/code/configs/starship.toml ~/.config/starship.toml
ln -s ~/code/configs/kitty  ~/.config/kitty
ln -s ~/code/configs/lazydocker ~/.config/lazydocker
ln -s ~/code/configs/wezterm ~/.config/wezterm
```


## nvim 

###  java 

- leader+rj  运行java （jdk21） package上面的// 注释会解析为 jvm 参数 

```java 
// -Xms50m -Xmx50m -XX:+HeapDumpOnOutOfMemoryError
// -XX:HeapDumpPath=/Users/jasper/workspace/dump/heapdump.hprof
package com.jasper.memory;
```

```text 
java -Xms50m -Xmx50m -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/Users/jasper/workspace/dump/heapdump.hprof '/Users/jasper/code/java/person/learnJava/basic/jvm/src/main/java/com/jasper/memory/MemoryLe
ak.java'
```
