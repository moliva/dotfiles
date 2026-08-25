local M = {}

-- Copies the contents of thte current table to a new one
M.copy_table = function(orig)
  local orig_type = type(orig)
  local copy
  if orig_type == "table" then
    copy = {}
    for orig_key, orig_value in pairs(orig) do
      copy[orig_key] = orig_value
    end
  else -- number, string, boolean, etc
    copy = orig
  end
  return copy
end

--- Dumps the content of a given table into a string
M.dump = function(o)
  if type(o) == "table" then
    local s = "{ "
    for k, v in pairs(o) do
      if type(k) ~= "number" then
        k = '"' .. k .. '"'
      end
      s = s .. "[" .. k .. "] = " .. M.dump(v) .. ","
    end
    return s .. "} "
  else
    return tostring(o)
  end
end

--- @param path string
local function parent_dir(path)
  local index = string.find(path, "/[^/]*$")
  return string.sub(path, 0, index - 1)
end

--- Returns the file extension for a given string, e.g. /Users/myuser/myfile.txt -> .txt
M.get_file_extension = function(url)
  return url:match("^.+(%..+)$")
end

--- Given a `criterion` function receiving a key and value and returning a boolean and a table `tab`, returns the index of the first item in the table that matches the criterion.
M.find_index = function(criterion, tab)
  for k, v in ipairs(tab) do
    if criterion(k, v) then
      return k
    end
  end

  return nil
end

--- @param name string
--- @return boolean
function M.file_exists(name)
  local f = io.open(name, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

---List of project description files for different languages
local project_description_files = {
  "/package.json",
  "/Cargo.toml",
  "/go.mod",
  "/pom.xml",
  "/requirements.txt",
  "/pyproject.toml",
  "/build.gradle",
  "/setup.py",
  "/Package.swift",
}

---Tries to find a project description file in the given directory
---@param base_path string
---@return string | nil
local function find_project_description_file(base_path)
  for _, project_description_file in ipairs(project_description_files) do
    if M.file_exists(base_path .. project_description_file) then
      return base_path .. project_description_file
    end
  end
end

---Tries to find a claude file in the given directory
---@param base_path string
---@return string | nil
local function find_claude(base_path)
  if M.file_exists(base_path .. "/CLAUDE.md") then
    return base_path .. "/CLAUDE.md"
  end
end

---Tries to find a project description file in the given directory
---@param base_path string
---@return string | nil
local function find_readme(base_path)
  if M.file_exists(base_path .. "/README.md") then
    return base_path .. "/README.md"
  end
end

---Edit the CLAUDE.md file in the current file's directory or upwards (until cwd) if one exists
function M.edit_claude_from_current_file()
  local initial_file_path = vim.fn.expand("%:p")

  local base_path = parent_dir(initial_file_path)
  if not string.match(base_path, "^.?/") then
    base_path = "./" .. base_path
  end

  local cwd = vim.fn.getcwd()

  local file

  while file == nil do
    file = find_claude(base_path)

    -- if already at the cwd, stop searching
    if base_path == cwd or base_path == "." then
      break
    end

    -- if we started from a project description file, reset and look upwards
    if file == initial_file_path then
      file = nil
    end

    -- if we didn't find a matching file at this level, go up
    if file == nil then
      base_path = parent_dir(base_path)
    end
  end

  -- if we found a matching file, edit it
  if file then
    vim.cmd("e " .. file)
  else
    vim.notify("Could not find a CLAUDE.md from the current file")
  end
end

---Edit the readme file in the current file's directory or upwards (until cwd) if one exists
function M.edit_readme_from_current_file()
  local initial_file_path = vim.fn.expand("%:p")

  local base_path = parent_dir(initial_file_path)
  if not string.match(base_path, "^.?/") then
    base_path = "./" .. base_path
  end

  local cwd = vim.fn.getcwd()

  local file

  while file == nil do
    file = find_readme(base_path)

    -- if already at the cwd, stop searching
    if base_path == cwd or base_path == "." then
      break
    end

    -- if we started from a project description file, reset and look upwards
    if file == initial_file_path then
      file = nil
    end

    -- if we didn't find a matching file at this level, go up
    if file == nil then
      base_path = parent_dir(base_path)
    end
  end

  -- if we found a matching file, edit it
  if file then
    vim.cmd("e " .. file)
  else
    vim.notify("Could not find a README.md from the current file")
  end
end

-- TODO - map oil urls to filesystem - moliva - 2025/12/09
---Edit the project description file in the current file's directory or upwards (until cwd) if one exists
function M.edit_project_description_file_from_current_file()
  local initial_file_path = vim.fn.expand("%:p")

  local base_path = parent_dir(initial_file_path)
  if not string.match(base_path, "^.?/") then
    base_path = "./" .. base_path
  end

  local cwd = vim.fn.getcwd()

  local file

  while file == nil do
    file = find_project_description_file(base_path)

    -- if already at the cwd, stop searching
    if base_path == cwd or base_path == "." then
      break
    end

    -- if we started from a project description file, reset and look upwards
    if file == initial_file_path then
      file = nil
    end

    -- if we didn't find a matching file at this level, go up
    if file == nil then
      base_path = parent_dir(base_path)
    end
  end

  -- if we found a matching file, edit it
  if file then
    vim.cmd("e " .. file)
  else
    vim.notify("Could not find a project description from the current file")
  end
end

---Edit the project description file in the current working directory if it exists
function M.edit_project_description_file_in_cwd()
  local cwd = vim.fn.getcwd()

  local file = find_project_description_file(cwd)

  if file then
    vim.cmd("e " .. file)
  else
    vim.notify("Could not find a project description in the cwd")
  end
end

--Toggles the quickfix window open/close
function M.toggle_quickfix()
  vim.cmd([[
    if getqflist({'winid' : 1}).winid != 0
      cclose
    else
      copen
    endif
  ]])
end

--Toggles the location list window open/close
function M.toggle_locationlist()
  vim.cmd([[
    if getloclist(0, {'winid' : 1}).winid != 0
      lopen
    else
      lclose
    endif
  ]])
end

-- push -> pull -> upper -> legs -> push ...
local bls_day_order = { "push", "pull", "upper", "legs" }

local bls_pattern = "bls%s*-%s*(%d+)%s*-%s*(%a+)%s*%[week%s+(%S+)%s*-%s*phase%s+(%d+)%s*%]"

---Finds the last `bls - <number> - <day> [week <week> - phase <phase>]` line in the current buffer
---@return table|nil { lnum: number, number: number, day: string, week: string, phase: number }
local function find_last_bls_entry()
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)

  for lnum = #lines, 1, -1 do
    local number, day, week, phase = lines[lnum]:match(bls_pattern)
    if number then
      return { lnum = lnum, number = tonumber(number), day = day, week = week, phase = tonumber(phase) }
    end
  end

  return nil
end

---Computes the next bls training log line following the given entry
---@param entry table
---@return string
local function next_bls_line(entry)
  local day_index = M.find_index(function(_, d)
    return d == entry.day
  end, bls_day_order)

  if not day_index then
    error("Unrecognized bls day type: " .. entry.day)
  end

  local next_number = entry.number + 1
  local next_day = bls_day_order[(day_index % #bls_day_order) + 1]

  local next_week = entry.week
  local next_phase = entry.phase

  -- week/phase only roll over when starting the next push day (i.e. coming from legs)
  if entry.day == "legs" then
    if entry.week == "deload" then
      next_week = "1"
      next_phase = (entry.phase % 6) + 1
    elseif tonumber(entry.week) == 8 then
      next_week = "deload"
    else
      next_week = tostring(tonumber(entry.week) + 1)
    end
  end

  return string.format("bls - %d - %s [week %s - phase %d]", next_number, next_day, next_week, next_phase)
end

---Looks up the latest bls training log entry in the buffer and inserts the next one below the cursor
function M.insert_next_bls_entry()
  local entry = find_last_bls_entry()
  if not entry then
    vim.notify("Could not find a previous bls entry", vim.log.levels.WARN)
    return
  end

  local ok, line = pcall(next_bls_line, entry)
  if not ok then
    vim.notify(line, vim.log.levels.ERROR)
    return
  end

  local row = vim.api.nvim_win_get_cursor(0)[1]
  vim.api.nvim_buf_set_lines(0, row, row, false, { line })
  vim.api.nvim_win_set_cursor(0, { row + 1, #line })
end

return M
