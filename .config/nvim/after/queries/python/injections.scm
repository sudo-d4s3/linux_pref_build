; extends

((comment) @injection.language
 .
 (expression_statement
   (assignment
     right: (string
       (string_content) @injection.content)))
 (#lua-match? @injection.language "^#%s*language=")
 (#gsub! @injection.language "#%s*language=%s*([%w%-%.]+)" "%1"))
