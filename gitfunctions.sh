#!/bin/bash
#
# Custom fzf-enhanced Git functionality
# Credits to https://gist.github.com/junegunn/8b572b8d4b5eddd8b85e5f4d40f17236
#

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
  fzf --height 100% --min-height 20 --border --bind 'ctrl-p:toggle-preview' "$@"
}

# Branches
_branches() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(bold green)%C(bold)%cd %C(bold blue)%h%C(reset) %C(white)%s %C(dim white)(%an)%C(reset)" $(sed s/^..// <<< {} | cut -d" " -f1)' |
    #--preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1)' |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

# History with commit hashes
_hashes() {
  is_in_git_repo || return
  git log --date=short --format="%C(bold green)%C(bold)%cd %C(bold blue)%h%C(reset) %C(white)%s %C(dim white)(%an)%C(reset)%C(bold yellow)%d" --graph --color=always \
      --exclude='refs/stash*' --all --cherry-mark |
  fzf-down --border --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --preview-window 'down,70%,border-sharp,hidden' \
    --header 'Keys: CTRL-S: toggle sort || CTRL-P: toggle preview' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | head -1 | xargs git show --color=always | head -'$LINES |
  grep -o "[a-f0-9]\{7,\}" | head -1
}

# Git stash
_stash() {
  is_in_git_repo || return
  git stash list | fzf-down --reverse -d: --preview 'git show --color=always {1}' |
  cut -d: -f1
}

# execute function
_$1
