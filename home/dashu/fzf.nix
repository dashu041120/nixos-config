{ ... }:
{
  programs.fzf = {
    enable = true;

    enableZshIntegration = true;

    defaultCommand = "fd --hidden --strip-cwd-prefix --exclude .git";
    fileWidget = {
      options = [
        "--preview 'if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi'"
      ];
    };
    changeDirWidget = {
      command = "fd --type=d --hidden --strip-cwd-prefix --exclude .git";
      options = [
        "--preview 'eza --tree --color=always {} | head -200'"
      ];
    };

    ## Theme
    defaultOptions = [
      "--style=full"
      "--height=40%"
      "--layout=reverse"    # 结果在上，输入在下
      "--border=rounded"
      # "--margin=1,2"        # 外边距
      "--padding=1,2"       # 内边距
      "--marker='>' --pointer='>' --separator='─' --scrollbar='│'"
      "--info='right'"
      "--bind change:top"
      # "--bind 'focus:transform-preview-label:[[ -n {} ]] && printf " Previewing [%s] " {}' "
      # "--bind 'focus:+transform-header:file --brief {} || echo "No file selected"'"
      "--bind 'ctrl-r:change-list-label( Reloading the list )+reload(sleep 2; git ls-files)'"

    ];

    colors = {
      # bg    = "#1e1e2e";
      # "bg+" = "#313244";
      # fg    = "#cdd6f4";
      # "fg+" = "#cdd6f4";
      # hl    = "#89b4fa";
      # "hl+" = "#89b4fa";
      info    = "#89b4fa";
      prompt  = "#89b4fa";
      pointer = "#89b4fa";
      marker  = "#89b4fa";
      spinner = "#89b4fa";
      header  = "#45475a";

      border = "#aaaaaa";
      label  = "#cccccc";
      preview-border = "#9999cc";
      preview-label  = "#ccccff";
      list-border = "#669966";
      list-label  = "#99cc99";
      input-border = "#996666";
      input-label  = "#ffcccc";
      header-border = "#6699cc";
      header-label  = "#99ccff";
    };
  };
}