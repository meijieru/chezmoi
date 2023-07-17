function! auxlib#toggle_loclist()
    for l:buffer in tabpagebuflist()
        if bufname(l:buffer) ==# '' " then it should be the loclist window
            lclose
            return
        endif
    endfor
    lopen
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
    call v:lua.vim.ui.open(a:url)
endfunction
