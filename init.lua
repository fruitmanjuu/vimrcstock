
-- leader key mappings		-- default is '\'
-- いくつかのプラグインでマッピングに必須で、かつ先に書かないと読み込まれない可能性が高いのでここに移動
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.o.autochdir = true

-- 0.10.0以上(というか実質nightly)じゃないとtreesitterが動かないっぽいので、linuxの場合は自炊したほうが良さそう

-- Neovide(windows) config
-- ＊EXPERIMENTAL＊
-- vim.g.neovide_remember_window_size = true
-- vim.g.neovide_refresh_rate = 60
-- vim.g.neovide_underline_stroke_scale = 1.0
-- vim.g.neovide_hide_mouse_when_typing = true
-- vim.g.neovide_position_animation_length = 0.05
-- 
-- vim.g.neovide_hide_mouse_when_typing = true
-- 
-- vim.g.neovide_floating_shadow = false
-- vim.g.neovide_floating_z_height = 10
-- vim.g.neovide_light_angle_degrees = 45
-- vim.g.neovide_light_radius = 5

-- vim.g.neovide_transparency = 0.9		--deplicated function
-- vim.g.neovide_normal_opacity = 0.93

--Neovide cursor move effect(perticle)
--設定によるんだろうけど、ホコリが舞ってるような感じになって環境によっては見栄え悪いかも
--あと、単純に描画を食うので環境によっては重い
-- vim.g.neovide_cursor_vfx_mode = "torpedo"
-- vim.g.neovide_cursor_vfx_opacity = 200.0
-- vim.g.neovide_cursor_vfx_particle_lifetime = 5.4
-- vim.g.neovide_cursor_vfx_particle_speed = 100.0
-- vim.g.neovide_cursor_vfx_particle_phase = 1.5
-- vim.g.neovide_cursor_vfx_particle_curl = 0.4

-- titlebar color config (for neovide)
-- vim.g.neovide_title_background_color = "pink"
-- vim.g.neovide_title_text_color = "green"


-- lua type font config(require Font Install::Juisee_HWNF)
vim.o.guifont = "Juisee_HWNF:h12"




-- " ※※※※※※※※※※
-- " ※config keyword explain※
-- " ※※※※※※※※※※


--  バインド設定時の特殊構文などについて
--  <Silent> -> ステータスラインにメッセージを表示しない
--  <Leader> -> ユーザがrcファイルで設定したキーを使ってコマンドを打ち始めるときに使う
-- " " <hogehoge><CR> -> コマンドを置換した後、改行する(実行する)

-- vimscriptをそのまま持ってくる場合：
-- ワンライナーのとき: vim.cmd("")
-- 複数行にまたがるとき： vim.cmd [[ try <hogehogehoge> catch <sentence> endtry ]]

-- coc-symbol-lineとは別で設定が必要か？

-- VSCodeで動作しているか？
-- ※これは今は未使用、VSCodeのNeoVIMプラグインに依存

-- if vim.g.vscode then
-- 	-- VSCode extensions configuration※
-- else
-- 	--ordinary Neovim
-- end

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
  spec = {
    -- add your plugins here

	-- use carbonfox colorscheme
	{

    	"EdenEast/nightfox.nvim", 
		lazy = false, -- make sure we load this during startup if it is your main colorscheme
    	priority = 1000, -- make sure to load this before all the other start plugins
    	config = function()
      	-- load the colorscheme here
      	vim.cmd([[colorscheme carbonfox]])
      	vim.g.lightline = { colorscheme = "carbonfox" }
    	end,
  	},
{
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    lnp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
    },
    routes = {
      {
        filter = {
          event = "msg_show",
          any = {
            { find = "%d+L, %d+B" },
            { find = "; after #%d+" },
            { find = "; before #%d+" },
          },
        },
        view = "mini",
      },
    },
    presets = {
      bottom_search = true,
      command_palette = true,
      long_message_to_split = true,
    },
  },
  -- stylua: ignore
  keys = {
    { "<leader>sn", "", desc = "+noice"},
    { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
    { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
    { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
    { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
    { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
    { "<leader>snt", function() require("noice").cmd("pick") end, desc = "Noice Picker (Telescope/FzfLua)" },
    { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
    { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
  },
  config = function(_, opts)
    -- HACK: noice shows messages from before it was enabled,
    -- but this is not ideal when Lazy is installing plugins,
    -- so clear the messages in this case.
    if vim.o.filetype == "lazy" then
      vim.cmd([[messages clear]])
    end
    require("noice").setup(opts)
  end,
},

{
  "gbprod/yanky.nvim",
  recommended = true,
  desc = "Better Yank/Paste",
  -- event = "LazyFile",
  opts = {
    highlight = { timer = 150 },
  },
  keys = {
    -- {
    --   "<leader>p",
    --   function()
    --     if LazyVim.pick.picker.name == "telescope" then
    --       require("telescope").extensions.yank_history.yank_history({})
    --     else
    --       vim.cmd([[YankyRingHistory]])
    --     end
    --   end,
    --   mode = { "n", "x" },
    --   desc = "Open Yank History",
    -- },
        -- stylua: ignore
    { "y", "<Plug>(YankyYank)", mode = { "n", "x" }, desc = "Yank Text" },
    { "p", "<Plug>(YankyPutAfter)", mode = { "n", "x" }, desc = "Put Text After Cursor" },
    { "P", "<Plug>(YankyPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Cursor" },
--     { "gp", "<Plug>(YankyGPutAfter)", mode = { "n", "x" }, desc = "Put Text After Selection" },
--     { "gP", "<Plug>(YankyGPutBefore)", mode = { "n", "x" }, desc = "Put Text Before Selection" },
    { "<C-p>", "<Plug>(YankyCycleForward)", desc = "Cycle Forward Through Yank History" },
    { "<C-n>", "<Plug>(YankyCycleBackward)", desc = "Cycle Backward Through Yank History" },
    --[[
    { "]p", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
    { "[p", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
    { "]P", "<Plug>(YankyPutIndentAfterLinewise)", desc = "Put Indented After Cursor (Linewise)" },
    { "[P", "<Plug>(YankyPutIndentBeforeLinewise)", desc = "Put Indented Before Cursor (Linewise)" },
    { ">p", "<Plug>(YankyPutIndentAfterShiftRight)", desc = "Put and Indent Right" },
    { "<p", "<Plug>(YankyPutIndentAfterShiftLeft)", desc = "Put and Indent Left" },
    { ">P", "<Plug>(YankyPutIndentBeforeShiftRight)", desc = "Put Before and Indent Right" },
    { "<P", "<Plug>(YankyPutIndentBeforeShiftLeft)", desc = "Put Before and Indent Left" },
    { "=p", "<Plug>(YankyPutAfterFilter)", desc = "Put After Applying a Filter" },
    { "=P", "<Plug>(YankyPutBeforeFilter)", desc = "Put Before Applying a Filter" },
    ]]
  },
},
	
  -- {  "liuchengxu/vim-which-key" },
  { "kaz399/spzenhan.vim" },
  -- { "lambdalisue/fern.vim" },

  -- 原則、vim/gvim用
  -- { "jeetsukumaran/vim-buffergator" },

  -- 絵文字もこのプラグインのおかげでレンダリングされている？
  { "MeanderingProgrammer/render-markdown.nvim" },	-- markdownをいい感じにプレビューしてくれるやつ
  { "nvim-telescope/telescope.nvim" },

  { "itchyny/lightline.vim"  },

  { "prabirshrestha/vim-lsp" },
  { "prabirshrestha/asyncomplete.vim" },
  { "nathanaelkane/vim-indent-guides" },
  { "altercation/vim-colors-solarized" },
  { "cocopon/iceberg.vim" },
  { "gkeep/iceberg-dark" },
  -- { "junegunn/fzf.vim" },
  -- { "junegunn/fzf" },
  { "mechatroner/rainbow_csv" },
  -- { "mhinz/vim-startify" },
  { "simeji/winresizer" },
  { "mattn/vim-maketable" },
  { "subnut/nvim-ghost.nvim" },
  { "nvim-treesitter/nvim-treesitter" },
  -- { "vim-jp/vimdoc-ja" },
  { "PhilRunninger/bufselect" },
  { "folke/which-key.nvim" },

	--im-select.nvimを使ってnormalとinsertのIMEオン/オフを切り替える
	{
		"keaising/im-select.nvim",
		config = function()
			require('im_select').setup({
				-- IM will be set to `default_im_select` in `normal` mode
				-- For Windows/WSL, default: "1033", aka: English US Keyboard
				-- For macOS, default: "com.apple.keylayout.ABC", aka: US
				-- For Linux, default:
				--               "keyboard-us" for Fcitx5
				--               "1" for Fcitx
				--               "xkb:us::eng" for ibus
				-- You can use `im-select` or `fcitx5-remote -n` to get the IM's name
				default_im_select  = "keyboard-us",

				-- Can be binary's name, binary's full path, or a table, e.g. 'im-select',
				-- '/usr/local/bin/im-select' for binary without extra arguments,
				-- or { "AIMSwitcher.exe", "--imm" } for binary need extra arguments to work.
				-- For Windows/WSL, default: "im-select.exe"
				-- For macOS, default: "macism"
				-- For Linux, default: "fcitx5-remote" or "fcitx-remote" or "ibus"
				default_command = "fcitx5-remote",

				-- Restore the default input method state when the following events are triggered
				-- "VimEnter" and "FocusGained" were removed for causing problems, add it by your needs
				set_default_events = { "InsertLeave", "CmdlineLeave" },

				-- Restore the previous used input method state when the following events
				-- are triggered, if you don't want to restore previous used im in Insert mode,
				-- e.g. deprecated `disable_auto_restore = 1`, just let it empty
				-- as `set_previous_events = {}`
				set_previous_events = { "InsertEnter" },

				-- Show notification about how to install executable binary when binary missed
				keep_quiet_on_no_binary = false,

				-- Async run `default_command` to switch IM or not
				async_switch_im = true
			})
		end,
	},

  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    opts = {},
  },
  -- { "HiPhish/rainbow-delimiters.nvim" },
  -- { "mklabs/vim-cowsay" },

  { "echasnovski/mini.files" },
  { "Saghen/blink.nvim",
  	version = '*',
	  keys = {
			-- chartoggle
			-- {
			--   '<C-;>',
			--   function()
			--   	require('blink.chartoggle').toggle_char_eol(';')
			--   end,
			--   mode = { 'n', 'v' },
			--   desc = 'Toggle ; at eol',
			-- },
			-- {
			--   ',',
			--   function()
			--   	require('blink.chartoggle').toggle_char_eol(',')
			--   end,
			--   mode = { 'n', 'v' },
			--   desc = 'Toggle , at eol',
			-- },
	
			-- tree
			-- { '<C-e>', '<cmd>BlinkTree reveal<cr>', desc = 'Reveal current file in tree' },
			{ '<leader>E', '<cmd>BlinkTree toggle<cr>', desc = 'Reveal current file in tree' },
			-- { '<leader>e', '<cmd>BlinkTree toggle-focus<cr>', desc = 'Toggle file tree focus' },
	  },
	  -- all modules handle lazy loading internally
	  lazy = false,
	  opts = {
	    chartoggle = { enabled = true },
	    indent = { enabled = true },
	    tree = { enabled = true }
		},
		opts_exetnds = { "sources.default" },
  },
  { "kylechui/nvim-surround" },
  { "akinsho/toggleterm.nvim" },
  { "echasnovski/mini.icons" },
  -- file picker 
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = false, },
      dashboard = { 
	  enabled = true,
          width = 60,
          row = nil, -- dashboard position. nil for center
          col = nil, -- dashboard position. nil for center
          pane_gap = 4, -- empty columns between vertical panes
          autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
          -- These settings are used by some built-in sections
          preset = {
            -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
            pick = nil,
            -- Used by the `keys` section to show keymaps.
            -- Set your custom keymaps here.
            -- When using a function, the `items` argument are the default keymaps.
            keys = {
              { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
              { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
              { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
              { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
              { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
              { icon = " ", key = "s", desc = "Restore Session", section = "session" },
              { icon = "󰒲 ", key = "L", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
              { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            },
            header = [[
               |\___/|         |\___/|          |\___/|           |\___/|    
               /O  O  \__      /O  O  \__       /O  O  \__        /O  O  \__ 
              /     /  \/_    /     /  \/_     /     /  \/_      /     /  \/_
              /     /    \/_  /     /    \/_   /     /    \/_    /     /    \/_
              @___@`      \_/ @___@`      \_/  @___@`      \_/   @___@`      \_/]],
          },   
          -- item field formatters
          formats = {
            icon = function(item)
              if item.file and item.icon == "file" or item.icon == "directory" then
                return M.icon(item.file, item.icon)
              end
              return { item.icon, width = 2, hl = "icon" }
            end,
            footer = { "%s", align = "center" },
            header = { "%s", align = "center" },
            file = function(item, ctx)
              local fname = vim.fn.fnamemodify(item.file, ":~")
              fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
              if #fname > ctx.width then
                local dir = vim.fn.fnamemodify(fname, ":h")
                local file = vim.fn.fnamemodify(fname, ":t")
                if dir and file then
                  file = file:sub(-(ctx.width - #dir - 2))
                  fname = dir .. "/…" .. file
                end
              end
              local dir, file = fname:match("^(.*)/(.+)$")
              return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or { { fname, hl = "file" } }
            end,
          },
          sections = {
            { section = "header" },
            { section = "keys", gap = 1, padding = 1 },
            { section = "startup" },
          },
      },
      explorer = { enabled = true },
      indent = { enabled = false },
      input = { enabled = false },
      picker = { enabled = true },
      notifier = { enabled = true },
      quickfile = { enabled = false },
      scope = { enabled = true },
      scroll = { enabled = false },
      statuscolumn = { enabled = true },
      words = { enabled = false },
        ---@class snacks.toggle.Config
        ---@field icon? string|{ enabled: string, disabled: string }
        ---@field color? string|{ enabled: string, disabled: string }
        ---@field wk_desc? string|{ enabled: string, disabled: string }
        ---@field map? fun(mode: string|string[], lhs: string, rhs: string|fun(), opts?: vim.keymap.set.Opts)
        ---@field which_key? boolean
        ---@field notify? boolean
      toggle = {
					enabled = true,
          map = vim.keymap.set, -- keymap.set function to use
          which_key = true, -- integrate with which-key to show enabled/disabled icons and colors
          notify = true, -- show a notification when toggling
          -- icons for enabled/disabled states
          icon = {
            enabled = " ",
            disabled = " ",
          },
          -- colors for enabled/disabled states
          color = {
            enabled = "green",
            disabled = "yellow",
          },
          wk_desc = {
            enabled = "Disable ",
            disabled = "Enable ",
          },
      },
      ---@class snacks.zen.Config
      zen = {
          -- You can add any `Snacks.toggle` id here.
          -- Toggle state is restored when the window is closed.
          -- Toggle config options are NOT merged.
          ---@type table<string, boolean>
          toggles = {
            dim = true,
            git_signs = false,
            mini_diff_signs = false,
            -- diagnostics = false,
            -- inlay_hints = false,
          },
          show = {
            statusline = true, -- can only be shown when using the global statusline
            tabline = false,
          },
          ---@type snacks.win.Config
          win = { style = "zen" },
          --- Callback when the window is opened.
          ---@param win snacks.win
          on_open = function(win) end,
          --- Callback when the window is closed.
          ---@param win snacks.win
          on_close = function(win) end,
          --- Options for the `Snacks.zen.zoom()`
          ---@type snacks.zen.Config
          zoom = {
            toggles = {},
            show = { statusline = true, tabline = true },
            win = {
              backdrop = true,
              width = 100, -- ull width
            },
				},
      },
    },
    keys = {
      -- select allを無効化
          -- ["<c-a>"] = false,
          -- ["<c-b>"] = false,
          -- ["<c-d>"] = { "preview_scroll_down", mode = { "i", "n" } },
          -- ["<c-f>"] = false,
          -- ["<c-u>"] = { "preview_scroll_up", mode = { "i", "n" } },
          -- ["<c-s>"] = false,
          -- ["<c-x>"] = { "edit_split", mode = { "i", "n" } },

        },
  },
  -- { "" },
  -- { "" },
  -- { "" },
  -- { "" },
  -- { "" },
  -- { "" },
  -- { "" },
  -- { "" },
  -- { "" },
  -- { "" },
  -- { "" },


  -- experimental
  -- **not working**
  -- 少なくともlightlineで利用するには動かないだけなので、組み込みやairline、lualineでは普通に動くと思われ
  { "mopp/sky-color-clock.vim" },



  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  -- install = { colorscheme = { "habamax" } },
  
  -- automatically check for plugin updates
  -- checker = { enabled = true },
})




Snacks.config.style("zen", {
  enter = true,
  fixbuf = false,
  minimal = false,
  width = 120,
  height = 0,
  backdrop = { transparent = true, blend = 40 },
  keys = { q = false },
  zindex = 40,
  wo = {
    winhighlight = "NormalFloat:Normal",
  },
  w = {
    snacks_main = true,
  },
})

Snacks.config.style("zoom_indicator", {
  text = "▍ zoom  󰊓  ",
  minimal = true,
  enter = false,
  focusable = false,
  height = 1,
  row = 0,
  col = -1,
  backdrop = false,
})




-- set statusline to enable this plugin.
-- vim.cmd([[ set statusline+=%#SkyColorClockTemp#\ %#SkyColorClock#%{sky_color_clock#statusline()} ]])

--  For lightline.vim
--[[vim.cmd([[ let g:lightline = {
            \ 'component': {
            \   'sky_color_clock': "%#SkyColorClock#%{' ' . sky_color_clock#statusline() . ' '}%#SkyColorClockTemp# ",
            \ },
            \ 'component_raw': {
            \   'sky_color_clock': 1,
            \ },
            \ }
	    ]]

-- fzfz / RG use config
-- 25/01/08時点で、fzfが動かない。ので一旦無効化してある
-- vim.cmd(' nnoremap <silent> <Leader>,p :GFiles<CR> ')
-- vim.cmd(' nnoremap <silent> <Leader>,P :Files<CR> ')
-- vim.cmd(' nnoremap <silent> <Leader>,s :RG<CR> ')
-- vim.cmd(' nnoremap <silent> <Leader>,c :Commits<CR> ')



require('render-markdown').setup({
  render_modes = true,
	code = {
		width = "block",
	},
})



-- single require zone
require("ibl").setup()
require('mini.files').setup()	-- change to bindings?


-- vim.keymap.set("n", "<Leader>pp", ":<CR>")

vim.opt.completeopt = menuone, noinsert
-- グローバルステータスライン→3 (※require nvim up to 0.7.0)
-- バッファ別ステータスライン→2
vim.opt.laststatus = 3

-- " ※※※※※※※※※※※※※
-- " ※Experimental  config※
-- " ※※※※※※※※※※※※※

vim.opt.title = true
vim.opt.scrolloff = 10
-- 初回起動時に$HOMEに移動しておく(Windows)
-- Linuxだとエラー吐いて設定が読み込まれないので注意
-- vim.cmd("cd ~\\")

-- 初回起動時に$HOMEに移動しておく(Linux)
-- vim.cmd("cd ~/")


-- " ※※※※※※※※※※
-- " ※Default   config※
-- " ※※※※※※※※※※

vim.g.nocompatible = true
vim.o.cursorline = true
vim.o.cursorcolumn = true
vim.o.mouse = 'a'
vim.opt.smartindent = true
vim.opt.visualbell = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.wrapscan = true

-- need settings for use Colorizer
vim.opt.termguicolors = true

-- swpファイルを残す
vim.g.noswapfile = false
-- swpファイル出力先
-- win32::本来必要ないが、最近のWIn11の更新プログラムでBSoDが頻発するようになったので一応残す。
-- vim.cmd("set directory=~\\AppData\\Local\\nvim-data\\swap")
--
-- linux::ほぼ使わないと思うが、念の為。
vim.cmd("set directory=~/.local/share/nvim/swap")

vim.g.noexpandtab = true
vim.g.tabstop = 8
vim.g.softtabstop=2
vim.g.shiftwidth = true

-- ファイルの拡張子によってタブストップとかを上書きする
vim.cmd[[
augroup fileTypeIndent
    autocmd!
    autocmd BufNewFile,BufRead *.lua setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.md setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.html setlocal tabstop=4 softtabstop=4 shiftwidth=4
    autocmd BufNewFile,BufRead *.py setlocal tabstop=2 softtabstop=2 shiftwidth=2
    autocmd BufNewFile,BufRead *.php setlocal tabstop=4 softtabstop=4 shiftwidth=4
augroup END
]]

-- タブ設定はTreeSitterとかで自動判定させた方が良いかもしれないが・・・
-- 常にgitとmsys2が常駐する環境ではない可能性も踏まえてこちらで設定


-- ---

-- clipboard config
vim.opt.clipboard:append{'unnamedplus'}

-- コマンド入力時のタイムアウト時間の設定(msec, neovim default = 1000msec)
vim.o.ttimeout = false 		-- if, 'false' is use default setting
vim.o.timeoutlen = 1000
vim.o.ttimeoutlen = 0		-- ここを増やすとバインド待ちの時間が発生してしまうので注意


-- 行番号の相対表示と絶対表示の併用(どっちも'true')
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.list = true

-- 空白や改行などの可視化
vim.cmd('set listchars=tab:>-,trail:*,eol:↲')
-- neovimの場合は'double'よりも'single'の方が綺麗に(整って)表示される？
vim.opt.ambiwidth = "single"

-- Markdown, PHP, html or other filetype set command shortcut
vim.keymap.set("c", "sfm", "set filetype=markdown")
vim.keymap.set("c", "sfl", "set filetype=lua")
vim.keymap.set("c", "sfh", "set filetype=html")
vim.keymap.set("c", "sfp", "set filetype=php")

-- Markdown code-block syntax highlighting
vim.cmd("let g:markdown_fenced_languages = [ 'cpp', 'html', 'json', 'javascript', 'lua', 'php']")
-- ``の間をハイライトする
vim.cmd("autocmd Colorscheme * highlight link markdownCode Constant")


-- <Tab>、<S-Tab>で変換候補を選択できるようにする
-- vim.cmd("imap <expr> <Tab> coc#pum#next()? '\<C-n>' : '\<Tab>'")
-- vim.cmd("inoremap <expr> <S-Tab> pumvisible() ? '\<C-p>' : '\<S-Tab>'")



-- ※※※※※※※※※※
-- ※※window move mappings※※
-- ※※※※※※※※※※ 





-- ※※※※※※※※※※
-- ※※tab config ※※
-- ※※※※※※※※※※

-- tab create / delete *require nvim-qt
vim.keymap.set("n", "<C-t>", ":tabnew<CR>")
vim.keymap.set("n", "<C-S-t>", ":tabc<CR>")

-- tab move *require nvim-qt
vim.keymap.set("n", "<C-Tab>", ":tabnext<CR>")
vim.keymap.set("n", "<C-S-Tab>", ":tabprevious<CR>")

-- buffer move
vim.keymap.set("n", "<C-j>", ":bnext<CR>")
vim.keymap.set("n", "<C-k>", ":bprev<CR>")


-- move cursorline remap(normal)
-- vim.keymap.set("n", "j", "gj")
-- vim.keymap.set("n", "k", "gk")
-- move cursorline remap to 'set relativenumber'  options
-- !!PLEASE DISABLED NORMALMODE SWAP J AND GJ KEYMAPPING!! --
vim.cmd("nnoremap <expr> j v:count ? 'j' : 'gj'")
vim.cmd("nnoremap <expr> k v:count ? 'k' : 'gk'")

-- swap {, } to W/B
vim.keymap.set("n", "B", "{")
vim.keymap.set("n", "W", "}")


-- vim.keymap.set
-- vim.keymap.set("n", "<Esc><Esc>", ":nohlsearch<CR><Esc>") --whichkeyでいちいち表示がでてウザイので削除。もしかするとwhichkeyでこのマッピングだけ消す、という方法が使える場合があるのかもしれないが・・・
vim.keymap.set("n", "<C-w>n", "<Esc>:enew<Return>")
vim.keymap.set("n", ":vsn", ":vnew<Return>")
-- vim.keymap.set("n", ":spn", ":spnew<Return>")
vim.cmd("set whichwrap=b,s,<,>,[,]")

-- need buffergator plugin
-- vim.keymap.set("n", "<leader>b", ":BuffergatorToggle<CR><Esc>")

-- Telescope shortcut map
vim.keymap.set("n", "<Leader><C-f>", ":Telescope<CR>")

-- View split Diff window
vim.keymap.set("n", "<Leader><C-d>", ":diffthis<CR>")
vim.keymap.set("n", "<Leader><C-S-d>", ":diffoff<CR>")

-- Leave InsertMode
vim.keymap.set("i", "kj", "<Esc>")
vim.keymap.set("i", "ｋｊ", "<Esc>")

vim.keymap.set("v", "kj", "<Esc>")
vim.keymap.set("v", "ｋｊ", "<Esc>")


-- Entering Ex mode from NORMAL mode
-- vim.keymap.set("n", "lkj", ":")

-- completion window movekey is default to allow
vim.cmd('imap <expr><C-n> pumvisible() ? "<Down>" : "<C-n>"')
vim.cmd('imap <expr><C-p> pumvisible() ? "<Up>" : "<C-p>"')


-- ToggleTerm use shortcut key
require("toggleterm").setup{
  size = 100,
  open_mapping = [[<leader>tt]],
  hide_numbers = true,
  shade_filetypes = {},
  shade_terminals = true,
  shading_factor = 2,
  start_in_insert = true,
  insert_mappings = true,
  persist_size = true,
  direction = 'float',
  close_on_exit = true,
  -- bashをデフォルトの端末として設定する場合
  -- git bashの場合は下記の通り設定
	-- その他のシェルを設定する場合は、適宜変更する
  vim.cmd [[let &shell = '"C:\Program Files\Git\bin\bash.exe"']],
  vim.cmd [[let &shellcmdflag = '-s']],
}


-- ※※※※※※※※※※
-- ※※GUI config ※※
-- ※※※※※※※※※※
vim.cmd("set fileformats=dos,unix,mac")

--  GUI font configuration
--  Windowsの標準フォントで使用する場合
-- vim.g.guifont = "BIZ\\ UDゴシック:h14"
vim.g.guifont = "Juisee_HWNF:h14"
-- コマンド一発でGUIの文字のサイズを変更できるようにする　BIG= 20, Mid= 18, Small= 14
-- GUIクライアントによっては動かないものがあるかも。端末エミュレータなど。
vim.cmd("cmap VS set guifont=Juisee_HWNF:h14:cutf-8 guifontwide=Juisee_HWNF:h14")
vim.cmd("cmap VSS set guifont=Juisee_HWNF:h12:cutf-8 guifontwide=Juisee_HWNF:h12")
vim.cmd("cmap VSSS set guifont=Juisee_HWNF:h9:cutf-8 guifontwide=Juisee_HWNF:h9")

-- vim.cmd("cmap VDD set guifont=Juisee HWNF:h10:cutf-8 guifontwide=Juisee HWNF:h10")


-- Toggle Fern
-- vim.keymap.set('n','<Leader>e',':Fern ~/ -reveal=% -drawer -toggle -width=30<CR>')

-- telescope.nvim bind config
vim.keymap.set("n", "<Leader>fb", ":lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>")
vim.keymap.set("n", "<Leader>fg", ":Telescope live_grep<CR>")

-- BufSelect list show 
vim.keymap.set('n', '<leader>b', ':ShowBufferList<CR>')

-- Mini.Files maps
-- see more doc :: https://github.com/echasnovski/mini.files
-- vim.keymap.set('n', '<leader>f', ':lua MiniFiles.open()<CR>')

-- Fern cd
vim.keymap.set("n", "<Leader><Leader>cd", "<Plug>(fern-action-cd)<CR>")


-- plus path
-- vim.keymap.set("n", "<Leader>bb", "")
--
--

-- snacks.nvim keymaps config
-- requirements snacks.nvim, but doesn't work now. :(
-- Top Pickers & Explorer
vim.keymap.set( "n",  "<leader><leader>s", function() require("snacks.picker").smart() end, { desc = "" })
vim.keymap.set( "n", "<leader>,", function() require("snacks.picker").buffers() end, { desc = "" })
vim.keymap.set( "n", "<leader>/", function() require("snacks.picker").grep() end, { desc = "" })
vim.keymap.set( "n", "<leader>:", function() require("snacks.picker").command_history() end, { desc = "" })
vim.keymap.set( "n", "<leader>n", function() require("snacks.picker").notifications() end, { desc = "" })
vim.keymap.set( "n", "<leader>e", function() Snacks.explorer() end, { desc = "" })

-- find
vim.keymap.set( "n", "<leader>fb", function() require("snacks.picker").buffers() end, { desc = "" })
vim.keymap.set( "n", "<leader>fc", function() require("snacks.picker").files({ cwd = vim.fn.stdpath("config") }) end, { desc = "" })
vim.keymap.set( "n", "<leader>fs", function() require("snacks.picker").files() end, { desc = "" })
-- -- { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find Git Files" )
-- vim.keymap.set( "n", "<leader>fp", function() require("snacks.picker").projects() end, { desc = "" })
-- vim.keymap.set( "n", "<leader>fr", function() require("snacks.picker").recent() end, { desc = "" })
-- -- git
-- -- { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
-- -- { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
-- -- { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
-- -- { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
-- -- { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
-- -- { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
-- -- { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },

-- -- Grep
--
-- vim.keymap.set("n", "<leader>sb", function() Snacks.picker.lines() end, { desc = "" })
vim.keymap.set("n", "<leader>sB", function() Snacks.picker.grep_buffers() end, { desc = "" })
vim.keymap.set("n", "<leader>sg", function() Snacks.picker.grep() end, { desc = "" })
vim.keymap.set("n", "<leader>sw", function() Snacks.picker.grep_word() end, { desc = "" })
-- -- search
-- { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },

vim.keymap.set("n", "<leader>s/", function() Snacks.picker.search_history() end, { desc = "search history list"})
-- { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
-- { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
vim.keymap.set("n", "<leader>kj", function() Snacks.picker.lines() end, { desc = "Snacks: word line picker" })
-- { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
-- { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
-- { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
-- { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
-- { "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
-- { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
-- { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
-- { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Jumps" },
-- キーマップ検索
vim.keymap.set("n", "<leader>sk", function() Snacks.picker.keymaps() end, { desc = "" })
-- { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Location List" },
-- { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
-- { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
-- { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
-- { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
-- { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
-- { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },
-- { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },

-- LSP関連
vim.keymap.set("n", "gd", function() require("snacks.picker").lsp_definitions() end, { desc = "" })
vim.keymap.set("n", "gD", function() require("snacks.picker").lsp_declarations() end )
vim.keymap.set("n", "gr", function() require("snacks.picker").lsp_references() end )
vim.keymap.set("n", "gI", function() require("snacks.picker").lsp_implementations() end, { desc = "" })
vim.keymap.set("n", "gy", function() require("snacks.picker").lsp_type_definitions() end, { desc = "" })
vim.keymap.set("n", "<leader>ss", function() Snacks.picker.lsp_symbols() end, { desc = "" })
vim.keymap.set("n", "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, { desc = "" })


-- snacks.scratch config
vim.keymap.set("n", "<leader>S", function() Snacks.scratch() end, { desc = "" })
-- Select Scratch Buffer
vim.keymap.set("n", "<leader>SA", function() Snacks.scratch.select() end, { desc = "" })



--Zen toggle experimental setting
-- vim.keymap.set("n", "<leader>zZ", function() Snacks.toggle.zen() end, { desc = "" })
vim.keymap.set("n", "<leader>ff", function() Snacks.zen() end, { desc = "" })


vim.keymap.set("n", "<leader>tZ", function() Snacks.toggle.zoom() end, { desc = "" })

-- ※※※※※※※※※※
-- ※IME configuration※
-- ※※※※※※※※※※

-- Windowsの場合::ime off(spzenhanを使用する場合※環境変数Pathに追加する必要あり)
-- ※環境によっては動作しないかも、またはLinuxでは適宜書き換える必要あり
--  例：im-select、fcitx-remoteなど
-- vim.cmd [[
-- if executable('spzenhan')
-- 	let s:lastimestate = 0
-- 	autocmd InsertLeave * :call system('spzenhan 0')
-- 	" autocmd InsertLeave * s:call system('spzenhan 0')* :call system('spzenhan 0')
-- 	autocmd CmdlineLeave * :call system('spzenhan 0')
-- 	endif
-- ]]

-- Linuxの場合::fcitx-remote + im-select.nvim
-- 動作確認環境：Ubuntu24.04.3LTS(amd64), ja-JP, fcitx5-mozc, US配列
-- ※lazyのプラグインインストールセクションに書いた通り、keaising/im-select.nvimを使って切り替える。
-- https://github.com/keaising/im-select.nvim
-- 

vim.g.showtabline = 2
vim.g.noshowmode = false


-- Startify.vim AA config to fire dragon, cow, and 須藤.
vim.cmd([[ let g:startify_custom_header = [
\ '         ______________________________________________ ',
\ '        < 🐉With great power comes great responsibility. >',
\ '         ---------------------------------------------- ',
\ '                        \                    ^    /^',
\ '                         \                  / \  // \',
\ '                          \   |\___/|      /   \//  .\',
\ '                           \  /O  O  \__  /    //  | \ \           *----*',
\ '                             /     /  \/_/    //   |  \  \          \   |',
\ '                             @___@`    \/_   //    |   \   \         \/\ \',
\ '                            0/0/|       \/_ //     |    \    \         \  \',
\ '                        0/0/0/0/|        \///      |     \     \       |  |',
\ '                     0/0/0/0/0/_|_ /   (  //       |      \     _\     |  /',
\ '                  0/0/0/0/0/0/`/,_ _ _/  ) ; -.    |    _ _\.-~       /   /',
\ '                              ,-}        _      *-.|.-~-.           .~    ~',
\ '             \     \__/        `/\      /                 ~-. _ .-~      /',
\ '              \____(oo)           *.   }            {                   /',
\ '              (    (--)          .----~-.\        \-`                 .~',
\ '              //__\\  \__ Ack!   ///.----..<        \             _ -~',
\ '             //    \\               ///-._ _ _ _ _ _ _{^ - - - - ~',
\ ' ',
\ ]
]])

