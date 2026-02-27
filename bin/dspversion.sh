#!/bin/sh
#²é¿´zsp°æ±¾ºÅ

if [ 0 -eq $# ]; then
    sndhlp 0 0x2000e136 0x36 8 0 0;
    return 0;
else
    echo "ERROR::input para is not right!";
    return 1;
fi