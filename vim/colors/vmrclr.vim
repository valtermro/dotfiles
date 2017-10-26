" This colorscheme is a slightly modified version of the 16-color version of
" https://github.com/chriskempson/base16-vim/blob/master/colors/base16-tomorrow-night.vim
" and is meant for use with the terminal vim only.

"= Theme setup {{{1
"==================================================
hi clear
syntax reset
let g:colors_name = 'vmrclr'

" enable italics
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
"= endsection }}}1

"= Editor colors {{{1
"==================================================
hi Normal       ctermfg=15  ctermbg=none
hi Debug        ctermfg=9
hi Directory    ctermfg=12               cterm=bold
hi Error        ctermfg=9  ctermbg=none  cterm=underline
hi SpecialKey   ctermfg=8
hi NonText      ctermfg=8
hi Visual       ctermbg=0
hi WildMenu     ctermfg=15 ctermbg=0
hi Title        ctermfg=12               cterm=none
hi Conceal      ctermfg=12 ctermbg=none

hi ErrorMsg     ctermfg=9  ctermbg=none
hi ModeMsg      ctermfg=10               cterm=none
hi MoreMsg      ctermfg=10
hi Question     ctermfg=11
hi WarningMsg   ctermfg=11

hi Search       ctermfg=0  ctermbg=11
hi IncSearch    ctermfg=0  ctermbg=11 cterm=none

hi VertSplit    ctermfg=8  ctermbg=8  cterm=none
hi StatusLine   ctermfg=0  ctermbg=8  cterm=none
hi StatusLineNC ctermfg=8  ctermbg=0  cterm=none
" NOTE: This is a non-standard group
hi StatusLineWarning ctermfg=0  ctermbg=9 cterm=italic

hi ColorColumn             ctermbg=0  cterm=none
hi CursorColumn            ctermbg=0  cterm=none
hi CursorLine              ctermbg=0  cterm=none
hi QuickFixLine            ctermbg=0  cterm=none

hi LineNr       ctermfg=8  ctermbg=0
hi CursorLineNr ctermfg=6  ctermbg=0
hi SignColumn   ctermfg=8  ctermbg=0
hi FoldColumn   ctermfg=8  ctermbg=0
hi Folded       ctermfg=8  ctermbg=none

hi TabLineSel   ctermfg=15 ctermbg=0  cterm=none
hi TabLine      ctermfg=8  ctermbg=0  cterm=none
hi TabLineFill  ctermfg=8  ctermbg=0  cterm=none

hi PMenu        ctermfg=8  ctermbg=0  cterm=none
hi PMenuSel     ctermfg=0  ctermbg=8
hi PmenuSbar    ctermbg=0
hi PmenuThumb   ctermbg=8

hi Bold        cterm=bold
hi Italic      cterm=none
hi Underlined  ctermfg=9
"= endsection }}}1

"= Syntax highlighting {{{1
"==================================================
"- Standard {{{2
"--------------------------------------------------
hi Keyword      ctermfg=13
hi Statement    ctermfg=13
hi Structure    ctermfg=13
hi Type         ctermfg=13
hi Function     ctermfg=13
hi Identifier   ctermfg=9
hi Constant     ctermfg=9
hi String       ctermfg=10
hi Delimiter    ctermfg=14
hi Label        ctermfg=11
hi Special      ctermfg=14
hi Tag          ctermfg=12 cterm=underline
hi Typedef      ctermfg=11
hi StorageClass ctermfg=13
hi PreProc      ctermfg=11
hi Define       ctermfg=13 cterm=none
hi Include      ctermfg=12
hi Operator     ctermfg=15 cterm=none
hi Comment      ctermfg=8
hi MatchParen              ctermbg=none  cterm=underline
hi Todo         ctermfg=11 ctermbg=none  cterm=italic
hi link Exception   Keyword
hi link Conditional Keyword
hi link Repeat      Keyword
hi link Boolean     Constant
hi link Character   Constant
hi link Number      Constant
hi link Float       Constant
hi link SpecialChar Special

"- Vim highlighting {{{2
"--------------------------------------------------
hi VimGroup ctermfg=11
hi link VimOption    Identifier
hi link VimHighlight Keyword
hi link VimAutoEvent Normal

"- C/C++ highlighting {{{2
"--------------------------------------------------
hi cOperator ctermfg=14
hi link cDefine    Define
hi link cPreCondit PreProc

"- CSS highlighting {{{2
"--------------------------------------------------
hi cssColor        ctermfg=14
hi cssClassName    ctermfg=13
hi cssIdentifier   ctermfg=12
hi cssFunctionName ctermfg=14
hi link cssBraces            Normal
hi link cssSelectorOp        Normal
hi link cssAttributeSelector Normal

"- Diff highlighting {{{2
"--------------------------------------------------
hi DiffAdd     ctermfg=10 ctermbg=0
hi DiffChange  ctermfg=8  ctermbg=0
hi DiffDelete  ctermfg=9  ctermbg=0
hi DiffText    ctermfg=12 ctermbg=0
hi DiffAdded   ctermfg=10 ctermbg=0
hi DiffFile    ctermfg=9  ctermbg=0
hi DiffNewFile ctermfg=10 ctermbg=0
hi DiffLine    ctermfg=12 ctermbg=0
hi DiffRemoved ctermfg=9  ctermbg=0

"- Git highlighting {{{2
"--------------------------------------------------
hi gitcommitBranch        ctermfg=9
hi gitcommitHeader        ctermfg=13
hi gitcommitOverflow      ctermfg=9
hi gitcommitSummary       ctermfg=10
hi gitcommitDiscardedType ctermfg=12
hi gitcommitSelectedType  ctermfg=12
hi gitcommitUnmergedType  ctermfg=12
hi gitcommitDiscardedFile ctermfg=9
hi gitcommitSelectedFile  ctermfg=10
hi gitcommitUnmergedFile  ctermfg=9
hi gitcommitUntrackedFile ctermfg=11
hi link gitcommitComment    Comment
hi link gitcommitOnBranch   Comment
hi link gitcommitDiscarded  Comment
hi link gitcommitSelected   Comment
hi link gitcommitUntracked  Comment

"- HTML highlighting {{{2
"--------------------------------------------------
hi htmlArg ctermfg=12
hi htmlH1  cterm=bold
hi htmlH2  cterm=bold
hi htmlH3  cterm=bold
hi htmlH4  cterm=bold
hi htmlH5  cterm=bold
hi htmlH6  cterm=bold
hi htmlBold                 cterm=bold
hi htmlItalic               cterm=italic
hi htmlUnderline            cterm=underline
hi htmlBoldItalic           cterm=bold,italic
hi htmlBoldUnderline        cterm=bold,underline
hi htmlBoldUnderlineItalic  cterm=bold,underline,italic
hi htmlUnderlineItalic      cterm=underline,italic
hi link htmlTag         Normal
hi link htmlEndTag      Normal

"- JavaScript highlighting {{{2
"--------------------------------------------------
" groups prefixed with 'js' come from `pangloss/vim-javascript`
hi javascriptDocNotation ctermfg=12
hi javascriptDocTags     ctermfg=12 cterm=italic
hi jsBuiltins            ctermfg=11
hi link javascriptDocParamName Identifier
hi link javaScript             Normal
hi link javaScriptBraces       Normal
hi link jsClassDefinition      Normal
hi link jsArrowFunction        Normal
hi link jsRegexpString         Special
hi link jsRegexpCharClass      Identifier
hi link jsFuncName             Normal
hi link jsFuncCall             Normal
hi link jsClassFuncName        Normal
hi link jsReturn               Keyword
hi link jsFunction             Function
hi link jsThis                 Identifier
hi link jsSuper                Identifier
hi link jsAsyncKeyword         Statement
hi link jsForAwait             Statement
hi link jsStorageClass         StorageClass
hi link jsGlobalObjects        jsBuiltins
hi link jsGlobalNodeObjects    jsBuiltins
hi link jsExceptions           jsBuiltins
hi link jsClassMethodType      Type

"- PHP highlighting {{{2
"--------------------------------------------------
hi phpDocTags         ctermfg=12 cterm=italic
hi phpFunctions       ctermfg=12
hi phpSpecialFunction ctermfg=12
hi phpComparison      ctermfg=15
hi link phpMemberSelector  Normal
hi link phpInclude         phpStructure
hi link phpParent          Normal
hi link phpDocParam        Type

"- Markdown highlighting {{{2
"--------------------------------------------------
hi markdownCode             ctermfg=11
hi markdownHeadingDelimiter ctermfg=12
hi markdownH1               ctermfg=12
hi markdownH2               ctermfg=12
hi markdownH3               ctermfg=12
hi markdownH4               ctermfg=12
hi markdownH5               ctermfg=12
hi markdownH6               ctermfg=12

"- NERDTree highlighting {{{2
"--------------------------------------------------
hi NERDTreeExecFile   ctermfg=10
hi NERDTreeDir        ctermfg=12
hi NERDTreeDir        ctermfg=12
hi NERDTreeUp         ctermfg=12
hi NERDTreeOpenable   ctermfg=12
hi NERDTreeClosable   ctermfg=12
hi NERDTreeLinkTarget ctermfg=14
hi NERDTreeLinkFile   ctermfg=14
hi NERDTreeLinkDir    ctermfg=14
hi link NERDTreeDirSlash Normal

"- SASS/SCSS highlighting {{{2
"--------------------------------------------------
hi link sassDefinition         Keyword
hi link scssImport             Include
hi link scssMixin              Statement
hi link scssMixinName          Normal
hi link scssFunctionDefinition scssMixin
hi link scssFunctionName       scssMixinName
hi link scssInclude            Statement

"- Spelling highlighting {{{2
"--------------------------------------------------
hi SpellBad   ctermbg=none  cterm=undercurl
hi SpellLocal ctermbg=none  cterm=undercurl
hi SpellCap   ctermbg=none  cterm=undercurl
hi SpellRare  ctermbg=none  cterm=undercurl
"= endsection }}}1
