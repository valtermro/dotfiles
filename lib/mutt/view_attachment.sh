#!/usr/bin/env bash
#
# This script is a condensed version of Eric Gebhart's view_attachment.sh, modified
# to work with on linux systems where `open` should be replaced with `xdg-open` 
#
# The original script can be found here > https://git.io/v9Jac.
#
attach=$1
type=$2
tmp_dir=/tmp/mutt_attachements
mkdir -p $tmp_dir

# get only the attachment's name
filename=$(basename $attach)

# and remove it's extension
name=$(echo $filename | cut -d '.' -f 1)

# if the type is '-' then we don't want to mess with type.
# Otherwise we are rebuilding the name.
if [ $type = "-" ]; then
    newfile=$tmp_dir/$filename
else
    newfile=$tmp_dir/$name.$type
fi

# move the attachment to a safe place so it won't be removed before we can open it
cp $attach $newfile

xdg-open $newfile
