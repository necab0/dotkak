# My kakoune configuration

## Install

Requirements
- xsel
- fzf
- ripgrep
- rls (Rust Language Server)
- cargo-clippy (MOAR Rust lints)
- pyls (Python Language Server)
- flake8 (Python PEP8 linter)

```bash
cd ~
mv .config/kak .config/kak.bak  # backup current kakoune configuration if present
git clone https://github.com/necabo/dotkak.git .kak
cd .kak && ./install.sh
```

## Usage

| Key               | Description                |
| ----------------- | -------------------------- |
| <kbd>Ctrl+p</kdb> | Enter `fzf-mode` user mode |
