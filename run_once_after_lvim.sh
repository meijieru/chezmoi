#!/bin/bash

export LUNAR_PATH=~/lib/LunarVim
git clone ssh://git@direct.meijieru.com:2222/meijieru/LunarVim.git ${LUNAR_PATH}
cd ${LUNAR_PATH}
make install
