;; extends

((expression_statement
        (#if? (has_parent_attribute "html_attribute_name")
         (template_string) @class_value) (#set! @class_value conceal "…")))
