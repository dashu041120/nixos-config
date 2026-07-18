# Zsh配置说明

这个配置将你的zshrc别名转换为Nix配置，并添加了常用的zsh插件。

## 包含的功能

### 1. 别名 (Aliases)
- **文件操作**: `c` (clear), `l`, `ls`, `ll`, `ld` (使用eza)
- **目录导航**: `..`, `...`, `.3`, `.4`, `.5`
- **NixOS管理**: `rebuild`, `rebuild-test`, `update`
- **开发工具**: `vc` (VSCode), `ssh` (kitten ssh)
- **安全别名**: `cp -i`, `mv -i`, `rm -i`

### 2. Zsh插件 (使用内置选项)
- **autosuggestion**: 自动建议 (`programs.zsh.autosuggestion.enable`)
- **syntax-highlighting**: 语法高亮 (`programs.zsh.syntaxHighlighting.enable`)
- **completion**: 增强的命令补全 (`programs.zsh.enableCompletion`)
- **history-substring-search**: 历史子字符串搜索 (`programs.zsh.historySubstringSearch.enable`)

### 3. 自定义函数
- `mkcd`: 创建目录并进入
- `h`: 搜索历史记录
- `f`: 快速查找文件
- `fe`: 查找并编辑文件
- `gcom`: Git快速提交
- `gcp`: Git提交并推送

### 4. 包含的工具
- `eza`: 现代ls替代品
- `bat`: 现代cat替代品
- `fzf`: 模糊查找器
- `ripgrep`: 快速grep
- `fd`: 快速find
- `tree`: 目录树
- `htop`: 进程监视器
- `neofetch`: 系统信息
- `tmux`: 终端复用器

## 原zshrc中的包管理别名说明

原配置中的AUR相关别名（`un`, `up`, `pl`, `pa`, `pc`, `po`）在NixOS中不适用，因为：
- NixOS使用不同的包管理系统
- 包管理通过配置文件而非命令行进行
- 已替换为NixOS相关的别名

## 使用方法

1. 配置已添加到 `modules/home/default.nix`
2. 运行 `rebuild` 别名来应用配置
3. 重启终端或运行 `exec zsh` 来加载新配置

## 自定义

你可以在 `zsh.nix` 中：
- 添加更多别名到 `shellAliases` 部分
- 修改环境变量在 `sessionVariables` 部分
- 添加自定义函数到 `initExtra` 部分
- 启用更多zsh选项到 `options` 部分

## 配置优化说明

这个配置使用了NixOS内置的zsh选项，而不是手动从GitHub获取插件源码：

- `programs.zsh.autosuggestion.enable` - 内置自动建议功能
- `programs.zsh.syntaxHighlighting.enable` - 内置语法高亮
- `programs.zsh.enableCompletion` - 内置补全系统
- `programs.zsh.historySubstringSearch.enable` - 内置历史搜索

这种方式的优势：
- 更快的构建时间（无需编译插件）
- 更好的集成（官方维护）
- 更稳定的版本管理
- 减少配置复杂度
