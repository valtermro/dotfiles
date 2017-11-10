if exists('b:did_ftplugin')
  finish
endif
let b:did_ftplugin = 1

setlocal suffixesadd+=.vue
setlocal suffixesadd+=.scss
setlocal iskeyword+=-
setlocal matchpairs=(:),{:},[:],<:>

if exists('loaded_matchit')
  let b:match_ignorecase = 1
  let b:match_words = '<:>,' .
    \ '<\@<=[ou]l\>[^>]*\%(>\|$\):<\@<=li\>:<\@<=/[ou]l>,' .
    \ '<\@<=dl\>[^>]*\%(>\|$\):<\@<=d[td]\>:<\@<=/dl>,' .
    \ '<\@<=\([^/][^ \t>]*\)[^>]*\%(>\|$\):<\@<=/\1>'
endif
