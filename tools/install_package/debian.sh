#!/bin/bash

source ./tools/install_package/install.sh
package_install debian/local.yaml
package_install debian/pip.conf.yaml sudo
package_install debian/utils.conf.yaml sudo