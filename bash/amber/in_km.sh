#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.3.5-alpha
# date: 2025-01-05 09:26:59
cd $(mktemp -d --suffix=nvidia);
__AS=$?
__AMBER_VAL_0=$(uname -m);
__AS=$?;
if [ $__AS != 0 ]; then
    echo "Falhou"
fi;
__0_arch="${__AMBER_VAL_0}"
__AMBER_VAL_1=$(rpm -E %fedora);
__AS=$?;
if [ $__AS != 0 ]; then
    echo "Falhou"
fi;
__1_version="${__AMBER_VAL_1}"
__2_kernel="6.12.8"
akmodsbuild /usr/src/akmods/nvidia-kmod.latest -k ${__2_kernel}-fc${__1_version}.${__0_arch};
__AS=$?;
if [ $__AS != 0 ]; then
    echo "Falhou"
fi
 dnf install ./*.rpm ;
__AS=$?;
if [ $__AS != 0 ]; then
    echo "Falhou"
fi
