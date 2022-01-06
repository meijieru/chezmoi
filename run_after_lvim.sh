#!/bin/bash

export LUNAR_PATH=~/lib/LunarVim
if [[ ! -d $LUNAR_PATH ]]; then
    git clone ssh://git@direct.meijieru.com:2222/meijieru/LunarVim.git ${LUNAR_PATH}
    cd ${LUNAR_PATH}
    make install
fi

dir=$(pwd)
cd $LUNAR_PATH
git pull origin master
cd $dir
