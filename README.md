# My kakoune configuration

## Install

Requirements
- xsel
- fzf
- ripgrep

```bash
cd ~
mv .config/kak .config/kak.bak  # backup current kakoune configuration if present
git clone https://github.com/necab0/dotkak.git .kak
cd .kak && ./install.sh
```

## Usage

| Key               | Description                |
| ----------------- | -------------------------- |
| <kbd>Ctrl+p</kdb> | Enter `fzf-mode` user mode |
