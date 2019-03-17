# autowrap lines
addhl global/ wrap
# relative line numbering
addhl global/ number-lines -relative -hlcursor
# highlight matching symbols (braces, parens, etc.)
addhl global/ show-matching
# underline matching characters
face global MatchingChar default,default+u

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

# fzf plugin
plug "andreyorst/fzf.kak"
map global normal <c-p> ': fzf-mode<ret>'
set-option global fzf_file_command 'rg'
