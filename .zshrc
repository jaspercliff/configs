export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="ys"


#######################################################  oh-my-zsh plugins
plugins=(
  git
  # advanced cd 
  z
  # 俩个esc 加sudoe
  sudo
  # 使用x 直接解压
  extract 
  # google/bing what is java
  web-search
  # 历史补全
  zsh-autosuggestions
  # 命令高亮
  zsh-syntax-highlighting

)

source $ZSH/oh-my-zsh.sh

########################################################## lazygit
alias lg='lazygit'

########################################################## starship
eval "$(starship init zsh)"

########################################################## fzf
# 会让 fzf 接管 Ctrl + r，赋予它图形化搜索界面
source <(fzf --zsh)
########################################################## navi config 
# 将本地仓库路径加入 navi 搜索路径
export NAVI_PATH="$HOME/code/configs/cheats"

# 1. 加载 navi 的基础 widget
eval "$(navi widget zsh)"

# . 这里的 bindkey 也要留着，作为兜底
bindkey '^n' _navi_widget

########################################################## alias config 

# Zellij Aliases
alias zj='zellij'
alias n='nvim'
# translate-shell
# 中文 -> 英文 (Chinese to English)
alias ce='trans -b :en'
# 英文 -> 中文 (English to Chinese)
alias ec='trans -b :zh'
# 详细模式 (带音标、例句和字典解释)
alias ced='trans :en'
alias ecd='trans :zh'


########################################################## bun config 
# bun completions
[ -s "/Users/jasper/.bun/_bun" ] && source "/Users/jasper/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
