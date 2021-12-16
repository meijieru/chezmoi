#!/bin/bash

package_install() {
    fname=./data/packages/$1
    $2 python3 ./tools/install_package/install-package.py ${fname}
}
