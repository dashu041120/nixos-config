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
			manager = {
				show_hidden = true;
			};
			preview = {
				max_width = 1000;
				max_height = 1000;
			};
		};
		
		plugins = {
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

		initLua = ''
		pcall(require, "full-border") and require("full-border"):setup()
		pcall(require, "starship") and require("starship"):setup()
		pcall(require, "yatline") and require("yatline"):setup()
		pcall(require, "yatline-catppuccin") and require("yatline-catppuccin"):setup()
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