#!/bin/sh

work=$1
scriptsDir="

pushd $work/images
sh ${scriptsDir}/rename_all.sh
popd
