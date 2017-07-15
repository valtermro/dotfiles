if exists('b:current_syntax')
  finish
endif

"= Template {{{1
"==================================================
syn region vueTemplate keepend start=+<template+ end=+</template>+ fold contains=@vueTemplate,vueRegionTag
syn include @vueTemplate syntax/html.vim
unlet! b:current_syntax
" load parts of https://github.com/othree/html5.vim
syn include @vueTemplate <sfile>:p:h:h/pack/valtermro/start/html5.vim/syntax/html/aria.vim
unlet! b:current_syntax

syn keyword htmlArg contained key ref slot
syn match htmlArg contained +v-\(bind\|cloak\|else\|else-if\|for\|html\|if\|model\|on\|once\|pre\|show\|text\)+
syn match htmlArg contained +\:[^=]\++hs=s+1
syn match htmlArg contained +@[^.=]\++hs=s+1
"= endsection }}}

"= Script {{{1
"==================================================
syn region vueScript keepend start=+<script+ end=+</script>+ fold contains=@vueScript,vueRegionTag,vueTagStart
syn include @vueScript syntax/javascript.vim
unlet! b:current_syntax
"= endsection }}}

"= Scss {{{1
"==================================================
syn region vueScss keepend start=+<style+ end=+</style>+ fold contains=@vueScss,vueRegionTag
" load https://github.com/cakebaker/scss-syntax.vim
syn include @vueScss <sfile>:p:h:h/pack/valtermro/start/scss-syntax.vim/syntax/scss.vim
unlet! b:current_syntax
"= endsection }}}

syn keyword vueRegionTag template script style
hi! link vueRegionTag Identifier

let b:current_syntax = "vue"
