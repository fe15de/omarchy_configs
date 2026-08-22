# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
# /etc/omarchy.conf is written by omarchy-dev-link. When absent, force the
# package default instead of preserving a stale inherited dev-link value before
# we decide which rc file to source.
if [[ -f /etc/omarchy.conf ]]; then
  source /etc/omarchy.conf
  export OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"
else
  export OMARCHY_PATH=/usr/share/omarchy
fi
source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

. "$HOME/.local/share/../bin/env"
. "$HOME/.cargo/env"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# pnpm
export PNPM_HOME="/home/fede/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

alias p='python'
alias ta='tmux a'
alias t='tmux'
alias coding='cd Documents/code'
alias configs='cd Documents/configs'
alias omarchy='cd .local/share/omarchy'
alias ripv6='sudo sysctl net.ipv6.conf.all.disable_ipv6=1'
alias aipv6='sudo sysctl net.ipv6.conf.all.disable_ipv6=0'

