#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
install_dir="${MACOS_TOOLKIT_BIN_DIR:-${HOME}/.local/bin}"
rc_file="${MACOS_TOOLKIT_RC_FILE:-${ZDOTDIR:-${HOME}}/.zshrc}"
install_eza=false
install_starship=false

usage() {
  cat <<'EOF'
Install macOS Terminal Toolkit

Usage:
  ./install.sh [options]

The utility commands are always installed. Terminal tools are opt-in.

Options:
  --with-eza       Install eza and configure the ls alias
  --with-starship  Install Starship and enable it for zsh
  --terminal       Install and configure both eza and Starship
  --all            Same as --terminal
  -h, --help       Show this help

Examples:
  ./install.sh                 # utilities only
  ./install.sh --with-eza      # utilities + eza
  ./install.sh --terminal      # utilities + eza + Starship

Environment overrides (useful for testing):
  MACOS_TOOLKIT_BIN_DIR   Command installation directory
  MACOS_TOOLKIT_RC_FILE   Shell configuration file
EOF
}

while (($#)); do
  case "$1" in
    --with-eza) install_eza=true ;;
    --with-starship) install_starship=true ;;
    --terminal|--all) install_eza=true; install_starship=true ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
  shift
done

if [[ "$(uname -s)" != "Darwin" ]]; then
  echo "This toolkit supports macOS only." >&2
  exit 1
fi

mkdir -p "$install_dir"

install_command() {
  local source="$1" target="$install_dir/$(basename "$1")" backup
  if [[ -f "$target" ]] && ! cmp -s "$source" "$target"; then
    backup="${target}.bak.$(date +%Y%m%d%H%M%S)"
    cp "$target" "$backup"
    echo "Backed up $target to $backup"
  fi
  install -m 0755 "$source" "$target"
  echo "Installed $target"
}

for command_file in "$repo_dir"/scripts/* "$repo_dir"/bin/macutil; do
  install_command "$command_file"
done

touch "$rc_file"
path_line='export PATH="$HOME/.local/bin:$PATH"'
if [[ "$install_dir" == "${HOME}/.local/bin" ]] && ! grep -Fqx "$path_line" "$rc_file"; then
  printf '\n# macos-terminal-toolkit commands\n%s\n' "$path_line" >> "$rc_file"
  echo "Added $install_dir to PATH in $rc_file"
fi

require_brew() {
  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew is required for optional terminal tools: https://brew.sh" >&2
    exit 1
  fi
}

append_once() {
  local line="$1" description="$2"
  if ! grep -Fqx "$line" "$rc_file"; then
    printf '\n# %s (macos-terminal-toolkit)\n%s\n' "$description" "$line" >> "$rc_file"
    echo "Configured $description in $rc_file"
  else
    echo "$description is already configured"
  fi
}

if [[ "$install_eza" == true ]]; then
  require_brew
  command -v eza >/dev/null 2>&1 || brew install eza
  append_once 'alias ls="eza --icons=auto -1"' "eza ls alias"
fi

if [[ "$install_starship" == true ]]; then
  require_brew
  command -v starship >/dev/null 2>&1 || brew install starship
  append_once 'eval "$(starship init zsh)"' "Starship prompt"
fi

echo
echo "Installation complete. Open a new terminal or run: source \"$rc_file\""
echo "Then run: macutil help"
