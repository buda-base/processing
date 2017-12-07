#/bin/sh

output=$(snowball ls s3://archive.tbrc.org/W00EGS1016789123 2>&1)
if [[ "$output" = *"Cannot find"* ]]; then
  echo "***$output***"
fi
