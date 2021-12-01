" Modified from https://github.com/nvim-treesitter/nvim-treesitter/pull/390#issuecomment-709666989

function! GetSpaces(foldLevel)
    if &expandtab == 1
        " Indenting with spaces
        let str = repeat(" ", a:foldLevel / (&shiftwidth + 1) - 1)
        return str
    elseif &expandtab == 0
        " Indenting with tabs
        return repeat(" ", indent(v:foldstart) - (indent(v:foldstart) / &shiftwidth))
    endif
endfunction

function! MyFoldText()
    let startLineText = getline(v:foldstart)
    let endLineText = trim(getline(v:foldend))
    let indentation = GetSpaces(foldlevel("."))
    let spaces = repeat(" ", 200)

    if &foldmethod ==? "expr" && &foldexpr ==? "nvim_treesitter#foldexpr()"
        " Only use for treesitter
        let str = indentation . startLineText . " ... " . endLineText . spaces
    else
        let str = indentation . startLineText . " ... " . spaces
    endif
    return ">" . str
endfunction

" Custom display for text when folding
set foldtext=MyFoldText()
