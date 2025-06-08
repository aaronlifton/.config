;; extends
((attribute
        (attribute_name) @att_name (#eq? @att_name "class")
        (attribute_interpolation (attribute_js_expr) @class_value) (#set! @class_value conceal "…")))

; ((attribute
;         (attribute_name) @att_name (#eq? @att_name "class:list")
;         (attribute_interpolation (attribute_js_expr) @class_value) (#set! @class_value conceal "…")))


; inherits: html

["---"] @punctuation.delimiter

[ "{" "}" ] @punctuation.special
