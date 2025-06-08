; extends
(jsx_attribute) @jsx.attr
(jsx_element) @jsx.element
(jsx_self_closing_element) @jsx.self_closing_element

((call_expression
   function: (identifier) @func_name (#match? @func_name "^it$")
   )) @jest.it

((call_expression
   function: (identifier) @func_name (#match? @func_name "^describe$")
   )) @jest.describe
