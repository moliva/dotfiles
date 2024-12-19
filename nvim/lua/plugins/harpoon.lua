local function harpooned_items()
  local items = {}

  for index, key in ipairs({
    -- home row
    'a', 's', 'd', 'f',
    -- upper row
    'q', 'w', 'e', 'r',
    -- bottom row
    'z', 'x', 'c', 'v' }) do
    local item = {
      '<a-h>' .. key,
      function() require('harpoon.ui').nav_file(index) end,
      desc = "Navigate to harpooned file " ..
          index,
    }

    table.insert(items, item)
  end

  return items
end

local function keys()
  local keys = {

    { '<leader>h',  nil,                                                      desc = "Harpoon" },
    { '<leader>ha', function() require("harpoon.mark").add_file() end,        desc = "Mark file as harpooned" },
    { '<a-h><a-h>', function() require('harpoon.ui').toggle_quick_menu() end, desc = "Harpoon quick menu" },
  }

  for _, value in ipairs(harpooned_items()) do
    table.insert(keys, value)
  end

  return keys
end

return {
  {
    'ThePrimeagen/harpoon',
    keys = keys()
  },
}
