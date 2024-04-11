(local config (require :nfnl.config))
(local default (config.default))
{:verbose true :compiler-options {:compilerEnv _G}}

; :fnl-path->lua-path (fn [fnl-path]
;                       (let [rel-fnl-path (vim.fn.fnamemodify fnl-path ":.")]
;                         (default.fnl-path->lua-path (.. :lua/fnl-compiled/
;                                                         rel-fnl-path))))}
