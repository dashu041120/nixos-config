this is my nixos config


`home-manager switch --flake .#dashu@laptop-rog-gu603`

`cd /home/dashu/nixos-config && sudo nixos-rebuild switch --flake .#laptop`

`cd /home/dashu/nixos-config && sudo nixos-rebuild switch --flake .#vm`


## TODO

degree:A B C D

- [ ] 目前只能使用`super+[num]` 切换工作区，需要其他的shortcuts (A)

- [ ] 目前`super+tab`的逻辑不够好，当目前工作区有两个以上的窗口时，此组合键可以切换这些应用窗口，但是当此工作区只有一个窗口时，不起效果，解决方案：添加一个判断条件：如果当前只有一个窗口时，需要切换到刚刚访问或者相邻的工作区 建议使用bash脚本实现  (B)

- [ ] 引入`nixvim`(lazyvim简易配置即可) (B)

- [ ] 目前剪切板（能够查看历史记录）还没有完善 (B)

- [ ] 输入法：切换输入法语言时，无需保留当前的第一个候选词，需要在`oh-my-rime`的配置中修改 (A)

- [ ] 输入法：需要匹配窗口设置不同的输入策略，比如vscode强制半角符号，进入先切换为英文 (D)

- [ ] 可以完善输入法的输入特殊字符和**emoji**的能力：建议像windows11一样，使用`super+v`快捷键调出选择面板 (D)

- [ ] `waybar`改进建议：限制标题栏显示长度 (D)

- [ ] `waybar`改进建议：可以添加一些按钮，切换waybar、rofi、wallpaper主题样式 (DDD)



## Related projects
rayn4in
frost
archcraft
 
