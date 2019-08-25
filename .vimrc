syntax enable

if filereadable(expand("~/.vimrc.plug"))
	source ~/.vimrc.plug
endif

let g:ale_completion_enabled = 1

let g:airline_theme='oceanicnext'

colorscheme OceanicNext

packloadall




" Fuzzy long lines gauge
highlight ColorColumn ctermbg=green
call matchadd('ColorColumn', '\%81v', 100)

" highlights search word
set hlsearch

" show whitespace
set listchars=tab:>~,nbsp:_,trail:.
set list

" default to case insensitive searches
set ignorecase

" live searches
set incsearch

" line numbers on
set number
