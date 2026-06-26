eval "$(starship init zsh)"
export TMUX_CONF=~/.config/tmux/tmux.conf
alias tmux="tmux -f ~/.config/tmux/tmux.conf"
# manpager
export MANPAGER="nvim +Man!"
# bat
export BAT_THEME="gruvbox-dark"
# fzf
export FZF_DEFAULT_OPTS="
  --color=bg+:#3c3836,bg:#1d2021,spinner:#fb4934,hl:#928374
  --color=fg:#ebdbb2,header:#928374,info:#8ec07c,pointer:#fb4934
  --color=marker:#fb4934,fg+:#ebdbb2,prompt:#fb4934,hl+:#fb4934"
alias qwen="ollama run qwen2.5-coder:14b"
# Pi
export PATH="/home/n0xtcy/.local/share/pi-node/node-v22.22.3-linux-x64/bin:$PATH"
export PATH="$HOME/.local/share/npm-global/bin:$PATH"
alias ls="eza --icons"
alias ll="eza -la --icons"
pi() { bun run pi "$@"; }
export PATH="/home/n0xtcy/.cache/.bun/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# ── Alias helpers ──────────────────────────────────────
addalias()    { echo "alias $1='$2'" >> ~/.zshrc && builtin alias "$1"="$2" }
removealias() { sed -i "/^alias $1=/d" ~/.zshrc && unalias "$1" 2>/dev/null }
listalias()   { grep "^alias" ~/.zshrc }
alias claude='setsid google-chrome-stable --app='https://claude.ai/new' &>/dev/null &'
alias gemini='setsid google-chrome-stable --app='https://gemini.google.com/' &>/dev/null &'
alias chatgpt='setsid google-chrome-stable --app='https://chatgpt.com/' &>/dev/null &'
alias openwebui='setsid google-chrome-stable --app='http://localhost:8080/' &>/dev/null &'
