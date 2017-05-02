#!/usr/bin/env bash

ignored_mailboxes=('Deleted' 'Drafts' 'Sent')
count=0

# if offlineimap isn't running, do nothing
if [[ ! $(ps aux | grep $(which offlineimap)$) ]]; then
  exit 0
fi

# offlineimap is configured to store emails in directories named after the account
# names and stored in `$X_VAR_HOME/mail`
accounts=$(ls $X_VAR_HOME/mail/)

# iterate over each account directory, read the `new` folder of each mailbox,
# skipping those listed in `$ignored_mailboxes` and increment `$count` by each
# file in there
for account in $accounts; do
  for folder in $(ls $X_VAR_HOME/mail/$account); do
    if [[ "${ignored_mailboxes[@]}" =~ "${folder}" ]]; then
      continue
    fi
    let count+=$(ls $X_VAR_HOME/mail/$account/$folder/new/* | wc -l)
  done
done

# let tmux know how many new emails where found
echo "✉ $count "
