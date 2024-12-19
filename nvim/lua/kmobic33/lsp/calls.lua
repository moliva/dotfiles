return {
  lua = {
    nodes = {
      function_call = [[
[
  (function_call arguments: _ @arguments)
]
        ]],
    },
  },
  typescript = {
    nodes = {
      call_expression = [[
[
  (call_expression arguments: _ @arguments)
]
        ]],
      new_expression = [[
[
  (new_expression arguments: _ @arguments)
]
        ]],
      generic_type = [[
[
  (generic_type type_arguments: (_) @arguments )
]
]],
    },
  },
  rust = {
    nodes = {
      call_expression = [[ 
[
  (call_expression function: (_) arguments: _ @arguments)
]
      ]],
      macro_invocation = [[ 

[
  (macro_invocation macro: (_) (token_tree _) @arguments)
]
      ]],
    },
  },
}
