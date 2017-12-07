#!/bin/sh

work=$1
scriptsDir="/Users/tbrc/staging/processing/scripts/travis-sandbox"

pushd $work/images
sh ${scriptsDir}/rename_all.sh
popd
