; extends
((inline) @_inline (#match? @_inline "^\(import\|export\)")) @tsx
((inline) @_inline (#match? @_inline "^\(<style>|<\/style>)")) @astro
; (((inline) @_inline (#match? @_inline "^\(import\|export\)")) @injection.content
;   (#set! injection.language "tsx"))
; ((inline) @injection.content
;   (#lua-match? @injection.content "^%s*import")
;   (#set! injection.language "tsx"))
; ((inline) @injection.content
;   (#lua-match? @injection.content "^%s*export")
;   (#set! injection.language "tsx"))
