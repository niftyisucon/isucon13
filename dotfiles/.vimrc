call plug#begin('~/.vim/plugged')

" General
Plug 'banyan/recognize_charcode.vim'
Plug 'tpope/vim-sensible'
Plug 'tyru/caw.vim'
Plug 'vim-scripts/addexecmod.vim'
Plug 'vim-scripts/lastpos.vim'

" UI
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Plug 'tpope/vim-fugitive'
let g:airline#extensions#tabline#enabled = 1

" Syntax
if v:version >= 800
Plug 'fatih/vim-go'
  let g:go_version_warning = 0
  let g:go_highlight_array_whitespace_error = 1
  let g:go_highlight_chan_whitespace_error = 1
  let g:go_highlight_extra_types = 1
  let g:go_highlight_space_tab_error = 1
  let g:go_highlight_trailing_whitespace_error = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_functions = 1
  let g:go_highlight_function_arguments = 1
  let g:go_highlight_methods = 1
  let g:go_highlight_types = 1
  let g:go_highlight_fields = 1
  let g:go_highlight_build_constraints = 1
  let g:go_highlight_generate_tags = 1
  let g:go_highlight_string_spellcheck = 1
  let g:go_highlight_format_strings = 1
  let g:go_highlight_variable_declarations = 1
  let g:go_highlight_variable_assignments = 1
endif
Plug 'ingydotnet/yaml-vim'
Plug 'leshill/vim-json'
Plug 'posva/vim-vue'
Plug 'vim-ruby/vim-ruby'
Plug 'vim-scripts/nginx.vim'
Plug 'rhysd/vim-gfm-syntax'
Plug 'kchmck/vim-coffee-script'
Plug 'hashivim/vim-terraform'

" Formatter (fixer)
Plug 'w0rp/ale'
let g:ale_fixers = {
\ 'bash': ['shfmt'],
\ 'go': ['gofmt'],
\ 'javascript': ['prettier'],
\ 'json': ['jq'],
\ 'perl': ['perltidy'],
\ 'ruby': ['rubocop'],
\ 'sh': ['shfmt'],
\ 'terraform': ['terraform'],
\ 'xml': ['xmllint'],
\ 'python': ['autopep8', 'isort'],
\ 'yaml': ['prettier'],
\ }
let g:ale_fix_on_save = 1
let g:ale_sh_shfmt_options = '-i 4 -ci'
let g:ale_ruby_rubocop_executable = 'bundle'
" Plug 'godlygeek/tabular'
" Plug 'jezcope/vim-align'
" Plug 'vim-scripts/SQLUtilities'

" Linter
let g:ale_linters = {
\ 'bash': ['shellcheck'],
\ 'coffee': ['coffee'],
\ 'go': ['gofmt'],
\ 'json': ['jsonlint'],
\ 'perl': ['perlcritic'],
\ 'ruby': ['rubocop'],
\ 'terraform': ['tflint'],
\ 'yaml': ['yamllint'],
\ 'xml': ['xmllint'],
\}

" yamllint
let g:ale_yaml_yamllint_options='-d "{extends: relaxed, rules: {line-length: disable}}"'

" Completion
Plug 'Shougo/neocomplete.vim'
let g:neocomplete#enable_at_startup = 1

" Preview
Plug 'thinca/vim-quickrun'
Plug 'mattn/webapi-vim'
Plug 'tyru/open-browser.vim'
Plug 'superbrothers/vim-quickrun-markdown-gfm'
let g:quickrun_config = {
\   'markdown': {
\     'type': 'markdown/gfm',
\     'outputter': 'browser'
\   }
\ }
let g:quickrun_markdown_gfm_github_api_url = 'https://ghe.commercelink.jp/api/v3'
let g:quickrun_markdown_gfm_github_token = '912701df1b94edc93b4f8302eba105b41e4d4f6a'
map <F6> <ESC>:QuickRun markdown<CR>

" Color
Plug 'KeitaNakamura/neodark.vim'
Plug 'junegunn/seoul256.vim'
Plug 'tomasr/molokai'
Plug 'vim-scripts/desert256.vim'

call plug#end()

let g:seoul256_background = 233
colo seoul256

" Backup
set backup
set backupdir=~/.vim/backup
let &directory = &backupdir

" Swap
set swapfile
set directory=~/.vim/swap

" Buffer
map <F2> <ESC>:bp<CR>
map <F3> <ESC>:bn<CR>
map <F4> <ESC>:bw<CR>

" Comment
nmap <Leader>c <Plug>(caw:i:toggle)
vmap <Leader>c <Plug>(caw:i:toggle)
nmap ,c <Plug>(caw:i:toggle)
vmap ,c <Plug>(caw:i:toggle)

" Search
set incsearch
set hlsearch

" Tab
set tabstop=4
set shiftwidth=4
set expandtab

" Charset
set ambiwidth=double

set autoread

augroup ForceFileType
  autocmd!
  autocmd BufNewFile *.lib    set filetype=perl
  autocmd BufRead    *.lib    set filetype=perl
  autocmd BufNewFile *.dig    set filetype=yaml
  autocmd BufRead    *.dig    set filetype=yaml
  autocmd BufNewFile nginx.conf set filetype=nginx.conf
  autocmd BufRead    nginx.conf set filetype=nginx.conf
augroup END

augroup Skel
  autocmd!
  autocmd BufNewFile *.pl     0r ~/.vim/templates/skel.pl
  autocmd BufNewFile *.pm     0r ~/.vim/templates/skel.pm
  autocmd BufNewFile *.sh     0r ~/.vim/templates/skel.sh
augroup END

augroup Indent
  autocmd!
  autocmd FileType apache     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType c          setlocal sw=4 sts=4 ts=4 et
  autocmd FileType cpp        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType css        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType eruby      setlocal sw=2 sts=2 ts=2 et
  autocmd FileType go         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType html       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType javascript setlocal sw=4 sts=4 ts=4 et
  autocmd FileType perl       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType sh         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType sql        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType vim        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType xhtml      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType yaml       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType markdown   setlocal sw=2 sts=2 ts=2 et
  autocmd FileType json       setlocal sw=2 sts=2 ts=2 et
augroup END

augroup Formatter
  autocmd!
  autocmd FileType perl,cgi   compiler perl
  autocmd FileType perl,cgi   nmap ,pt <ESC>:%! perltidy<CR>
  autocmd FileType perl,cgi   nmap ,ptv <ESC>:%'<, '>! perltidy<CR>
  autocmd FileType xml        nmap ,pt <ESC>:%! xmllint --format - <CR>
  autocmd FileType xml        nmap ,ptv <ESC>:%'<, '>! xmllint --format - <CR>
  autocmd FileType json       nmap ,pt <ESC>:%! jq . <CR>
  autocmd FileType json       nmap ,ptv <ESC>:%'<, '>! jq . <CR>
  autocmd FileType sql        nmap ,pt <ESC>:%! sqlformat --no-highlight <CR>
  " autocmd FileType sql        nmap ,pt <ESC>:%! sqlfmt <CR>
  autocmd FileType sql        nmap ,ptv <ESC>:%'<, '>! sqlformat --no-highlight <CR>
  " autocmd FileType sql        nmap ,ptv <ESC>:%'<, '>! sqlfmt <CR>
  autocmd FileType javascript nmap ,pt <ESC>:%! js-beautify <CR>
  autocmd FileType javascript nmap ,ptv <ESC>:%'<, '>! js-beautify <CR>
  autocmd FileType ruby       nmap ,pt <ESC>:%! rufo <CR>
  autocmd FileType ruby       nmap ,ptv <ESC>:%'<, '>! rufo <CR>
augroup END

augroup Etc
  autocmd!
  autocmd FileType python     setlocal cinwords=if,elif,else,for,while,try,except,finally,def,class
  autocmd FileType ruby       compiler ruby
  autocmd FileType ruby       setlocal nocompatible
  autocmd FileType go         setlocal noexpandtab
augroup END
