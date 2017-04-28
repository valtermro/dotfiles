# vim: ts=2 sts=2 sw=2

from subprocess import check_output

# A dictionary of folders that should be synced, in the format:
# <account>: {
#   <remote_name>: <local_name>,
#   ...
#  }
folders = {
  'valtermro@outlook.com': {
    'Inbox': 'Inbox',
    'Drafts': 'Drafts',
    'Sent': 'Sent',
    'Arquivo Morto': 'Archive',
    'Github': 'Github',
  }
}

def get_pass(account):
  return check_output('pass mail/' + account, shell=True).splitlines()[0]

def folder_filter(account):
  return lambda folder: folder in folders[account]

def name_trans(direction, account):
  if direction == 'remote-local':
    names = {v: k for k, v in folders[account].iteritems()}
  else:
    names = folders[account]
  return lambda folder: names.get(folder, folder)
