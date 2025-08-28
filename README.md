this is my nixos config


`home-manager switch --flake .#dashu@laptop-rog-gu603`

`cd /home/dashu/nixos-config && sudo nixos-rebuild switch --flake .#laptop`

`cd /home/dashu/nixos-config && sudo nixos-rebuild switch --flake .#vm`

> ! hyprland 相关配置即将从本仓库剥离
> 日后会采用git clone命令方式自动配置
> 

## TODO

impoertant degree:A B C D

- [ ] 目前只能使用`super+[num]` 切换工作区，需要其他的shortcuts (A)

- [ ] 目前`super+tab`的逻辑不够好，当目前工作区有两个以上的窗口时，此组合键可以切换这些应用窗口，但是当此工作区只有一个窗口时，不起效果，解决方案：添加一个判断条件：如果当前只有一个窗口时，需要切换到刚刚访问或者相邻的工作区 建议使用bash脚本实现  (B)

- [ ] 引入`nixvim`(lazyvim简易配置即可) (B)

- [ ] 目前剪切板（能够查看历史记录）还没有完善 (B)

- [x] 输入法：切换输入法语言时，无需保留当前的第一个候选词，需要在`oh-my-rime`的配置中修改 (A) (在fcitx5-configuretool 里面修改即可)

- [ ] 输入法：需要匹配窗口设置不同的输入策略，比如vscode强制半角符号，进入先切换为英文 (D)

- [ ] 可以完善输入法的输入特殊字符(如制表符、运算符、圈圈文字等等)和**emoji**的能力：建议像windows11一样，使用`super+v`快捷键调出选择面板 人不会记住那么多不常用的快捷键，除非是编辑(D)

- [ ] `waybar`改进建议：限制标题栏显示长度 (D)

- [ ] `waybar`改进建议：可以添加一些按钮，切换waybar、rofi、wallpaper主题样式 (DDD)

- [ ] ui-fix: 添加ags  astal 组件（可不可以引入amll呀~~~）
- [ ] UI-fix: 可不可以修改一下waybar左上角的窗口选择器呀，稍稍改进以下啦~~~，或者提供alterntive方案
- [ ] UI-fix: waybar 右边程序后台托盘 颜色切换一下？ 电源按钮样式更改一下
- [ ] 考虑加一个dotfiles管理器，意见切换（很不重要，懒得弄~）
- [ ] UI-fix: 在nix配置中添加qt主题的配置，kate很丑


>    Search Light: Super+Space - macOS Spotlight-like search functionality
>    Gradia: Super+PrintScreen - Advanced screenshot and annotation tool
>    Smile: Ctrl+Alt+Space and Super+. - Emoji picker and special characters

- [ ] 区分home dotfiles 和 system dotfiles 会不会更好？ 参考：https://github.com/DaniD3v/nixOS-dotfiles

## Related projects
rayn4in
frost
archcraft
 
