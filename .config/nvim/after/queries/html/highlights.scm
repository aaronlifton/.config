;; extends

; https://github.com/search?q=path%3A**nvim%2F**%2Finjections.scm+%22%23any-of%22&type=code
; ((attribute
;         (attribute_name) @att_name (#eq? @att_name "class")
;         (quoted_attribute_value (attribute_value) @class_value) (#set! @class_value conceal "…")))
;
((attribute
        (attribute_name) @att_name (#eq? @att_name "class")
        (quoted_attribute_value (attribute_value) @class_value)
        (#match? @class_value "^(text|bg|m|mt|mr|mb|ml|p|pt|pr|pb|pl|flex|grid)-.*$")
          (#set! @class_value conceal "…")
          (#set! @class_value @class_value)))
