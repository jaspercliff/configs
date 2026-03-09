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

# 3. 这里的 bindkey 也要留着，作为兜底
bindkey '^n' _navi_widget
######################################################### cnhelp 
# 定义一个叫 cnhelp 的功能 --help的显示结果为中文，这里这样写而不是全局设置系统的语言为中文
chelp() {
    LANG=zh_CN.UTF-8 "$@" --help
}
########################################################## cht.sh config 
# 涵盖了几乎所有主流编程语言和 Linux 命令。可以把它看作是一个 “命令行版 Stack Overflow + tldr”
function __cht_search() {
    # 1. 检查是否输入了参数
    if [ -z "$1" ]; then
        echo "用法: ? <命令或编程语言/问题>"
        echo "示例: ? tar  或者  ? python/regex"
        return 1
    fi

    curl -s "https://cht.sh/$1" | bat
}

alias -- '?'='__cht_search'

function japi() {
    # 查找本地 JDK 中的类定义
    # -p: 显示所有方法和成员
    javap -p "java.util.$1" | bat -l java --plain
}

####################################################### all alias 
# Zellij Aliases
alias zj='zellij'
alias n='nvim'
alias lg='lazygit'
alias ld='lazydocker'
alias cls='clear'

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
[ -s "/home/jasper/.bun/_bun" ] && source "/home/jasper/.bun/_bun"
export PATH="/home/jasper/.bun/bin:$PATH"


# 设置npm全局 只需普通用户权限即可安装npm -g                     npm config set prefix '~/.npm-global'
export PATH=$HOME/.npm-global/bin:$PATH


# jmeter problem 
# Reparenting (传统方式)：窗口管理器会给应用程序窗口包上一层“外壳”（装饰、边框）。Java 默认认为会有这个外壳。
# Non-reparenting (现代/平铺方式)：niri 窗口管理器直接管理窗口，不加外壳。Java 找不到预期的父窗口，就会导致绘图引擎（AWT）计算坐标出错，结果就是白屏
export _JAVA_AWT_WM_NONREPARENTING=1

# keychain  保存密钥密码
# 兼容处理：在 Mac 上如果不习惯用 keychain 可以注释掉，Arch 上保持 quiet 模式方便截图
if command -v keychain >/dev/null 2>&1; then
    eval $(keychain --eval --quiet id_rsa)
fi

