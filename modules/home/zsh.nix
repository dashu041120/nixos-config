{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;
    
    # 补全配置
    completionInit = "autoload -Uz compinit && compinit";
    
    # 历史记录配置
    history = {
      size = 10000;
      save = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
      ignoreDups = true;
      ignoreSpace = true;
      extended = true;
    };

    # Shell别名
    shellAliases = {
      # 有用的别名
      c = "clear";  # 清空终端
      l = "eza -lh --icons=auto";  # 长列表
      ls = "eza -1 --icons=auto";  # 短列表
      ll = "eza -lha --icons=auto --sort=name --group-directories-first";  # 长列表显示所有
      ld = "eza -lhD --icons=auto";  # 长列表显示目录
      
      # 包管理别名 (这些在NixOS中可能需要调整)
      # un = "$aurhelper -Rns";  # 卸载包
      # up = "$aurhelper -Syu";  # 更新系统/包/aur
      # pl = "$aurhelper -Qs";   # 列出已安装包
      # pa = "$aurhelper -Ss";   # 列出可用包
      # pc = "$aurhelper -Sc";   # 删除未使用缓存
      # po = "$aurhelper -Qtdq | $aurhelper -Rns -";  # 删除未使用包
      
      # NixOS 相关别名
      rebuild = "sudo nixos-rebuild switch --flake .#laptop";
      rebuild-test = "sudo nixos-rebuild test --flake .#laptop";
      # rebuild = "sudo nh os switch laptop";
      # rebuild-test = "sudo nh os test --flake .#laptop";
      update = "nix flake update";
      search = "nh search --limit 8";
      # VSCode
      vc = "code --ozone-platform-hint=wayland --disable-gpu";  # GUI代码编辑器
      
      # 方便的目录切换快捷方式
      ".." = "cd ..";
      "..." = "cd ../..";
      ".3" = "cd ../../..";
      ".4" = "cd ../../../..";
      ".5" = "cd ../../../../..";
      
      # 总是递归创建目录
      mkdir = "mkdir -p";
      
      # 修复通过ssh使用默认kitty终端打开某些程序时的"Error opening terminal: xterm-kitty"错误
      ssh = "kitten ssh";
      
      # 其他有用的别名
      grep = "grep --color=auto";
      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -i";
    };

    # 环境变量
    sessionVariables = {
      EDITOR = "kate";  # 默认文本编辑器
      BROWSER = "firefox";
      TERMINAL = "ghostty";
    };

    # Zsh选项
    # setOptions = [
    #   "AUTO_CD"              # 自动cd到目录
    #   "HIST_VERIFY"          # 历史扩展时提示
    #   "SHARE_HISTORY"        # 在会话间共享历史
    #   "HIST_IGNORE_SPACE"    # 忽略以空格开头的命令
    #   "HIST_IGNORE_DUPS"     # 忽略重复命令
    #   "HIST_FIND_NO_DUPS"    # 搜索时忽略重复
    #   "AUTO_PUSHD"           # 自动pushd
    #   "PUSHD_IGNORE_DUPS"    # pushd时忽略重复
    #   "PUSHD_SILENT"         # 静默pushd
    # ];

    # 初始化脚本
    initContent = ''
      # 自定义函数
      function mkcd() {
        mkdir -p "$1" && cd "$1"
      }
      
      # 快速搜索历史
      function h() {
        if [ $# -eq 0 ]; then
          history
        else
          history | grep "$@"
        fi
      }
      
      # 快速查找文件
      function f() {
        find . -name "*$1*" 2>/dev/null
      }
      
      # 快速查找并编辑文件
      function fe() {
        local file
        file=$(find . -name "*$1*" 2>/dev/null | head -1)
        if [ -n "$file" ]; then
          $EDITOR "$file"
        else
          echo "File not found: *$1*"
        fi
      }
      
      # Git相关函数
      function gcom() {
        git add .
        git commit -m "$1"
      }
      
      function gcp() {
        git add .
        git commit -m "$1"
        git push
      }

      # 开启智能大小写补全
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
      
      # 自动启动tmux (可选)
      # if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
      #   exec tmux
      # fi

      export QT_IM_MODULE=fcitx5
      
      # # 强制设置正确的桌面环境变量（解决GNOME设置无法打开的问题）
      # export XDG_CURRENT_DESKTOP=gnome
      # export XDG_SESSION_DESKTOP=gnome
    '';
  };

  # 确保需要的包被安装
  home.packages = with pkgs; [
    eza           # 现代的ls替代品
    bat           # 现代的cat替代品
    fzf           # 模糊查找器
    ripgrep       # 快速grep替代品
    fd            # 快速find替代品
    tree          # 目录树显示
    htop          # 进程监视器
    neofetch      # 系统信息显示
    tmux          # 终端复用器
    git           # 版本控制
    curl          # HTTP客户端
    wget          # 下载工具
    unzip         # 解压工具
    zip           # 压缩工具
  ];
}
