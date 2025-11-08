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
      format = ''
        $os$directory$git_branch
        $character
      '';
      
      # ---------------------------
      # -- 模块配置 (Module Configs) --
      # ---------------------------

      # 对应 OMP 的 "os" segment
      # template: "{{.Icon}} "
      os = {
        style = "bold ${colors.os}";
        format = "  ";
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
      # OMP "agnoster_short" 风格，这里用 truncation_length = 2 近似
      directory = {
        style = "bold ${colors.pink}";
        truncation_length = 2;
        truncation_symbol = "…/";
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
        style = "bold red";
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