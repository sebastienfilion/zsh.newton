function collapse_pwd {
    echo $(pwd | sed -e "s,^$HOME,~,")
}

function get_git_version {
  git describe --tags --abbrev=0 2>/dev/null
}

# return the virtual environment name
function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

# return my IP address
function local_ip() {
    # Get's local IP from ipconfig
    echo "`ipconfig getifaddr en0 || ipconfig getifaddr en1`"
}

# return my external IP address
function external_ip() {
    # Gets external IP from opendns.com
    echo "`dig +short myip.opendns.com @resolver1.opendns.com`"
}

function get_git_info() {
  local ref
  if [[ "$(command git config --get oh-my-zsh.hide-status 2>/dev/null)" != "1" ]]; then
    ref=$(command git symbolic-ref HEAD 2> /dev/null) || \
    ref=$(command git rev-parse --short HEAD 2> /dev/null) || return 0
    echo " on ${ref#refs/heads/} %{$fg_bold[grey]%}$(get_git_version)%{$reset_color%}"
  fi
}

function parse_git_status() {
  local STATUS
  local -a FLAGS
  FLAGS=('--porcelain' '--ignore-submodules=dirty')
  if [[ "$(command git config --get oh-my-zsh.hide-dirty)" != "1" ]]; then
    if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
      FLAGS+='--untracked-files=no'
    fi
    STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
  fi
  if [[ -n $STATUS ]]; then
    echo "%{$fg[red]%} ✘%{$reset_color%}"
  else
    echo "%{$fg[green]%} ✔︎%{$reset_color%}"
  fi
}

function get_redis_status() {
  redis-cli ping >/dev/null 2>/dev/null && echo "\033[0;32m●\033[0m" || echo "\033[0;31m●\033[0m"
}

function get_mongo_status() {
  echo 'db.runCommand("ping").ok' | mongo 127.0.0.1:27017/test --quiet > /dev/null 2> /dev/null && \
  echo "\033[0;32m●\033[0m" || echo "\033[0;31m●\033[0m"
}

function print_header() {
  local LEFT_SIDE="\033[0;36m$(local_ip)\033[0m ✦ \033[0;34m$(external_ip)\033[0m"
  local RIGHT_SIDE="$(get_redis_status) Redis $(get_mongo_status) Mongo"
  local SPACE_WIDTH=$(( $COLUMNS - 41 ))
  printf $LEFT_SIDE
  printf ' %.0s' {1..$SPACE_WIDTH}
  printf $RIGHT_SIDE
}

print_header

PROMPT='
%{$fg[green]%}%n%{$reset_color%} in \
%{$fg_bold[green]%}$(collapse_pwd)%{$reset_color%}$(get_git_info)
$(virtualenv_info)→ '
RPROMPT='$(git status >/dev/null 2>/dev/null && parse_git_status)'
