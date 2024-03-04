if exists('g:loaded_denops_helloworld')
  finish
endif
let g:loaded_denops_helloworld = 1

command! DenopsHello echo 'Hello, Denops!'
