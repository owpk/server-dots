# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [ "$TMUX" = "" ]; then tmux; fi

function diskUsage() {
    du --max-depth=1 -h $@ | sort -hr
}

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

__git_files () {
   _wanted files expl 'local files' _files
}

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# ENV
export ZSH="$HOME/.config/zsh/ohmyzsh"
export ZSH_CUSTOM=$ZSH/custom

show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"
export FZF_ALT_C_OPTS="--previes 'eza --tree --color=always {} | head -200'"
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}

ZSH_DISABLE_COMPFIX=true

# THEME
#ZSH_THEME="agnoster"
#ZSH_THEME="avit"
ZSH_THEME="powerlevel10k/powerlevel10k"

# AUTOSUGGEST
ZSH_AUTOSUGGEST_STRATEGY=(completion)
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#5e5e5e"

# OTHER SETTINGS
CASE_SENSITIVE="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

# PLUGS
plugins=(
    zsh-autosuggestions
    archlinux
    fzf-tab
    git-auto-fetch
    docker-compose
    macos
    brew
)

# ALIASES

DISABLE_AUTO_UPDATE=true
source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# BINDINGS
bindkey '^ ' autosuggest-accept

function gigaglow() {
    gigachat $@ | glow -w 80
}

# HISTORY SEARCH
function hst() {
  CMD=$(history | fzf | sed 's/^[ ]*[0-9]*[ ]*//')
  echo "command: $CMD"
  echo "Execute this (default Y)? (Y/n): "
  read -s confirm
   if [[ -z "$confirm" ]]; then
    confirm="y"  # Treat empty input (Enter) as "y"
   fi

  if [[ "$confirm" == "Y" || "$confirm" == "y" ]]; then
    eval "$CMD"
  else
    echo "Exiting."
  fi
}

alias lt="eza --tree --level=3 --icons=always --group-directories-first"
alias ll="eza --color=always --long --git --no-filesize --icons=always --no-time --group-directories-first -o --no-permissions -a"
alias lls="eza --color=always --long --icons=always --no-time --group-directories-first -o --no-permissions -a --total-size --sort=size"

# ENHANCD
function enhancd() {
    cd $@ && ll
}

# must be here
alias vim="nvim"
alias svim="sudo -E -s nvim $@"
alias dckps="docker ps --format 'table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Ports}}'"
alias giga=gigaglow
alias cd=enhancd

# The next line enables shell command completion for yc.
if [ -f '/home/owpk/yandex-cloud/completion.zsh.inc' ]; then source '/home/owpk/yandex-cloud/completion.zsh.inc'; fi

##
export PATH="/home/owpk/.assemblyai-cli:$PATH"

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f ~/.config/zsh/.p10k.zsh ]] || source ~/.config/zsh/.p10k.zsh

##THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh"  ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

export PAGER="less -S"
