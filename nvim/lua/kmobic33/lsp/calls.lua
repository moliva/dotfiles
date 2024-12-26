local js_family = {
  nodes = {
    call_expression = [[ [ (call_expression arguments: _ @arguments) ] ]],
    new_expression = [[ [ (new_expression arguments: _ @arguments) ] ]],
    generic_type = [[ [ (generic_type type_arguments: (_) @arguments ) ] ]],
  },
}

return {
  lua = {
    nodes = {
      function_call = [[ [ (function_call arguments: _ @arguments) ] ]],
    },
  },
  javascript = js_family,
  jsx = js_family,
  typescript = js_family,
  tsx = js_family,
  rust = {
    nodes = {
      call_expression = [[ [ (call_expression function: (_) arguments: _ @arguments) ] ]],
      macro_invocation = [[ [ (macro_invocation macro: (_) (token_tree _) @arguments) ] ]],
      generic_type = [[ [ (generic_type type_arguments: (_) @arguments ) ] ]],
    },
  },
}
