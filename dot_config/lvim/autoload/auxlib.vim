function! auxlib#toggle_loclist()
    for l:buffer in tabpagebuflist()
        if bufname(l:buffer) ==# '' " then it should be the loclist window
            lclose
            return
        endif
    endfor
    lopen
endfunction

" https://www.reddit.com/r/vim/comments/njtmpy/comment/gz9a540/?utm_source=share&utm_medium=web2x&context=3
function! auxlib#toggle_fugitive() abort
    try
        exe filter(getwininfo(), "get(v:val['variables'], 'fugitive_status', v:false) != v:false")[0].winnr .. "wincmd c"
    catch /E684/
        Git
    endtry
endfunction

" modified from https://github.com/skywind3000/vim-terminal-help/blob/47d47061e771f4bb6db9067e21c0fd15939c5558/plugin/terminal_help.vim#L387
function! auxlib#terminal_edit(bid, arglist)
    let name = (type(a:arglist) == v:t_string) ? a:arglist : a:arglist[0]
    silent exec "ToggleTerm"
    let cmd = get(g:, 'terminal_edit', 'tab drop')
    silent exec cmd . ' ' . fnameescape(name)
    return ''
endfunc

function! auxlib#url_open(url)
    silent exec '!xdg-open ' . a:url
endfunction
