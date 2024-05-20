; extends
((call
   method: (identifier) @func_name (#match? @func_name "^context$")
   )) @rspec.context

((call
   method: (identifier) @func_name (#match? @func_name "^it$")
   )) @rspec.it

(module) @class.outer
(singleton_class) @class.outer
(singleton_method) @function.outer
(block) @block.outer
(do_block) @block.outer
(do_block (block_parameters) @block.parameters (_) @block.inner)
(do_block (_) @block.inner)
(if) @conditional.outer
(case) @conditional.outer
(then) @conditional.inner
(else (_) @conditional.inner)
;; https://github.com/search?q=path%3A**%2Fnvim%2Fafter%2Fqueries%2Fruby%2Ftextobjects.scm&ref=opensearch&type=code
