; extends
((inline) @injection.content
  (#lua-match? @injection.content "^%s*import")
  (#set! injection.language "typescript"))
((inline) @injection.content
  (#lua-match? @injection.content "^%s*export")
  (#set! injection.language "typescript"))
((inline) @_inline (#match? @_inline "^\(<style>|<\/style>)")) @astro
; ((inline) @_inline (#lua-match? @_inline "[</]")) @astro
; ((inline) @injection.content
;   (#lua-match? @injection.content "[</]")
;   (#set! injection.language "astro"))


; ((inline) @_inline (#lua-match? @_inline "^\(<style>|<\/style>)")) @astro
; ((inline) @_inline (#match? @_inline "^\(<[a-zA-Z0-9]+>|<\/[a-zA-Z0-9]+>)")) @astro
; Match any jsx element as astro

; <([A-Z][A-Za-z0-9]*)[^>]*>(.*?)<\/\1>
; ((inline) @_inline (#match? @_inline "^\(import\|export\)")) @tsx
; ((jsx_section)
;  @injection.content
;  (#set! injection.language "tsx")
;  (#set! injection.include-children))

; ((markdown_section)
;  @injection.content
;  (#set! injection.language "markdown")
;  (#set! injection.combined))

; (((inline) @_inline (#match? @_inline "^\(import\|export\)")) @injection.content
;   (#set! injection.language "tsx"))
; ((inline) @injection.content
;   (#lua-match? @injection.content "^%s*import")
;   (#set! injection.language "tsx"))
; ((inline) @injection.content
;   (#lua-match? @injection.content "^%s*export")
;   (#set! injection.language "tsx"))
