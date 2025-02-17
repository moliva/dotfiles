local js_family = {
  nodes = {
    method_definition = [[ [ (method_definition name: (_) @identifier) ] ]],
    function_declaration = [[ [ (function_declaration name: (_) @identifier) ] ]],
    function_expression = [[ [ (function_expression _ @identifier) ] ]],
    arrow_function = [[ [ (arrow_function _ @identifier) ] ]],
    class_declaration = [[ [ (class_declaration name: (_) @identifier) ] ]],
  },
}

return {
  json = {
    nodes = {
      object = [[ [ (object _ @context) ] ]],
      document = [[ [ (document _ @context) ] ]],
    },
  },
  java = {
    nodes = {
      constructor_declaration = [[ [ (constructor_declaration name: (_) @identifier) ] ]],
      interface_declaration = [[ [ (interface_declaration name: (_) @identifier) ] ]],
      lambda_expression = [[ [ (lambda_expression _ @context) ] ]],
      class_declaration = [[ [ (class_declaration name: (_) @identifier) ] ]],
      method_declaration = [[ [ (method_declaration name: (_) @identifier) ] ]],
    },
  },
  rust = {
    nodes = {
      mod_item = [[ [ (mod_item) _ @context ] ]],
      macro_invocation = [[ [ (macro_invocation _ @context) ] ]],
      macro_definition = [[ [ (macro_definition name: (_) @identifier) ] ]],
      block = [[ [ (block _ @context) ] ]],
      impl_item = [[ [ (impl_item type: (_) @identifier) ] ]],
      function_item = [[ [ (function_item name: (_) @identifier) ] ]],
    },
  },
  lua = {
    nodes = {
      function_declaration = [[ [ (function_declaration name: (_) @identifier) ] ]],
      -- TODO - rethink this , add a way to use "high level" contexts only (e.g. functions) - moliva - 2024/06/04
      table_constructor = [[ [ (table_constructor _ @context) ] ]],
      function_definition = [[ [ (function_definition _ @context) ] ]],
    },
  },
  tsx = js_family,
  js = js_family,
  jsx = js_family,
  typescript = js_family,
}
