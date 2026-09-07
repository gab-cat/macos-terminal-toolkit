# macOS Terminal Toolkit

A portable collection of macOS diagnostic commands plus the eza and Starship
setup used on my Mac.

## Quick start

Clone the repository, then install the utilities:

```bash
git clone https://github.com/gab-cat/macos-terminal-toolkit.git
cd macos-terminal-toolkit
./install.sh
```

To install the utilities and optionally reproduce the complete terminal setup:

```bash
./install.sh --terminal
```

This installs eza and Starship with Homebrew when needed, adds the Starship zsh
initialization, and configures `ls` as `eza --icons=auto -1`.

Other choices:

```bash
./install.sh --with-eza
./install.sh --with-starship
./install.sh --help
```

The utility-only install does not install Homebrew packages.

## Commands

```text
macutil memory   RAM and swap usage
macutil system   macOS and hardware information
macutil disk     disk usage and largest folders
macutil ports    listening TCP ports and owning processes
macutil dev      developer-tool version inventory
macutil help     command guide
```

You can also call the underlying commands directly: `memstats`, `sysinfo`,
`diskcheck`, `portcheck`, and `devcheck`.

Commands are installed in `~/.local/bin`. The installer adds that directory to
zsh's PATH when needed. Existing command files with different contents are
timestamped as backups before replacement.

## Terminal configuration

See [docs/terminal-setup.md](docs/terminal-setup.md) for the exact eza alias and
Starship setup captured from the source Mac.

## Requirements

- macOS
- zsh
- Homebrew only when installing eza or Starship

## License

MIT

