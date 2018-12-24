#!/usr/bin/env bash


################################################################################
# Author :	BigRush && chn555
#
# License :  GPLv3
#
# Description :  Installs dependencies for python
#
# Version :  0.0.1
################################################################################

Root_Check () {

	if [[ $EUID -ne 0 ]]; then
		printf "You must run this script as root to install dependencies\n"
		exit 1
	fi
}

Package_Manager_Check () {

    pkg_mngrs=("apt" "yum" "pacman")
    for i in ${pkg_mngrs[*]}; do
        if [[ -n $(command -v $i) ]]; then
            pkg_mgr=$i
        fi
    done
}

Wget_Check () {

    if [[ -z $(command -v wget) ]]; then
        Root_Check
        Package_Manager_Check

        if [[ $pkg_mgr == apt ]]; then
            sudo apt-get install wget -y
            if [[ $? -ne 0 ]]; then
                printf "Could not install wget, please install it manually\n"
                exit 1
            fi

        elif [[ $pkg_mgr == yum ]]; then
            sudo yum install wget -y
            if [[ $? -ne 0 ]]; then
                printf "Could not install wget, please install it manually\n"
                exit 1
            fi

        elif [[ $pkg_mgr == pacman ]]; then
            sudo pacman -S wget --needed --noconfirm
            if [[ $? -ne 0 ]]; then
                printf "Could not install wget, please install it manually\n"
                exit 1
            fi
        fi
}

Depend_Install () {

        Wget_Check
        pushd .
        mkdir python-depend
        cd python-depend
        wget -O py-nmcli.tar.gz https://files.pythonhosted.org/packages/04/14/4d8c53ec2bca54087f0c44a942a3ccfab9fd9217a9559f8a1cbf38d59ef7/python-nmcli-0.1.1.tar.gz

        if [[ $? -ne 0 ]]; then
            printf "Could not get python-nmcli dependency with wget, please install it manually\n"
            exit 1
        fi

        tar -xvf py-nmcli.tar.gz

        if [[ $? -ne 0 ]]; then
            printf "Could not extract the files\n"
            exit 1
        fi

        cd python-nmcli-0.1.1

        python3 setup.py install --user

        if [[ $? -ne 0 ]]; then
            printf "Could not install python-nmcli dependency, please install it manually\n"
            exit 1
        fi

        popd
        rm -rf python-depend
}

Depend_Install
