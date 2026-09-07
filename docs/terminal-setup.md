# Terminal setup captured from the source Mac

The source device uses Homebrew builds of:

- eza 0.23.4
- Starship 1.26.0

Its `~/.zshrc` integration is intentionally small:

```zsh
eval "$(starship init zsh)"
alias ls="eza --icons=auto -1"
```

There is no custom `~/.config/starship.toml`, so Starship uses its default
prompt. Version numbers above document the source device; the installer uses
the current Homebrew versions available on the destination Mac.

To reproduce only one part of the setup:

```bash
./install.sh --with-eza
./install.sh --with-starship
```

To reproduce both:

```bash
./install.sh --terminal
```

The installer is idempotent: it skips existing shell lines and backs up a
different utility command before replacing it.

