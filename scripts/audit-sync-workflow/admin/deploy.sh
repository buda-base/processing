#!/bin/sh

workflowDir="/Volumes/staging"

while [ ! $# -eq 0 ]; do

  case "$1" in

    --init | -i)

      mkdir -p $workflowDir/audit/logs
      mkdir -p $workflowDir/audit/scripts
      mkdir -p $workflowDir/audit/works
      mkdir -p $workflowDir/sync/logs
      mkdir -p $workflowDir/sync/scripts
      mkdir -p $workflowDir/sync/works
      mkdir -p $workflowDir/done

      exit
      ;;

    --update | -u)
      
      rsync -av ../audit/ $workflowDir/audit/scripts
      rsync -av ../sync/ $workflowDir/sync/scripts

      exit
      ;;

  esac

  shift
done

