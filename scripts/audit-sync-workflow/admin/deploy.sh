#!/bin/sh

workflowDir="/Volumes/staging"

rsync ../audit/ $workflowDir/audit/scripts
rsync ../fix/ $workflowDir/fix/scripts
rsync ../sync/ $workflowDir/sync/scripts
