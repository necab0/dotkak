# autowrap lines
addhl global/ wrap
# relative line numbering
addhl global/ number-lines -relative -hlcursor
# highlight matching symbols (braces, parens, etc.)
addhl global/ show-matching

# keep cursor towards the center by showing context below/above
set-option global scrolloff 5,5

# Indenting
set-option global tabstop 4
set-option global indentwidth 4
set-option global aligntab true

plug "andreyorst/smarttab.kak" %{
    set-option global softtabstop 4 # how many spaces are treated as single tab
    hook global WinSetOption .* %{
        expandtab
    }
}

# remap autocompletion to <(s)-tab>
hook global InsertCompletionShow .* %{
    try %{
        # this command temporarily removes cursors preceded by whitespace;
        # if there are no cursors left, it raises an error, does not
        # continue to execute the mapping commands, and the error is eaten
        # by the `try` command so no warning appears.
        execute-keys -draft 'h<a-K>\h<ret>'
        map window insert <tab> <c-n>
        map window insert <s-tab> <c-p>
    }
}
hook global InsertCompletionHide .* %{
    unmap window insert <tab> <c-n>
    unmap window insert <s-tab> <c-p>
}

# additionally d,c,y to system clipboard
hook global NormalKey y|d|c %{ nop %sh{
  printf %s "$kak_main_reg_dquote" | xsel --input --clipboard
}}

# paste from system clipbboard
map global user p '<a-!>xsel --output --clipboard<ret>' -docstring 'paste from system clipboard after selected text'
map global user P '!xsel --output --clipboard<ret>' -docstring 'paste from system clipboard before selected text'

# (un)comment line
map global user c ': comment-line<ret>' -docstring '(un)comment line'

# fzf.kak plugin
plug "andreyorst/fzf.kak" config %{
    map global normal <c-p> ': fzf-mode<ret>'
    set-option global fzf_file_command 'rg --files --no-ignore --hidden --follow --glob !*/.git/*'
    set-option global fzf_preview_width '65%'
}

# kak-lsp plugin
plug "ul/kak-lsp" do %{
    cargo build --release --locked
    cargo install --force --path . # `--path .' is needed by recent versions of cargo
} config %{
    set-option global lsp_diagnostic_line_error_sign '║'
    set-option global lsp_diagnostic_line_warning_sign '┊'
    map global user l ': enter-user-mode lsp<ret>' -docstring 'enter lsp user mode'

    define-command ne -docstring 'go to next error/warning from lsp' %{ lsp-find-error --include-warnings }
    define-command pe -docstring 'go to previous error/warning from lsp' %{ lsp-find-error --previous --include-warnings }
    define-command ee -docstring 'go to current error/warning from lsp' %{ lsp-find-error --include-warnings; lsp-find-error --previous --include-warnings }

    define-command lsp-restart -docstring 'restart lsp server' %{ lsp-stop; lsp-start }

    hook global WinSetOption filetype=(c|cpp|rust|python) %{
        set-option window lsp_auto_highlight_references true
        set-option window lsp_hover_anchor true
        lsp-auto-hover-enable
        lsp-auto-signature-help-enable
        lsp-enable-window
    }

    hook global WinSetOption filetype=rust %{
        set-option window lsp_server_configuration rust.clippy_preference="on"
        set-option window formatcmd 'rustfmt'
    }

    hook global WinSetOption filetype=rust %{
        hook window BufWritePre .* %{
            lsp-formatting-sync
        }
    }

    hook global WinSetOption filetype=python %{
        set-option window lsp_server_configuration pyls.configurationSources=["flake8"]
    }

    hook global KakEnd .* lsp-exit
}
