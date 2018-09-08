#!/bin/bash

VOLUME_LIST=./volume.list

function create_dir() {
  target_dir=$1
  echo "Target DIR : $target_dir"
  if [ -d ${target_dir} ]; then
    chmod 777 ${target_dir}
  else
    echo "  Create Directry Start."
    mkdir -p -m777 ${target_dir}
    if [ $? -gt 0 ]; then
      echo "  [Error]Create Directory failed."
      exit 1
    else
      echo "  done"
    fi
  fi
}

cat ${VOLUME_LIST} | while read line
do
  create_dir $line
done


exit 0
