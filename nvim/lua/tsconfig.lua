-- lua/tsconfig.lua

local M = {}

local function get_dir(fname)
  return vim.fn.fnamemodify(fname, ":h")
end

local function find_tsconfig_extends(extends, tsconfig_fname)
  if not extends or vim.startswith(extends, "@") then
    return
  end

  local tsconfig_dir = get_dir(tsconfig_fname)
  return vim.fn.simplify(tsconfig_dir .. "/" .. extends)
end

local function get_tsconfig_paths(tsconfig_fname, prev_base_url)
  if not tsconfig_fname then
    return {}
  end

  local json = decode_json_with_comments(tsconfig_fname)
  local base_url = json and json.compilerOptions and json.compilerOptions.baseUrl or prev_base_url

  local alias_to_paths = {}

  -- ...

  local tsconfig_extends = find_tsconfig_extends(json.extends, get_dir(tsconfig_fname))

  return vim.tbl_extend("force", alias_to_paths, get_tsconfig_paths(tsconfig_extends, base_url))
end

local function expand_tsconfig_path(input)
  local tsconfig_file = get_tsconfig_file()

  if not tsconfig_file then
    return input
  end

  local alias_to_paths = get_tsconfig_paths(tsconfig_file)

  if not alias_to_paths then
    return input
  end

  for alias, path in pairs(alias_to_paths) do
		if alias == "*" or vim.startswith(input, alias:gsub("*", "")) then
      for _, path in pairs(paths) do
        local expanded_path = input:gsub(alias, path)
        local real_path = find_file(expanded_path) or find_dir(expanded_path)

        if real_path then
          return real_path
        end
      end
    end
  end

  return input
end

function M.includeeexpr(input)
  local path = expand_tsconfig_path(input)
  return path
end

return M
