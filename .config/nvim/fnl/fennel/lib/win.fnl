(local f (require :fun))
(local exports {})
; (fn win-leftmost []
;   (let [wins (vim.api.nvim_list_wins)
;         winpos (collect [_ s ipairs(wins)]
;                  s (vim.fn.win_screenpos s))
;         leftmost (f.reduce (fn [a b] (if (< (. a 1) (. b 1)) a b)) (. winpos 1))]
;         (print leftmost)))
(fn window-size [window-id]
  (* (vim.api.nvim_win_get_width window-id)
     (vim.api.nvim_win_get_height window-id)))

(fn get-largest-window-id []
  (let [windows-by-size {}]
    (each [_ window-id (pairs (vim.api.nvim_list_wins))]
      (tset windows-by-size (window-size window-id) window-id))
    (. windows-by-size (table.maxn windows-by-size))))
