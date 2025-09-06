-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Example configs: https://github.com/LunarVim/starter.lvim
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
vim.opt.wrap = true
vim.opt.linebreak = true
-- 设置 Tab 宽度为 4 空格
vim.o.tabstop = 4 -- 一个 Tab 显示为 4 列
vim.o.shiftwidth = 4 -- 缩进（>> / <<）以 4 空格为单位
vim.o.expandtab = false -- 按 Tab 键时插入空格，而不是 \t
vim.o.softtabstop = 4 -- 按 Backspace 时，4 个空格当作一个 Tab 删除

vim.o.list = true
vim.o.listchars = "tab:>-,space:⋅"

lvim.lsp.automatic_servers_installation = false

lvim.builtin.lualine.sections.lualine_c = {
	{
		"filename",
		file_status = true, -- Displays file status (readonly status, modified status)
		newfile_status = false, -- Display new file status (new file means no write after created)
		path = 3, -- 0: Just the filename
		-- 1: Relative path
		-- 2: Absolute path
		-- 3: Absolute path, with tilde as the home directory
		-- 4: Filename and parent dir, with tilde as the home directory

		shorting_target = 40, -- Shortens path to leave 40 spaces in the window
		-- for other components. (terrible name, any suggestions?)
		symbols = {
			modified = "[+]", -- Text to show when the file is modified.
			readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
			unnamed = "[No Name]", -- Text to show for unnamed buffers.
			newfile = "[New]", -- Text to show for newly created file before first write
		},
	},
}

-- lvim.format_on_save = false
-- lvim.lsp.diagnostics.virtual_text = true

lvim.builtin.treesitter.highlight.enable = true
lvim.builtin.project.patterns = { "compile_commands.json", ".git" }
-- auto install treesitter parsers
lvim.builtin.treesitter.ensure_installed = { "c", "bash", "lua" }

lvim.lsp.installer.setup.ensure_installed = { "lua_ls", "jsonls" }
-- lvim.lsp.null_ls.setup.sources = { null_ls.builtins.formatting.stylua }
lvim.lsp.installer.setup.automatic_installation.exclude = { "clangd" }
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "clangd" })
require("lvim.lsp.manager").setup("clangd")

lvim.lsp.buffer_mappings.normal_mode["gd"] = { "<cmd>lua goto_definition_with_recall()<cr>", "Goto definition" }
lvim.lsp.buffer_mappings.normal_mode["gr"] = { "<cmd>Trouble lsp_references toggle focus=true<cr>", "Goto references" }
lvim.lsp.buffer_mappings.normal_mode["gi"] =
	{ "<cmd>Trouble lsp_incoming_calls toggle focus=true<cr>", "Goto incoming calls" }

lvim.builtin.which_key.mappings["l"]["S"] = nil
lvim.builtin.which_key.mappings["l"]["g"] = {
	"<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
	"Workspace Symbols",
}

lvim.builtin.which_key.mappings["s"]["f"] = nil
lvim.builtin.which_key.mappings["b"]["f"] = nil
lvim.builtin.which_key.mappings["f"] = nil
lvim.builtin.which_key.mappings["f"] = {
	name = "Find",
	f = { "<cmd>Telescope find_files<cr>", "Find File" },
	b = { "<cmd>Telescope buffers previewer=false sort_lastused=true<cr>", "Find Buffer" },
}

lvim.builtin.which_key.mappings["s"]["t"] = {
	"<cmd>lua require('telescope-live-grep-args.shortcuts').grep_word_under_cursor({postfix = ' -F -w -s '})<cr>",
	"Search text",
}

lvim.builtin.which_key.vmappings["st"] = {
	"<cmd>lua require('telescope-live-grep-args.shortcuts').grep_visual_selection({postfix = ' -F -s '})<cr>",
	"Search text(Vistual)",
}
lvim.builtin.telescope.pickers.buffers.sort_lastused = true
lvim.builtin.telescope.defaults.path_display = function(opts, path)
	-- 获取项目根目录
	local root = vim.fn.getcwd()
	if root then
		-- 转换为从project root开始的路径
		local relative = vim.fn.fnamemodify(path, ":p:.")
		if relative ~= path then
			return relative
		end
	end
	return path
end

-- Additional Plugins
lvim.plugins = {
	{
		"phaazon/hop.nvim",
		event = "BufRead",
		config = function()
			require("hop").setup()
			vim.api.nvim_set_keymap("n", "s", ":HopChar2<cr>", { silent = true })
			vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
		end,
		version = "v2.0.3",
		pin = true,
	},
	{
		"nvim-telescope/telescope-live-grep-args.nvim",
		-- This will not install any breaking changes.
		-- For major updates, this must be adjusted manually.
		tag = "v1.1.0",
		pin = true,
	},
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		opts = {
			auto_refresh = false,
			follow = false,
		},
		tag = "v3.7.1",
		pin = true,
	},
	{
		"crusj/bookmarks.nvim",
		opts = {
			fix_enable = true,
			keymap = {
				toggle = "<S-tab>",
			},
		},
		branch = "main",
		dependencies = { "nvim-web-devicons" },
		pin = true,
	},
	{
		"fnune/recall.nvim",
		config = function()
			local recall = require("recall")
			recall.setup({})
			local ok_marking, marking = pcall(require, "recall.marking")
			if not ok_marking then
				vim.notify("Cannot require recall.marking", vim.log.levels.ERROR)
				return
			end
			local marks_uppercase = 0
			-- 补丁：循环覆盖 A-Z
			function marking.next_available_mark()
				marks_uppercase = (marks_uppercase % 26) + 1
				return string.char(90 - (marks_uppercase - 1)) -- Z-A 循环
			end
		end,
		tag = "1.2.0",
		pin = true,
	},
}

function goto_definition_with_recall()
	require("recall").toggle()
	vim.cmd("Trouble lsp_definitions")
end

lvim.builtin.telescope.on_config_done = function(telescope)
	pcall(telescope.load_extension, "live-grep-args")
	pcall(telescope.load_extension, "bookmarks")
	-- any other extensions loading
end

lvim.format_on_save.enabled = true
lvim.format_on_save.pattern = { "*.lua", "json" }
local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup({
	{ name = "stylua" },
	{
		name = "prettier",
		---@usage arguments to pass to the formatter
		-- these cannot contain whitespace
		-- options such as `--line-width 80` become either `{"--line-width", "80"}` or `{"--line-width=80"}`
		args = { "--print-width", "100" },
		---@usage only start in these filetypes, by default it will attach to all filetypes it supports
		filetypes = { "typescript", "typescriptreact" },
	},
})

if vim.fn.executable("clipboard-provider") then
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
