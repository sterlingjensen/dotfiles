" Vundle {{{
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" Plugins
Plugin 'gmarik/Vundle.vim'
Plugin 'Valloric/YouCompleteMe'
Plugin 'SirVer/ultisnips'
Plugin 'dhruvasagar/vim-table-mode'

" Color schemes
Plugin 'altercation/vim-colors-solarized'

call vundle#end()
filetype plugin indent on
" }}}
" Appearance {{{
syntax enable
set background=dark
set t_Co=16
colorscheme solarized
" Line numbers
set number
" Detect filetype
filetype indent plugin on
syntax enable "Default highlighting
syntax on  " Custom highlighting
set cursorline
set colorcolumn=80
" Use visual bell instead of beeping when doing something wrong
set visualbell
set foldmethod=syntax
set history=10000
set foldlevelstart=9
" }}}
" Plugin settings {{{
" ycm {{{
" Silence User defined completion messages
set shortmess+=c
" Number of chars for identifier-based completion suggestions. (2)
let g:ycm_min_num_of_chars_for_completion = 2
" Number of chars required for completion candidate to show in popup. (0)
let g:ycm_min_num_identifier_candidate_chars = 2
" Enable auto popup. (1)
let g:ycm_auto_trigger = 1
" Whitelist, vim dictionary - key is the filename and value doesn't matter.
let g:ycm_filetype_whitelist = { '*':1 }
"" Log to vim instead of file. (0)
"let g:ycm_server_use_vim_stdout = 0
"" (0)
let g:ycm_autoclose_preview_window_after_completion = 0 " (0)
let g:ycm_autoclose_preview_window_after_insertion = 0
let g:ycm_confirm_extra_conf = 0   " Annoying popup. (1)
let g:ycm_complete_in_comments = 0 " Enable matching in comments (0)

" Vim preview window:
"let g:ycm_autoclose_preview_window_after_completion = 0 " (0)
let g:ycm_autoclose_preview_window_after_insertion = 1 " Close after leaving insert mode (0)
" Or you can disable it entirely with:
"set completeopt-=preview
"let g:ycm_add_preview_to_completeopt = 0
"
let g:ycm_global_ycm_extra_conf = expand("~/.vim/bundle/YouCompleteMe/.ycm_extra_conf.py")
"let g:ycm_server_keep_logfiles = 1
"let g:ycm_server_log_level = 'info'
" }}}
" ultisnips {{{
"let g:UltiSnipsUsePythonVersion = 2
"" Default snippet templates found here:
"let g:UltiSnipsSnippetDirectories=[expand("~/.vim/bundle/ultisnips/vim-snippets/UltiSnips")]
"" Private snippet template go here, results of UltiSnipsEdit command, etc
""let g:UltiSnipsSnippetsDir="/home/foxops/.vim/bundle/ultisnips/vim-snippets/UltiSnips/"
""let g:UltiSnipsSnippetsDir=[expand("~/.vim/bundle/ultisnips/myprivate-snippets")]
""let g:UltiSnipsSnippetsDir="~/.vim/bundle/ultisnips/myprivate-snippets"
"let g:UltiSnipsExpandTrigger="<c-j>"
"let g:UltiSnipsJumpForwardTrigger="<c-j>"
"let g:UltiSnipsJumpBackwardTrigger="<c-k>"
"let g:UltiSnipsEditSplit="vertical"
" }}}
" Tagbar {{{
"let g:tagbar_left = 1
"let g:tagbar_width = 40
"let g:tagbar_sort = 0
"let g:tagbar_compact = 1
"let g:tagbar_indent = 1
"let g:tagbar_show_visibility = 0
" }}}
" }}}
" Text editing {{{
" Indentation settings for using 2 spaces instead of tabs.
set shiftwidth=2
set softtabstop=2
set tabstop=2
set expandtab
set backspace=2    " Fix delete and backspace not working over newlines
set textwidth=0    " Prevent hard wrapping
set wrapmargin=0   " .
set formatoptions=tcroqln
set scrolloff=1    " Start scroll before hitting the edge

" Don't screw up folds when inserting text that might affect
" them, until leaving insert mode. Foldmethod is local to the window.
" Protect against screwing up folding when switching between windows.
autocmd! InsertEnter * call TmpFunc1()
   function! TmpFunc1()
      if !exists('w:last_fdm')
         let w:last_fdm=&foldmethod
         setlocal foldmethod=manual
      endif
   endfunction
autocmd! InsertLeave,WinLeave * call TmpFunc2()
   function! TmpFunc2()
      if exists('w:last_fdm')
         let &l:foldmethod=w:last_fdm
         unlet w:last_fdm
      endif
   endfunction

"" Trailing whitespace highlighter TODO: maybe remove
"highlight ExtraWhitespace ctermbg=red guibg=red
"function! s:ToggleWhitespaceMatch(mode)
"  let pattern = (a:mode == 'i') ? '\s\+\%#\@<!$' : '\s\+$'
"  if exists('w:whitespace_match_number')
"    call matchdelete(w:whitespace_match_number)
"    call matchadd('ExtraWhitespace', pattern, 10, w:whitespace_match_number)
"  else
"    " Something went wrong, try to be graceful.
"    let w:whitespace_match_number =  matchadd('ExtraWhitespace', pattern)
"  endif
"endfunction
"augroup WhitespaceMatch
"  " Remove ALL autocommands for the WhitespaceMatch group.
"  autocmd!
"  autocmd BufWinEnter * let w:whitespace_match_number =
"        \ matchadd('ExtraWhitespace', '\s\+$')
"  autocmd InsertEnter * call s:ToggleWhitespaceMatch('i')
"  autocmd InsertLeave * call s:ToggleWhitespaceMatch('n')
"augroup END
" }}}
" Custom tabline {{{
set tabpagemax=100
set showtabline=1 "0: never, 1: if > 1 tabs, 2: always
if exists("+showtabline")
   function! MyTabLine()
      let l:s = ''
      let l:curTab   = tabpagenr()
      let l:tabCount = tabpagenr('$')
      " Adjust filenames for tabs {{{
      let l:fnList    = range(tabCount)              " List of file names
      let l:fnLenList = range(tabCount)              " List of fn lengths
      let l:wCntLst = map(range(tabCount),'v:val-v:val') " List of tab win cnts
      let l:tlLen = 0                                " Counter for tl length
      for l:iTab in range(1,tabCount)                " Iterate through each tab
         let l:tabBufList = tabpagebuflist(iTab)     " List of buffers in tab
         let l:winSel     = tabpagewinnr(iTab)       " Currently selected win
         let l:winCount   = tabpagewinnr(iTab,'$')   " Count of windows in tab
         let l:bufSel     = tabBufList[winSel-1]     " Selected buffer number
         if getbufvar(bufSel, "&buftype") != ""      " Skip if Normal buffer
            for l:iBuf in tabBufList                 " Search remaining buffers
               if getbufvar(iBuf,"&buftype") == ""
                 let bufSel = iBuf
                 break
               endif
            endfor
         endif
         let l:fn              = fnamemodify(bufname(bufSel),':p:t')  " rm path
         let fn                = (fn != '' ? fn : '[No Name]')
         let fnList[iTab-1]    = fn
         let l:fnWidth         = strlen(iTab)+strlen(fn)+strlen(winCount) "+ 1
         let fnLenList[iTab-1] = fnWidth
         let tlLen            += fnWidth
         let wCntLst[iTab-1]   = winCount
      endfor
      let tlLen -= 1                              " Remove trailing space
      let l:widthdiff = tlLen - &columns          " Measure of tabline overflow
      while widthdiff > 0                         " Tabline wider than window
         let l:maxidx           = index(fnLenList,max(fnLenList))
         let fnList[maxidx]     = strpart(fnList[maxidx], 1) " Trim longest fn
         let fnLenList[maxidx] -= 1 " Update array of lengths
         let widthdiff         -= 1 "
      endwhile
      " }}}
      " Render tabs {{{
      let l:tabIdx = 1                                              " Tab index
      while tabIdx <= tabCount
         let l:isSel      = (tabIdx == curTab ? 1 : 0)
         let l:fn         = fnList[tabIdx-1]
         let l:isDirtybuf = 0
         for l:b in tabpagebuflist(tabIdx)
            let isDirtybuf += getbufvar(b, "&mod")
         endfor
         " Index number
         if(isSel)
            let s .= (isDirtybuf ? '%#Search#' : '%#WildMenu#')
         else
            let s .= (isDirtybuf ? '%#ErrorMsg#' : '%#StatusLineNC#')
         endif
         let s .= tabIdx " append tab index
         " Filename
         let s .= (isSel ? '%#TabLineSel#' : '%#Tabline#')
         let s .= fn
         " Window count
         if(wCntLst[tabIdx-1] > 1)
            let s .= (isSel ? '%#Title#' : '%#Directory#')
            let s .= wCntLst[tabIdx-1]
         endif
         " Trailing space
         let s .= '%#Normal#' . (tabIdx != tabCount ? ' ' : '')
         let tabIdx += 1
      endwhile
      " }}}
      return s
   endfunction
   set tabline=%!MyTabLine()
endif
" }}}
" Custom statusline {{{
set laststatus=2 " Statusline always on
function! StatFunc()
   let s = ''
   let s .= '%#LineNr#'.'%n '                      " Buffer number
"   let s .= '%#AnF_mB02#'.'%{fugitive#statusline()}'  " Git branch
   let s .= '%#FoldColumn#'.'%F'                        " Full filename
   let s .= '%#DiffDelete#'.'%m'                        " Red modflag
   let s .= '%#FoldColumn#'
   let s .= '%='                                      " Right align
   let s .= '[%l,%c]'.' '                             " Row, Col
   let s .= '%#DiffText#'.'%L'                        " Percentage
   return s
endfunction
set statusline=%!StatFunc()
" }}}


"" SuperTab option for context aware completion
"let g:SuperTabDefaultCompletionType = "context"
""let g:SuperTabClosePreviewOnPopupClose = 1
"" Show clang errors in the quickfix window
"let g:clang_complete_copen = 1
""let g:clang_user_options='|| exit 0'
"
"" If you prefer the Omni-Completion tip window to close when a selection is
"" made, these lines close it on movement in insert mode or when leaving
"" insert mode
"autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
"autocmd InsertLeave * if pumvisible() == 0|pclose|endif
"
"" Autofolding between sessions
"autocmd BufWinLeave *.* mkview
"autocmd BufWinEnter *.* silent loadview
"
"" Don't screw up folds when inserting text that might affect
"" them, until leaving insert mode. Foldmethod is local to the window.
"" Protect against screwing up folding when switching between windows.
"autocmd InsertEnter * if !exists('w:last_fdm') | let w:last_fdm=&foldmethod | setlocal foldmethod=manual | endif 
"autocmd InsertLeave,WinLeave * if exists('w:last_fdm') | let &l:foldmethod=w:last_fdm | unlet w:last_fdm | endif

set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
"let g:clang_user_options="-I/usr/pgsql-9.3/include"

" vim: fdm=marker
