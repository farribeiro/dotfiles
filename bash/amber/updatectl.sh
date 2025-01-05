#!/usr/bin/env bash
# Written in [Amber](https://amber-lang.com/)
# version: 0.3.5-alpha
# date: 2025-01-05 09:23:01
__AMBER_VAL_0=$(updatectl check);
__AS=$?;
if [ $__AS != 0 ]; then
    echo "Falhou"
fi;
__0_ok="${__AMBER_VAL_0}"
if [ "${__0_ok}" != 0 ]; then
    updatectl update;
    __AS=$?;
if [ $__AS != 0 ]; then
        echo "Falhou"
fi
fi
