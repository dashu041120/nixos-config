{ config, pkgs, ... }:

{
  # 为 ghostty 创建优化的启动别名
  home.shellAliases = {
    ghostty-perf = "~/nixos-config/modules/home/hyprland/configs/scripts/ghostty-optimized.sh";
    gpu-check = "lspci | grep -E '(VGA|3D)'";
    nvidia-check = "nvidia-smi";
    gpu-info = "glxinfo | grep -i 'opengl renderer'";
  };
  
  # 添加一些有用的函数
  programs.zsh.initExtra = ''
    # 检查当前应用使用的 GPU
    check_gpu_usage() {
      echo "=== GPU 使用情况 ==="
      nvidia-smi --query-gpu=utilization.gpu,utilization.memory,temperature.gpu --format=csv,noheader,nounits
      echo "=== 当前进程 GPU 使用 ==="
      nvidia-smi pmon -c 1
    }
    
    # 使用 NVIDIA GPU 强制启动应用
    nvidia_launch() {
      __GLX_VENDOR_LIBRARY_NAME=nvidia __GL_SHADER_DISK_CACHE=1 GBM_BACKEND=nvidia-drm "$@"
    }
    
    # 使用集成显卡启动应用
    intel_launch() {
      DRI_PRIME=0 "$@"
    }
  '';
}
