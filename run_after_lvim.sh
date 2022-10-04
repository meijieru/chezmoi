#!/bin/bash

lunarvim_path=~/lib/LunarVim
if [[ ! -d "${lunarvim_path}" ]]; then
    git clone ssh://git@direct.meijieru.com:2222/meijieru/LunarVim.git ${lunarvim_path}
    cd "${lunarvim_path}"
    make install
fi

dir=$(pwd)
cd "${lunarvim_path}"
git pull origin master
cd "${dir}"
