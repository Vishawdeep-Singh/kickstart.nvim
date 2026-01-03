-- Debug script for ESLint issues
-- Run this in Neovim with: :luafile ~/.config/nvim/lua/debug-lint.lua

print("=== ESLint Debug Report ===\n")

-- 1. Check filetype
local ft = vim.bo.filetype
print("1. Current filetype: " .. ft)

-- 2. Check if nvim-lint is loaded
local lint_ok, lint = pcall(require, 'lint')
if not lint_ok then
  print("ERROR: nvim-lint is NOT loaded!")
  return
end
print("2. nvim-lint: LOADED ✓")

-- 3. Check linters_by_ft configuration
print("\n3. Configured linters_by_ft:")
print(vim.inspect(lint.linters_by_ft))

-- 4. Check linters for current filetype
local linters = lint.linters_by_ft[ft]
if linters then
  print("\n4. Linters for " .. ft .. ": " .. vim.inspect(linters))
else
  print("\n4. ERROR: No linters configured for filetype: " .. ft)
end

-- 5. Check if eslint_d linter exists
local eslint_d_ok, eslint_d = pcall(function() return lint.linters.eslint_d end)
if eslint_d_ok and eslint_d then
  print("\n5. eslint_d linter: FOUND ✓")
  
  -- Check cwd function
  if eslint_d.cwd then
    print("   cwd function: EXISTS ✓")
    local cwd_ok, cwd = pcall(eslint_d.cwd)
    if cwd_ok then
      print("   cwd returns: " .. tostring(cwd))
    else
      print("   ERROR calling cwd(): " .. tostring(cwd))
    end
  else
    print("   WARNING: cwd function NOT SET")
  end
  
  -- Check cmd
  if eslint_d.cmd then
    local cmd_ok, cmd = pcall(eslint_d.cmd)
    if cmd_ok then
      print("   cmd returns: " .. tostring(cmd))
    else
      print("   ERROR calling cmd(): " .. tostring(cmd))
    end
  end
else
  print("\n5. ERROR: eslint_d linter NOT FOUND")
end

-- 6. Check current diagnostics
local diagnostics = vim.diagnostic.get(0)
print("\n6. Current diagnostics count: " .. #diagnostics)
if #diagnostics > 0 then
  print("   Diagnostics sources:")
  for _, d in ipairs(diagnostics) do
    print("   - " .. (d.source or "unknown") .. " (line " .. (d.lnum + 1) .. ")")
  end
end

-- 7. Check autocommands
local autocmds = vim.api.nvim_get_autocmds({ group = "lint" })
print("\n7. Lint autocommands: " .. #autocmds .. " registered")

-- 8. Try to manually trigger linting
print("\n8. Attempting to trigger linting...")
local try_ok, try_err = pcall(lint.try_lint)
if try_ok then
  print("   lint.try_lint() executed ✓")
  
  -- Wait a moment and check diagnostics again
  vim.defer_fn(function()
    local new_diagnostics = vim.diagnostic.get(0)
    print("\n9. Post-lint diagnostics count: " .. #new_diagnostics)
    if #new_diagnostics > 0 then
      for _, d in ipairs(new_diagnostics) do
        print("   Line " .. (d.lnum + 1) .. ": [" .. (d.source or "?") .. "] " .. d.message)
      end
    else
      print("   No diagnostics found!")
    end
  end, 1000)
else
  print("   ERROR: " .. tostring(try_err))
end

print("\n=== End Debug Report ===")
print("Check :messages for any additional errors")
