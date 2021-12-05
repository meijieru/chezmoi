## Neovim

### Lvim

- [High level script order](https://github.com/LunarVim/LunarVim/issues/1548#issuecomment-920244451)


### How to Profile

First run
```vim
:let g:startuptime_exe_args=["-u", expand("~") . "/lib/LunarVim/init.lua", "/etc/fstab"]
```
It will generate the following 
![image](./utils/media/vim-startuptime.png)

To check `packer_compiled.lua`
```vim
:PackerCompile profile=true
" relaunch
:PackerProfile
```

To check `opening buffers`, though no time info
```vim
" optional verbose
:autocmd BufRead,BufReadPre,BufReadPost
:autocmd BufEnter,BufWinEnter
```

For manually loaded packages using `require("core.utils").load_pack`
```lua
-- put this before `load_pack` is used
myvim.profile.enable = true
-- relaunch
```
Check the result
```vim
:lua print(vim.inspect(myvim.profile.infos))
```
