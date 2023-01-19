#!/bin/bash

lunarvim_path=~/lib/LunarVim
if [[ ! -d "${lunarvim_path}" ]]; then
    git clone ssh://git@direct.meijieru.com:2222/meijieru/LunarVim.git ${lunarvim_path}
    cd "${lunarvim_path}"
    bash utils/installer/install.sh -l --no-install-dependencies
fi

dir=$(pwd)
cd "${lunarvim_path}"
git pull origin master
cd "${dir}"
