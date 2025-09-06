-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.root_spec = { { "compile_commands.json", ".git" } }
vim.g.lazyvim_picker = "fzf"
vim.g.lazyvim_explorer = "neo-tree"
vim.opt.timeoutlen = 1000
vim.g.lazyvim_check_order = false
vim.opt.wrap = true
vim.opt.linebreak = true
-- 设置 Tab 宽度为 4 空格
vim.o.tabstop = 4 -- 一个 Tab 显示为 4 列
vim.o.shiftwidth = 4 -- 缩进（>> / <<）以 4 空格为单位
vim.o.expandtab = false -- 按 Tab 键时插入空格，而不是 \t
vim.o.softtabstop = 4 -- 按 Backspace 时，4 个空格当作一个 Tab 删除

vim.o.list = true
vim.o.listchars = "tab:>-,space:⋅"

if vim.fn.executable("clipboard-provider") then
  vim.opt.clipboard = "unnamedplus"
  vim.g.clipboard = {
    name = "myClipboard",
    copy = {
      ["+"] = "clipboard-provider copy",
      ["*"] = "clipboard-provider copy",
    },
    paste = {
      ["+"] = "clipboard-provider paste",
      ["*"] = "clipboard-provider paste",
    },
    cache_enabled = true,
  }
end
