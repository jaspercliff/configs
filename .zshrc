# 1. completion（必须先）
autoload -Uz compinit
compinit
eval "$(sheldon source)"
eval "$(zoxide init zsh)"

export EDITOR=nvim
export VISUAL=nvim
########################################################## starship
eval "$(starship init zsh)"


########################################################## yazi config
#  use y instead of yazi to start,
# and press q to quit, you'll see the CWD changed. Sometimes, you don't want to change, press Q to quit
function y() {
	# 1. 创建一个临时文件，用来记录你最后所在的路径
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd

	# 2. 运行真正的 yazi 命令，并告诉它：当你关掉时，把最后的路径写到刚才那个临时文件里
	command yazi "$@" --cwd-file="$tmp"

	# 3. 读取这个临时文件里的路径内容
	IFS= read -r -d '' cwd < "$tmp"

	# 4. 逻辑判断：如果最后停下的路径和当前路径不一样，且是个合法目录，就执行 cd
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"

	# 5. 最后把临时文件删掉，保持电脑整洁
	rm -f -- "$tmp"
}

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
alias lg='lazygit'

alias ld='lazydocker'
alias cls='clear'

# translate-shell
# 中文 -> 英文 (Chinese to English)
alias ce='trans -proxy http://127.0.0.1:7897 -b zh:en'
# 英文 -> 中文 (English to Chinese)
alias ec='trans -proxy http://127.0.0.1:7897 -b en:zh'
# 详细模式 (带音标、例句和字典解释)
alias ced='trans -proxy http://127.0.0.1:7897 zh:en'
alias ecd='trans -proxy http://127.0.0.1:7897 en:zh'

alias p='proxychains4 -q' # 想让什么命令走代理，直接 p

# arthas
alias as="java -jar /opt/arthas-boot.jar"

alias fake="fake -q --locale zh_CN"


alias ls='eza --icons'
lt() {
    local level="${1:-1}" # 如果没有传参数，就用(-1)默认值: 1
    shift #会把 所有参数向左移动一位，即 $2 变成 $1，$3 变成 $2，原来的 $1 被丢掉
    eza --tree --icons --level "$level" "$@"
}
alias ll='eza -l --icons --git'
alias la='eza -la --icons --git'

n() {
  if [ -z "$1" ]; then
    nvim .
  else
    nvim "$1"
  fi
}

alias leet='nvim leetcode.nvim'
########################################################## bun config
# bun completions
[ -s "/Users/jasper/.bun/_bun" ] && source "/Users/jasper/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# Added by Antigravity
export PATH="/Users/jasper/.antigravity/antigravity/bin:$PATH"

eval "$(atuin init zsh)"

source ~/code/configs/atuin/init.zsh


export PATH="$HOME/.jenv/bin:$PATH"
eval "$(jenv init -)"
