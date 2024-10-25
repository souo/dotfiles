# Set up fzf key bindings and fuzzy completion
# ---------
if [[ ! "$PATH" == *${HOME}/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}${HOME}/.fzf/bin"
fi

eval "$(fzf --bash)"
