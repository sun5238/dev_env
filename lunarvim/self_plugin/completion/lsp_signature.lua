local M = {}

function M.config()
  lvim.builtin.lsp_signature = {
    bind = true,
    use_lspsaga = false,
    floating_window = true,
    fix_pos = true,
    hint_enable = true,
    hi_parameter = "Search",
    handler_opts = {
      border = "single",
    },
  }
end

function M.setup()
  local status_ok, plugin = pcall(require, "lsp_signature")
  if not status_ok then
    return
  end

  plugin.attach(lvim.builtin.lsp_signature)
end

return M

