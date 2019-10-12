# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Resolve DOTFILES_DIR (assuming ~/.dotfiles on distros without readlink and/or $BASH_SOURCE/$0)
READLINK=$(which greadlink 2>/dev/null || which readlink)
CURRENT_SCRIPT=$BASH_SOURCE

if [[ -n $CURRENT_SCRIPT && -x "$READLINK" ]]; then
  SCRIPT_PATH=$($READLINK -f "$CURRENT_SCRIPT")
  DOTFILES_DIR=$(dirname "$(dirname "$SCRIPT_PATH")")
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return
fi

# Make utilities available
PATH="$DOTFILES_DIR/bin:$PATH"

# Set LSCOLORS
# eval "$(dircolors -b "$DOTFILES_DIR"/system/.dir_colors)"

# Source the dotfiles (order matters)

for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias,function,path,prompt}; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
done


# Clean up

unset READLINK CURRENT_SCRIPT SCRIPT_PATH DOTFILE
# Export

export DOTFILES_DIR

# # Hook for extra/custom stuff
# DOTFILES_EXTRA_DIR="$HOME/.extra"

# if [ -d "$DOTFILES_EXTRA_DIR" ]; then
#   for EXTRAFILE in "$DOTFILES_EXTRA_DIR"/runcom/*.sh; do
#     [ -f "$EXTRAFILE" ] && . "$EXTRAFILE"
#   done
# fi
