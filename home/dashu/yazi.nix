{pkgs, ...}: let
	# yazi-plugins = pkgs.fetchFromGitHub {
	# 	owner = "yazi-rs";
	# 	repo = "plugins";
	# 	rev = "...";
	# 	hash = "sha256-...";
	# };
in {
	programs.yazi = {
		enable = true;
		enableZshIntegration = true;
		shellWrapperName = "y";

		settings = {
			mgr = {
				show_hidden = true;
			};
			preview = {
				max_width = 1000;
				max_height = 1000;
			};
		};
		
		plugins = {
			# chmod = "${yazi-plugins}/chmod.yazi";
			# full-border = "${yazi-plugins}/full-border.yazi";
			# toggle-pane = "${yazi-plugins}/toggle-pane.yazi";
			# starship = pkgs.fetchFromGitHub {
			# 	owner = "Rolv-Apneseth";
			# 	repo = "starship.yazi";
			# 	rev = "...";
			# 	sha256 = "sha256-...";
			# };
			# 常用插件，直接引用 nixpkgs 的 yaziPlugins 包（module 接受 package 或 path）
			chmod = pkgs.yaziPlugins.chmod;
			"toggle-pane" = pkgs.yaziPlugins."toggle-pane";
			"full-border" = pkgs.yaziPlugins."full-border";
			starship = pkgs.yaziPlugins.starship;
			yatline = pkgs.yaziPlugins.yatline;
			"yatline-catppuccin" = pkgs.yaziPlugins."yatline-catppuccin";
			glow = pkgs.yaziPlugins.glow;
			lsar = pkgs.yaziPlugins.lsar;
			piper = pkgs.yaziPlugins.piper;
			"mime-ext" = pkgs.yaziPlugins."mime-ext";
			lazygit = pkgs.yaziPlugins.lazygit;
			bookmarks = pkgs.yaziPlugins.bookmarks;
			"smart-enter" = pkgs.yaziPlugins."smart-enter";
			"smart-paste" = pkgs.yaziPlugins."smart-paste";

		};

		# 启动时为 Lua 插件做简单初始化，用于美化外观和状态行
		# chmod = "${yazi-plugins}/chmod.yazi";
			# full-border = "${yazi-plugins}/full-border.yazi";
			# toggle-pane = "${yazi-plugins}/toggle-pane.yazi";
			# starship = pkgs.fetchFromGitHub {
			# 	owner = "Rolv-Apneseth";
			# 	repo = "starship.yazi";
			# 	rev = "...";
			# 	sha256 = "sha256-...";
			# };
		initLua = ''
			-- 用稳健的 pcall 封装初始化，每个插件独立处理错误
			pcall(function()
				local ok, mod = pcall(require, "full-border")
				if ok and type(mod) == "table" and type(mod.setup) == "function" then
					mod.setup(mod)
				end
			end)
			pcall(function()
				local ok, mod = pcall(require, "starship")
				if ok and type(mod) == "table" and type(mod.setup) == "function" then
					mod.setup(mod)
				end
			end)
			pcall(function()
				local ok, mod = pcall(require, "yatline")
				if ok and type(mod) == "table" and type(mod.setup) == "function" then
					mod.setup(mod)
				end
			end)
			pcall(function()
				local ok, mod = pcall(require, "yatline-catppuccin")
				if ok and type(mod) == "table" and type(mod.setup) == "function" then
					mod.setup(mod)
				end
			end)
		'';

		keymap = {
			mgr.prepend_keymap = [
				{
					on = "<F11>";
					run = "plugin toggle-pane max-preview";
					desc = "Toggle full-window preview";
				}
				{
					on = "T";
					run = "plugin toggle-pane max-preview";
					desc = "Maximize or restore the preview pane";
				}
				{
					on = ["c" "m"];
					run = "plugin chmod";
					desc = "Chmod on selected files";
				}
			];
		};
	};

				# yaziPlugins.yatline-catppuccin
}

		# ---------------- Yazi 常用快捷键（更完整，基于默认 keymap） ----------------
		# 说明：下列键位来自 Yazi 默认 keymap（可通过 yazi 的 `keymap` 配置覆盖）。
		# 若要完全自定义，请在 yazi 的 keymap 文件中重写相应键位。
		#
		# 导航与视图：
		# - `j` / `k` 或 ↑ / ↓       : 向下 / 向上 移动光标
		# - `h` / <Left>             : 返回上一级目录
		# - `l` / <Enter> / <Right>  : 进入目录或打开文件
		# - `gg` / `G`               : 跳到顶部 / 底部
		# - `<Space>`                : 切换选中并移动到下一个
		# - `v` / `V`                : 进入可视（选择）模式 / 取消可视模式
		# - `t`                      : 在当前路径创建新标签页
		#
		# 剪切/复制/粘贴：
		# - `y`                      : yank（复制）选中文件
		# - `x`                      : yank --cut（剪切；把选中文件置于 yank 状态以便粘贴）
		# - `p` / `P`                : paste（粘贴），`P` 强制覆盖
		# - `Y` / `X`                : 取消 yank（取消剪切/复制状态）
		# - `-` / `_` / `<C-->`      : link / link --relative / hardlink（创建符号/硬链接）
		#
		# 文件操作（创建 / 重命名 / 删除 / 链接）：
		# - `a`                      : create（创建文件/目录）
		# - `r`                      : rename（重命名）
		# - `d`                      : remove（移到回收站 / Trash）
		# - `D`                      : remove --permanently（永久删除）
		# - `c` `c` / `c` `f` 等     : copy path/filename 等（见 copy 子命令）
		#
		# 过滤/搜索/跳转：
		# - `/`                      : find / 交互式查找
		# - `s` / `S`                : search（s 用 fd，S 用 rg）
		# - `z` / `Z`                : 插件跳转（`z` -> fzf，`Z` -> zoxide）
		# - `g` 系列（例如 `g f`、`g d`）: 快速跳转到预设目录或 bookmark
		#
		# 预览与插件：
		# - Tab / Spot              : 打开 spotter（文件信息）
		# - 本配置已启用插件：`full-border`、`starship`、`yatline`、`yatline-catppuccin`、
		#   `glow`、`lsar`、`piper`、`mime-ext`、`lazygit`、`bookmarks`、`smart-enter`、`smart-paste`
		# - 插件调用示例：`plugin <plugin-name> <action>`（例如 `plugin toggle-pane max-preview`）
		#
		# 其他常用：
		# - `:` / `;`                : 进入交互 shell 模式（可运行命令）
		# - `.`                      : 切换显示隐藏文件
		# - `w`                      : 显示任务管理器（tasks）
		# - `~` / <F1>               : 帮助
		# - `q` / <Esc>              : 退出 / 取消
		#
		# 注：以上为常用默认键位，若你在运行时发现行为不同，请运行 yazi 内置帮助或查看
		#      默认 keymap 文件 `yazi-config/preset/keymap-default.toml` 以获取最新、完整映射。
		# ---------------------------------------------------------------------------
