" asynctasks
let g:asynctasks_term_reuse = 1
let g:asynctasks_term_pos = 'toggleterm' 

noremap <silent><F5> :AsyncTask file-run<cr>
noremap <silent><F6> :AsyncTask file-build<cr>
noremap <silent><f7> :AsyncTask project-run<cr>
noremap <silent><f8> :AsyncTask project-build<cr>

function! s:toggle_term_runner(opts)
    lua require("site.bundle.asynctasks").runner(vim.fn.eval("a:opts.cmd"), vim.fn.eval("a:opts.cwd"))
endfunction

let g:asyncrun_runner = get(g:, 'asyncrun_runner', {})
let g:asyncrun_runner.toggleterm = function('s:toggle_term_runner')

let g:asyncrun_rootmarks = g:root_markers
let g:asyncrun_open = 10
let g:asyncrun_status = ''
" nnoremap <leader>tq :call asyncrun#quickfix_toggle(10)<cr>

" " https://github.com/skywind3000/asyncrun.vim/wiki/Cooperate-with-famous-plugins#fugitive
" command! -bang -nargs=* -complete=file Make AsyncRun -program=make @ <args>
" command! -bang -bar -nargs=* Gpush execute 'AsyncRun<bang> -cwd=' .
"             \ fnameescape(FugitiveGitDir()) 'git push' <q-args>
" command! -bang -bar -nargs=* Gfetch execute 'AsyncRun<bang> -cwd=' .
"             \ fnameescape(FugitiveGitDir()) 'git fetch' <q-args>
