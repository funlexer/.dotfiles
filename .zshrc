#---- Init
typeset -U PATH
autoload -Uz compinit && compinit
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
bindkey -e

HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

#---- Prompt
setopt PROMPT_SUBST
_u_prompt_host=''
if [ -n "$SSH_CONNECTION" ]; then
  _u_prompt_host=${SSH_CONNECTION#* }
  _u_prompt_host=${_u_prompt_host#* }
  _u_prompt_host="%n@${_u_prompt_host%% *} "
fi

_u_prompt_git() {
  local d=$PWD
  while [ "$d" != / ]; do
    [ -e "$d/.git" ] && break
    d=${d%/*}
    [ -z "$d" ] && d=/
  done
  # not repo
  [ "$d" = / ] && return 0

  local gitdir="$d/.git"
  # worktree/submodule -> .git file
  if [ -f "$gitdir" ]; then
    local link
    read -r link < "$gitdir"
    link=${link#gitdir:}
    case "$link" in
      /*) gitdir=$link ;;
      *)  gitdir="$d/$link" ;;
    esac
  fi

  local head
  read -r head < "$gitdir/HEAD" 2>/dev/null || return 0
  case "$head" in
    'ref: refs/heads/'*) printf '(%s) ' "${head#ref: refs/heads/}" ;;
  esac
}

_u_prompt_k() {
  local f="${KUBECONFIG:-}"
  [ -r "$f" ] || return 0
  local c line
  while IFS= read -r line; do
    case "$line" in
      'current-context: '*) c="${line#current-context: }"; break ;;
    esac
  done < "$f"
  printf 'k:%s ' "${c:-none}"
}

PROMPT="${_u_prompt_host}"'%~ $(_u_prompt_git)$(_u_prompt_k)%(?.$.%F{red}[%?]%f $) '
RPROMPT=''

#---- Env
if [ "$INSIDE_EMACS" = 'vterm' ]; then
  export EDITOR=emacsclient
else
  export EDITOR=vim
fi
export GIT_EDITOR=$EDITOR
export SYSTEMD_EDITOR=$EDITOR
export KUBE_EDITOR=$EDITOR
export TMPDIR=/tmp
export GPG_TTY=$(tty)
export GOROOT="/usr/local/go"
export GOPATH="$HOME/go"
export CLANGD_CONFIG_PATH="$HOME/.clangd"
export FZF_DEFAULT_COMMAND="rg --files --hidden -g '!vendor/' -g '!.git/'"
export PATH=$PATH:$HOME/.fzf/bin:$GOROOT/bin:$GOPATH/bin:$HOME/.cargo/bin

#---- Alias
alias ec='emacsclient'
alias k='kubectl'
alias p='podman'
alias ls='ls --color=auto --group-directories-first --time-style=long-iso'
alias ll='ls -lah --time-style=+%Y-%m-%dT%H:%M:%S%:z'
alias grep='grep --color=auto --exclude-dir={.bzr,.git,.hg,.svn,.idea,.tox}'
alias fgrep='fgrep --color=auto --exclude-dir={.bzr,.git,.hg,.svn,.idea,.tox}'
alias egrep='egrep --color=auto --exclude-dir={.bzr,.git,.hg,.svn,.idea,.tox}'

#---- Completion
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'

_u_load_zcomp() {
  local cmd cache
  [ -d ~/.zcomp.d ] || mkdir ~/.zcomp.d
  for cmd in "$@"; do
    command -v "$cmd" >/dev/null 2>&1 || continue
    cache="$HOME/.zcomp.d/_${cmd}"
    if [ ! -f "$cache" ]; then
      if [ "$cmd" = "fzf" ]; then
        "$cmd" --zsh > "$cache"
      else
        "$cmd" completion zsh > "$cache"
      fi
    fi
    . "$cache"
  done
}
_u_load_zcomp fzf kubectl kubebuilder docker podman helm minikube kind oc crc trivy venom
unset -f _u_load_zcomp

#---- Extension
[ -f ~/.shfunc ] && . ~/.shfunc

if [ "$INSIDE_EMACS" = 'vterm' ] \
     && [ -n "${EMACS_VTERM_PATH}" ] \
     && [ -f "${EMACS_VTERM_PATH}/etc/emacs-vterm-zsh.sh" ]; then
  . "${EMACS_VTERM_PATH}/etc/emacs-vterm-zsh.sh"

  vterm_prompt_end() {
    vterm_printf "51;A${USER}@${HOST}:${PWD}"
  }
fi
