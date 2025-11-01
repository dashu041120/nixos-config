{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # GUI apps
    # e-book viewer(.epub/.mobi/...)
    # do not support .pdf

    # instant messaging
    # telegram-desktop
    # discord # update too frequently, use the web version instead

    # remote desktop(rdp connect)
    remmina
    freerdp # required by remmina

    # my custom hardened packages
    qqmusic
    qq
    # wechat-uos   
    # wechat
    spotify
  ];
}
