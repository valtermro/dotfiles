" Colorscheme based on (~copied~ from) https://github.com/chriskempson/base16-vim/blob/master/colors/base16-solarized-dark.vim

" TODO: The dark and light colorschemes share a lot of code. Find a
"       way to remove/reduce that duplication. Or, should I? Maybe. I don't know...

"= Colors {{{1
"==================================================
" Regular 16color palette
let s:color0 = 0
let s:color1 = 9
let s:color2 = 2
let s:color3 = 3
let s:color4 = 4
let s:color5 = 5
let s:color6 = 6
let s:color7 = 7
let s:color8 = 8

" Special colors
let s:color_fg_normal = 23
let s:color_bg_accent = 28
"= endsection }}}1

"= Theme setup {{{1
"==================================================
hi clear
syntax reset
let g:colors_name = 'dark'

" enable italics
let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
"= endsection }}}1

"= Editor colors {{{1
"==================================================
exec 'hi Normal            ctermfg='.s:color_fg_normal.' ctermbg='.s:color0
exec 'hi Debug             ctermfg='.s:color1
exec 'hi Directory         ctermfg='.s:color4
exec 'hi Error             ctermfg='.s:color7.' ctermbg='.s:color1
exec 'hi SpecialKey        ctermfg='.s:color8
exec 'hi NonText           ctermfg='.s:color8
exec 'hi Visual                                 ctermbg='.s:color_bg_accent
exec 'hi WildMenu          ctermfg='.s:color0.' ctermbg='.s:color3
exec 'hi Title             ctermfg='.s:color6
exec 'hi Conceal           ctermfg='.s:color6.' ctermbg='.s:color0
exec 'hi MatchParen                             ctermbg='.s:color_bg_accent.' cterm=underline'

exec 'hi ModeMsg           ctermfg='.s:color3.' cterm=none'
exec 'hi MoreMsg           ctermfg='.s:color3
exec 'hi ErrorMsg          ctermfg='.s:color0.' ctermbg='.s:color1
exec 'hi WarningMsg        ctermfg='.s:color0.' ctermbg='.s:color3
exec 'hi Question          ctermfg='.s:color3

exec 'hi Search            ctermfg='.s:color0.' ctermbg='.s:color3
exec 'hi IncSearch         ctermfg='.s:color0.' ctermbg='.s:color3.' cterm=none'

exec 'hi VertSplit         ctermfg='.s:color0.'          ctermbg='.s:color8.' cterm=none'
exec 'hi StatusLine        ctermfg='.s:color0.'          ctermbg='.s:color8.' cterm=none'
exec 'hi StatusLineNC      ctermfg='.s:color_fg_normal.' ctermbg='.s:color_bg_accent.' cterm=none'
exec 'hi StatusLineWarning ctermfg='.s:color0.'          ctermbg='.s:color1.'  cterm=italic'

exec 'hi ColorColumn       ctermbg='.s:color_bg_accent.' cterm=none'
exec 'hi CursorColumn      ctermbg='.s:color_bg_accent.' cterm=none'
exec 'hi CursorLine        ctermbg='.s:color_bg_accent.' cterm=none'
exec 'hi QuickFixLine      ctermbg='.s:color_bg_accent.' cterm=none'

exec 'hi LineNr            ctermfg='.s:color8.' ctermbg=none'
exec 'hi SignColumn        ctermfg='.s:color8.' ctermbg=none'
exec 'hi FoldColumn        ctermfg='.s:color8.' ctermbg=none'
exec 'hi CursorLineNr      ctermfg='.s:color8.' ctermbg=none'
exec 'hi Folded            ctermfg='.s:color8.' ctermbg=none cterm=italic'

exec 'hi TabLineSel        ctermfg='.s:color_fg_normal.' ctermbg='.s:color0.' cterm=none'
exec 'hi TabLine           ctermfg='.s:color8.'          ctermbg='.s:color_bg_accent.' cterm=none'
exec 'hi TabLineFill                                     ctermbg='.s:color_bg_accent.' cterm=none'

exec 'hi PMenu             ctermfg='.s:color8.' ctermbg='.s:color_bg_accent
exec 'hi PMenuSel          ctermfg='.s:color0.' ctermbg='.s:color8
exec 'hi PmenuSbar         ctermbg='.s:color8
exec 'hi PmenuThumb        ctermbg='.s:color0

exec 'hi Bold              cterm=bold'
exec 'hi Italic            cterm=italic'
exec 'hi Underlined        ctermfg='.s:color1. 'cterm=none'
"= endsection }}}1

"= Syntax highlighting {{{1
"==================================================
"- Custom (Base) {{{2
"--------------------------------------------------
exec 'hi DocTags      ctermfg='.s:color_fg_normal

"- Standard {{{2
"--------------------------------------------------
exec 'hi Keyword    ctermfg='.s:color5
exec 'hi Statement  ctermfg='.s:color1
exec 'hi Structure  ctermfg='.s:color4
exec 'hi Type       ctermfg='.s:color3
exec 'hi Identifier ctermfg='.s:color1.' cterm=none'
exec 'hi Constant   ctermfg='.s:color1
exec 'hi String     ctermfg='.s:color2
exec 'hi Delimiter  ctermfg='.s:color3
exec 'hi Special    ctermfg='.s:color6
exec 'hi Tag        ctermfg='.s:color2
exec 'hi PreProc    ctermfg='.s:color3
exec 'hi Define     ctermfg='.s:color5
exec 'hi Include    ctermfg='.s:color4
exec 'hi Comment    ctermfg='.s:color8
exec 'hi Todo       ctermfg='.s:color3.' ctermbg='.s:color0.' cterm=italic'
hi link Operator     Normal
hi link StorageClass Type
hi link Function     Keyword
hi link Label        Keyword
hi link Exception    Keyword
hi link Conditional  Keyword
hi link Repeat       Keyword
hi link Boolean      Constant
hi link Character    Constant
hi link Number       Constant
hi link Float        Constant
hi link SpecialChar  Special
hi link Typedef      Statement

"- Vim highlighting {{{2
"--------------------------------------------------
exec 'hi vimGroup        ctermfg='.s:color3
exec 'hi vimCommentTitle ctermfg='.s:color3
exec 'hi vimCommand      ctermfg='.s:color5
hi link vimHiGroup   vimGroup
hi link vimOption    Identifier
hi link vimHiAttrib  Constant
hi link vimHighlight Keyword
hi link vimAutoEvent Normal
hi link vimBracket   Normal
hi link vimParenSep  Normal

"- C/C++ highlighting {{{2
"--------------------------------------------------
exec 'hi cOperator ctermfg='.s:color5.' cterm=italic'
hi link cDefine    Define
hi link cPreCondit PreProc

"- CSS highlighting {{{2
"--------------------------------------------------
exec 'hi cssColor             ctermfg='.s:color1
exec 'hi cssClassName         ctermfg='.s:color5
exec 'hi cssFontAttr          ctermfg='.s:color1
exec 'hi cssValueNumber       ctermfg='.s:color1
exec 'hi cssIdentifier        ctermfg='.s:color5
exec 'hi cssFunctionName      ctermfg='.s:color5.' cterm=italic'
exec 'hi cssAttributeSelector ctermfg='s:color_fg_normal.' cterm=italic'
hi link cssSelectorOp        Normal
hi link cssBraces            Normal

"- Diff highlighting {{{2
"--------------------------------------------------
exec 'hi DiffAdd     ctermfg='.s:color0.' ctermbg='.s:color2
exec 'hi DiffDelete  ctermfg='.s:color1.' ctermbg='.s:color1
exec 'hi DiffChange  ctermfg='.s:color7.' ctermbg='.s:color4
exec 'hi DiffText    ctermfg='.s:color0.' ctermbg='.s:color3.' cterm=none'

"- Fugitive highlighting {{{2
"--------------------------------------------------
exec 'hi gitcommitBranch        ctermfg='.s:color2
exec 'hi gitcommitHeader        ctermfg='.s:color5
exec 'hi gitcommitOverflow      ctermfg='.s:color1
exec 'hi gitcommitSummary       ctermfg='.s:color3
exec 'hi gitcommitBlank         ctermfg='.s:color8.' cterm=italic'
exec 'hi gitcommitDiscardedType ctermfg='.s:color4
exec 'hi gitcommitSelectedType  ctermfg='.s:color4
exec 'hi gitcommitUnmergedType  ctermfg='.s:color4
exec 'hi gitcommitDiscardedFile ctermfg='.s:color1
exec 'hi gitcommitSelectedFile  ctermfg='.s:color2
exec 'hi gitcommitUnmergedFile  ctermfg='.s:color1
exec 'hi gitcommitUntrackedFile ctermfg='.s:color3
exec 'hi gitcommitWarning       ctermfg='.s:color8.' cterm=italic'
hi link gitcommitComment    Comment
hi link gitcommitOnBranch   Comment
hi link gitcommitDiscarded  Comment
hi link gitcommitSelected   Comment
hi link gitcommitUntracked  Comment

"- HTML highlighting {{{2
"--------------------------------------------------
exec 'hi htmlTitle   ctermfg='.s:color_fg_normal
exec 'hi htmlTag     ctermfg='.s:color_fg_normal
exec 'hi htmlTagName ctermfg='.s:color1
exec 'hi htmlArg     ctermfg='.s:color4
exec 'hi htmlH1      ctermfg='.s:color_fg_normal.' cterm=none'
exec 'hi htmlH2      ctermfg='.s:color_fg_normal.' cterm=none'
exec 'hi htmlH3      ctermfg='.s:color_fg_normal.' cterm=none'
exec 'hi htmlH4      ctermfg='.s:color_fg_normal.' cterm=none'
exec 'hi htmlH5      ctermfg='.s:color_fg_normal.' cterm=none'
exec 'hi htmlH6      ctermfg='.s:color_fg_normal.' cterm=none'
hi htmlBold                cterm=none
hi htmlItalic              cterm=none
hi htmlUnderline           cterm=none
hi htmlBoldItalic          cterm=none
hi htmlBoldUnderline       cterm=none
hi htmlBoldUnderlineItalic cterm=none
hi htmlUnderlineItalic     cterm=none
hi link htmlEndTag  htmlTag

"- JavaScript highlighting {{{2
"--------------------------------------------------
" groups prefixed with 'js' come from `pangloss/vim-javascript`
" TODO: why doesn't pangloss/vim-javascript work on all machines??
exec 'hi javascriptType ctermfg='.s:color3
hi link javascriptDocNamedParamType javascriptDocParamType
hi link jsBuiltins                  javascriptType
hi link javascriptDocTags           DocTags
hi link javascriptDocParamName      DocTags
hi link javascriptDocNotation       DocTags
hi link javascriptDocParamType      Special
hi link javaScript                  Normal
hi link javaScriptBraces            Normal
hi link jsClassDefinition           Normal
hi link jsArrowFunction             Normal
hi link jsRegexpString              Special
hi link jsRegexpCharClass           Identifier
hi link jsFuncName                  Normal
hi link jsFuncCall                  Normal
hi link jsClassFuncName             Normal
hi link jsReturn                    Statement
hi link jsFunction                  Function
hi link jsThis                      Identifier
hi link jsSuper                     Identifier
hi link jsAsyncKeyword              Statement
hi link jsForAwait                  Statement
hi link jsStorageClass              StorageClass
hi link jsGlobalObjects             jsBuiltins
hi link jsGlobalNodeObjects         jsBuiltins
hi link jsExceptions                jsBuiltins
hi link jsClassMethodType           Type

"- PHP highlighting {{{2
"--------------------------------------------------
exec 'hi phpFunctions ctermfg='.s:color4
hi link phpComparison      Normal
hi link phpDocTags         DocTags
hi link phpDocCustomTags   DocTags
hi link phpClasses         Normal
hi link phpMemberSelector  Normal
hi link phpInclude         Include
hi link phpDefine          Keyword
hi link phpStorageClass    Keyword
hi link phpParent          Normal

"- Markdown highlighting {{{2
"--------------------------------------------------
exec 'hi markdownCode             ctermfg='.s:color3
exec 'hi markdownCodeDelimiter    ctermfg='.s:color4.' cterm=italic'
exec 'hi markdownHeadingRule      ctermfg='.s:color3
exec 'hi markdownHeadingDelimiter ctermfg='.s:color4
exec 'hi markdownH1               ctermfg='.s:color4
exec 'hi markdownH2               ctermfg='.s:color4
exec 'hi markdownH3               ctermfg='.s:color4
exec 'hi markdownH4               ctermfg='.s:color4
exec 'hi markdownH5               ctermfg='.s:color4
exec 'hi markdownH6               ctermfg='.s:color4

"- NERDTree highlighting {{{2
"--------------------------------------------------
exec 'hi NERDTreeCWD        ctermfg='.s:color6
exec 'hi NERDTreeUp         ctermfg='.s:color8
exec 'hi NERDTreeExecFile   ctermfg='.s:color2
exec 'hi NERDTreeLinkTarget ctermfg='.s:color8
hi link NERDTreeFile     Normal
hi link NERDTreeLinkFile Normal
hi link NERDTreeDir      Directory
hi link NERDTreeOpenable Directory
hi link NERDTreeClosable Directory
hi link NERDTreeLinkDir  Directory
hi link NERDTreeDirSlash Normal

"- SASS/SCSS highlighting {{{2
"--------------------------------------------------
hi link sassDefinition         Keyword
hi link sassControl            Keyword
hi link sassFor                sassControl
hi link sassMixin              Statement
hi link sassMixinName          Normal
hi link sassFunctionDecl       sassMixin
hi link sassFunctionName       sassMixinName
hi link sassInclude            Include
hi link sassMixing             Statement
hi link scssContent            Keyword
hi link scssImport             sassInclude
hi link scssInclude            sassMixing
hi link scssMixin              sassMixin
hi link scssMixinName          scssMixinName
hi link scssFunctionDefinition sassFunctionDecl
hi link scssFunctionName       sassFunctionName
hi link scssIf                 sassControl
hi link scssElse               sassControl

"- Shell {{{2
"--------------------------------------------------
exec 'hi shDerefSimple ctermfg='.s:color3
exec 'hi shDerefVar    ctermfg='.s:color_fg_normal
hi link shFunction    Normal

"- Spelling highlighting {{{2
"--------------------------------------------------
hi SpellBad   ctermbg=none cterm=underline
hi SpellLocal ctermbg=none cterm=underline
hi SpellCap   ctermbg=none cterm=underline
hi SpellRare  ctermbg=none cterm=underline
"= endsection }}}1

"= Cleanup {{{1
"==================================================
unlet s:color0 s:color1 s:color2 s:color3 s:color4 s:color5 s:color6 s:color7 s:color8
unlet s:color_fg_normal s:color_bg_accent
"= endsection }}}1
