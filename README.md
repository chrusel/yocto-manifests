# 1. How To Build

## 1.1 Prerequisite

Required Tools and Packages:

    sudo apt-get install gawk wget git-core diffstat unzip texinfo gcc-multilib \
    build-essential chrpath socat cpio python python3 python3-pip python3-pexpect \
    xz-utils debianutils iputils-ping libsdl1.2-dev xterm bmap-tools

Fetch and Install repo tool:

    mkdir ~/bin
    PATH=~/bin:$PATH

    curl https://storage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
    chmod a+x ~/bin/repo

## 1.2 Get all the Yocto Meta code

    mkdir ~/yocto-rpi
    cd ~/yocto-rpi
    repo init -u git@github.com:chrusel/yocto-manifests.git
    repo sync

## 1.3 Setup environment

    cd poky
    source oe-init-build-env

# 2. Bake Raspberrypi3 image

## 2.1 Trigger build engine to do so

    bitbake -k core-image-sato

## 2.2 Flash image

**Get the ${DISK} of your SD Card with `sudo fdisk -l` command**

    sudo bmaptool copy tmp/deploy/images/raspberrypi3-64/core-image-sato-raspberrypi3-64.wic /dev/sd${DISK}

# 3. Bake Raspberrypi3 SDK (Cross Toolchain)

## 3.1 Trigger build engine to do so

    bitbake core-image-sato -c populate_sdk

## 3.2 Install SDK

    ./tmp/deploy/sdk/chruselpoky-glibc-x86_64-core-image-sato-aarch64-raspberrypi3-64-toolchain-2.7.sh
