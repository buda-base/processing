#!/bin/sh

work=$1
scriptsDir="/Users/tbrc/staging/scripts"

pushd $work/images
sh ${scriptsDir}/rename_all.sh
popd
