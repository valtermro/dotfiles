if exists('b:current_syntax')
  finish
endif

let s:pack_start = expand('~/.vim/pack/*/start')

"= Html template {{{1
"==================================================
syn region vueHtml keepend fold contains=@vueHtml,vueRegionTag
    \ start="^<template.*>" end="^</template>"

syn include @vueHtml syntax/html.vim
unlet! b:current_syntax

" load parts of https://github.com/othree/html5.vim
exec 'syn include @vueHtml '.s:pack_start.'/html5.vim/syntax/html.vim'
exec 'syn include @vueHtml '.s:pack_start.'/html5.vim/syntax/html/aria.vim'
unlet! b:current_syntax

syn keyword htmlArg contained key ref slot
syn match htmlArg contained "v-\(bind\|cloak\|else\|else-if\|for\|html\|if\|model\|on\|once\|pre\|show\|text\)"
syn match htmlArg contained "\:[^=]\+"hs=s+1
syn match htmlArg contained "@[^.=]\+"hs=s+1
"= endsection }}}

"= Javascript {{{1
"==================================================
syn region vueJavascript keepend fold contains=@vueJavascript,vueRegionTag
    \ start="^<script.*>" end="^</script>"
syn include @vueJavascript syntax/javascript.vim
unlet! b:current_syntax
"= endsection }}}

"= Scss {{{1
"==================================================
syn region vueScss keepend fold contains=@vueScss,vueRegionTag
    \ start="^<style.*>" end="^</style>"

" load https://github.com/cakebaker/scss-syntax.vim
exec 'syn include @vueScss '.s:pack_start.'/scss-syntax.vim/syntax/scss.vim'
unlet! b:current_syntax
"= endsection }}}

"= Misc {{{1
"==================================================
syn match vueRegionTag contained contains=vueRegionTagName,vueRegionTagArg,vueRegionTagString
    \ "^</\?\(template\|script\|style\).*>"
syn keyword vueRegionTagName contained template script style
syn keyword vueRegionTagArg contained lang
syn match vueRegionTagString contained +=\zs['"].*['"]+
"= endsection }}}

"= Default colors {{{1
"==================================================
hi default link vueRegionTag       htmlTag
hi default link vueRegionTagName   htmlTagName
hi default link vueRegionTagArg    htmlArg
hi default link vueRegionTagString htmlString
"= endsection }}}

let b:current_syntax = 'vue'
unlet s:pack_start
