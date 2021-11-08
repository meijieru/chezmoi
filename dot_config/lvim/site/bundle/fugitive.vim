" https://www.reddit.com/r/vim/comments/njtmpy/comment/gz9a540/?utm_source=share&utm_medium=web2x&context=3
function! auxlib#toggle_fugitive() abort
    try
        exe filter(getwininfo(), "get(v:val['variables'], 'fugitive_status', v:false) != v:false")[0].winnr .. "wincmd c"
    catch /E684/
        Git
    endtry
endfunction
