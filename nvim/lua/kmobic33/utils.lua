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
local project_description_files = { "/package.json", "/Cargo.toml", "/go.mod", "pom.xml" }

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

return M
