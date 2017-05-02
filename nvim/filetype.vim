" neovim's ftdetect and ftplugin directories may cause problems with some plugins

augroup filetype_detect
  autocmd!
  autocmd BufRead,BufNewFile *.tmux setf tmux
  autocmd BufRead,BufNewFile *.mutt setf muttrc
  autocmd BufRead,BufNewFile *.blade.php setf blade
augroup END

augroup filetype_plugin
  autocmd FileType php,blade setl tabstop=4 | setl softtabstop=4 | setl shiftwidth=4
  autocmd FileType python setl tabstop=4 | setl softtabstop=4 | setl shiftwidth=4
  autocmd FileType xml setl tabstop=4 | setl softtabstop=4 | setl shiftwidth=4
augroup END

