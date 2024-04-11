(local {: autoload} (require :nfnl.module))
(local nvim (autoload :nvim))
(local core (autoload :nfnl.core))
(local nfnl (require :nfnl.api))
; (nfnl.compile-all-files)

; (let [dir (vim.fn.stdpath :config)])

{:init (fn []
         (let [ac vim.api.nvim_create_autocmd]
           (ac :BufEnter
               {:pattern :*.fnl
                :callback (fn [event]
                            (let [buf event.buf
                                  win (vim.api.nvim_get_current_win)
                                  ns (vim.api.nvim_get_hl_ns {:winid win})]
                              (vim.api.nvim_set_hl 0 :MatchParen
                                                   {:standout true :bold true})))})))}

; ;sets a nvim global options
; (let [options
;       {;tabs is space
;        :expandtab true
;        ;tab/indent size
;        :tabstop 2
;        :shiftwidth 2
;        :softtabstop 2
;        ;settings needed for compe autocompletion
;        :completeopt "menuone,noselect"
;        ;case insensitive search
;        :ignorecase true
;        ;smart search case
;        :smartcase true
;        ;shared clipboard with linux
;        :clipboard "unnamedplus"
;        ;show line numbers
;        :number true
;        ;show line and column number
;        :ruler true
;        ;makes signcolumn always one column with signs and linenumber
;        :signcolumn "number"}]
;   (each [option value (pairs options)]
;     (core.assoc nvim.o option value)))
;
