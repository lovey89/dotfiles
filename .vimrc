source $VIMRUNTIME/defaults.vim

" The color scheme can be manually edited by typing:
" :colorscheme <tab to see alternatives>
colorscheme catppuccin_mocha
syntax on
set cursorline

set wildmenu
set wildmode=longest:full,full

" Cursor keys will wrap to next line at the beginning or end of next line
" < > are the cursor keys used in normal and visual mode, and [ ] are the
" cursor keys in insert mode
set whichwrap+=<,>,[,]

set mouse-=a
set ruler
