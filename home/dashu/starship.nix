{ pkgs, ... }:
#    (home.packages = [ pkgs.nerdfonts ];)
#


let
  colors = {
    os       = "#ACB0BE";
    pink     = "#F5C2E7";
    lavender = "#B4BEFE";
    blue     = "#89B4FA";
  };
in
{
  programs.starship = {
    enable = true;

    settings = {
      # 在提示符之间添加一个换行符，使得上下文和输入分离，更清晰。
      add_newline = false;

      # 定义提示符的整体布局
      # format 字符串决定了各个模块的显示顺序和结构。
      # $all 表示所有未在 format 中明确指定的模块将在这里显示。
      # $line_break 用于换行，实现双行效果。
      # format = ''
      #   $os$directory$git_branch
      #   $character
      # '';

      # format = "$all$nix_shell$nodejs$lua$golang$rust$php$git_branch$git_commit$git_state$git_status\n$username$hostname$directory";
      
       format = "$os$nix_shell$python$nodejs$lua$golang$rust$php$directory$git_branch$git_status\n$character";

      # ---------------------------
      # -- 模块配置 (Module Configs) --
      # ---------------------------

      # 对应 OMP 的 "os" segment
      # template: "{{.Icon}} "
      # os = {
      #   style = "bold ${colors.os}";
      #   format = "  ";
      #   disabled = false; # 确保显示
      # };
      os = {
        style = "bold ${colors.os}";
        format = " "; # Nerd Font: nf-dev-archlinux (U+EBC3) # 安装archcraft字体即可显示
        disabled = false; # 确保显示
      };
      
      # 对应 OMP 的 "session" segment
      # template: "{{ .UserName }}@{{ .HostName }} "
      username = {
        show_always = true;
        style_user = "bold ${colors.blue}";
        style_root = "bold red";
        format = "[$user]($style)@"; # 注意这里以@结尾，不带空格
      };
      hostname = {
        ssh_only = false;
        style = "bold ${colors.blue}";
        format = "[$hostname]($style) "; # 这里主机名后带空格
      };

      # 上一个命令的执行时长
      cmd_duration = {
        min_time = 500; # 只显示执行时间超过 500ms 的命令
        format = "took [$duration]($style) ";
        style = "yellow";
      };

      # 当前时间
      time = {
        disabled = false;
        format = "at [$time]($style) ";
        style = "dimmed green";
        time_format = "%T"; # 例如: 14:30:59
      };

      # ---------------------------

      # 对应 OMP 的 "path" segment
      # template: "{{ .Path }} "
      # 路径压缩显示：当路径较长时，中间目录只显示首字母，保留最后目录完整名称
      # 例如：/home/user/very/long/path/name 显示为 ~/v/l/p/name
      directory = {
        style = "bold ${colors.pink}";
        truncation_length = 3;           # 超过8层目录时才开始压缩（设置较大值以始终显示完整路径）
        truncate_to_repo = false;        # 不截断到 git 仓库根目录
        fish_style_pwd_dir_length = 1;   # 关键选项：中间目录只显示 1 个字符（首字母）
        home_symbol = "~";
        format = "[$path]($style)[$read_only]($read_only_style) ";
      };

      # ---------------------------
      
      # 对应 OMP 的 "git" segment
      # template: "{{ .HEAD }} "
      git_branch = {
        symbol = " "; # Nerd Font: nf-fa-git_branch
        style = "bold ${colors.lavender}";
        format = "[$symbol$branch]($style) ";
      };
      # OMP 的 git segment 比较简洁，这里禁用 Starship 其他 git 模块以保持一致
      git_commit = {
        disabled = true;
      };
      git_status = {
        style = "bold ${colors.lavender}";
        conflicted = "⚔️ ";
        ahead = " ";      # Nerd Font: nf-fa-arrow_up
        behind = " ";     # Nerd Font: nf-fa-arrow_down
        diverged = "🔱 ";
        untracked = " ";    # Nerd Font: nf-fa-question
        stashed = "󰋀 ";      # Nerd Font: nf-md-database
        modified = "󰏬 ";     # Nerd Font: nf-md-pencil
        staged = "[++\($count\)](green)";
        renamed = " renaming";
        deleted = "🗑️ ";
      };
      
      # -------------------------
      # -- 语言与环境模块 --
      # -------------------------

      # Nix Shell 环境
      nix_shell = {
        symbol = " "; # Nerd Font: nf-dev-nixos unicode:F313
        style = "bold blue";
        format = "[$symbol]($style)"; # 只显示图标，不显示 impure/pure 消息
        impure_msg = "impure";
        pure_msg = "pure";
      };

      # Node.js 环境
      nodejs = {
        symbol = "󰎙 "; # Nerd Font: nf-md-nodejs
        style = "bold green";
      };

      # Python 环境
      python = {
        symbol = "󰌠 "; # Nerd Font: nf-md-language_python
        style = "bold yellow";
      };
      
      # Golang 环境
      golang = {
        symbol = " "; # Nerd Font: nf-dev-go
        style = "bold cyan";
      };

      # ---------------------------
      
      # 对应 OMP 的最后一个 "text" segment (提示符字符)
      # template: "\uf105"
      character = {
        success_symbol = "[➜](bold ${colors.os})"; # Nerd Font: nf-fa-angle_right (U+F105)
        error_symbol = "[✗](bold red)";
        vimcmd_symbol = "[V➜](bold green)";
      };
    };
  };
}