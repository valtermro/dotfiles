#!/usr/bin/env bash

ignored_mailboxes=('Deleted' 'Drafts' 'Sent')
count=0

# if offlineimap isn't running, do nothing
if [[ ! $(which offlineimap) || ! $(ps aux | grep $(which offlineimap)$) ]]; then
  exit 0
fi

# offlineimap is configured to store emails in directories named `/var/mail/$USER/<account>`
accounts=$(ls /var/mail/$USER)

# iterate over each account directory, read the `new` folder of each mailbox,
# skipping those listed in `$ignored_mailboxes` and increment `$count` by each
# file in there
for account in $accounts; do
  for folder in $(ls /var/mail/$USER/$account); do
    if [[ "${ignored_mailboxes[@]}" =~ "${folder}" ]]; then
      continue
    fi
    let count+=$(ls /var/mail/$USER/$account/$folder/new/* | wc -l)
  done
done

# let tmux know how many new emails where found
echo "✉ $count "
