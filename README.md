this is my nixos config

`home-manager switch --flake .#dashu@laptop-rog-gu603`

`cd /home/dashu/nixos-config && sudo nixos-rebuild switch --flake .#laptop`

`cd /home/dashu/nixos-config && sudo nixos-rebuild switch --flake .#vm`

> ! hyprland 相关配置即将从本仓库剥离
> 日后会采用git clone命令方式自动配置



# 1. 进入项目目录

cd /home/dashu/Desktop/nixos-config

# 2. 切换到迁移分支

git checkout migrate-to-nix-standalone

# 3. 运行初始化脚本（只需一次）

bash home/scripts/init-nix-env.sh

# 4. 验证配置

nix flake show

# 5. 构建配置（检查错误）

nix build .#homeConfigurations.dashu@laptop.activationPackage

# 6. 应用配置

nix run home-manager -- switch --flake .#dashu@laptop

## TODO

impoertant degree:A B C D

- [ ] 引入 `nixvim`(lazyvim简易配置即可) (B)
- [ ] 目前剪切板（能够查看历史记录）还没有完善 (B)
- [X] 输入法：切换输入法语言时，无需保留当前的第一个候选词，需要在 `oh-my-rime`的配置中修改 (A) (在fcitx5-configuretool 里面修改即可)
- [ ] 输入法：需要匹配窗口设置不同的输入策略，比如vscode强制半角符号，进入先切换为英文 (D)
- [ ] 可以完善输入法的输入特殊字符(如制表符、运算符、圈圈文字等等)和**emoji**的能力：建议像windows11一样，使用 `super+v`快捷键调出选择面板 人不会记住那么多不常用的快捷键，除非是编辑(D)
- [ ] 考虑加一个dotfiles管理器，意见切换（很不重要，懒得弄~）

> Search Light: Super+Space - macOS Spotlight-like search functionality
> Gradia: Super+PrintScreen - Advanced screenshot and annotation tool
> Smile: Ctrl+Alt+Space and Super+. - Emoji picker and special characters

- [ ] 区分home dotfiles 和 system dotfiles 会不会更好？ 参考：https://github.com/DaniD3v/nixOS-dotfiles

## Related projects

rayn4in
frost

https://gitlab.com/Zaney/zaneyos
