#!/usr/bin/env bash

if [ -z "$toolchains_base" ]; then
  echo "fatal: \$toolchain_base is undefined!";
  exit;
fi

# Please don't change this.
kos_base=$toolchains_base/kos
newlib_inc=$toolchains_base/sh-elf/sh-elf/include

while [ "$1" != "" ]; do
    PARAM=`echo $1 | awk -F= '{print $1}'`
    case $PARAM in
        --verbose)
			VERBOSE=1
            ;;
        *)
            echo "ERROR: unknown parameter \"$PARAM\""
            exit 1
            ;;
    esac
    shift
done

# In original dc-chain Makefile, the instructions below are symbolic links.
# But the "ln" tool under MinGW is not working properly.
# So each time you update KallistiOS, you'll need to run this tool to update 
# the includes used by the SH-4 compiler.
cp -r $kos_base/include/kos $newlib_inc
cp -r $kos_base/kernel/arch/dreamcast/include/arch $newlib_inc
cp -r $kos_base/kernel/arch/dreamcast/include/dc $newlib_inc

# These instructions are just fail-safes, as in the original dc-chain Makefile,
# they are already "cp" instructions.
cp $kos_base/include/pthread.h $newlib_inc
cp $kos_base/include/sys/_pthread.h $newlib_inc/sys
cp $kos_base/include/sys/sched.h $newlib_inc/sys

if [ -n "$VERBOSE" ]; then
    echo "Done!";
fi
