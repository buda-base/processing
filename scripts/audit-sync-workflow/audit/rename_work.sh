#!/bin/sh

work=$1
scriptsDir="/Volumes/staging/audit/scripts"

pushd ../works/$work/images
sh ${scriptsDir}/rename_all.sh
popd > /dev/null
