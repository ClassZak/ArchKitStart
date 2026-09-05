#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls --color=auto -alF'
alias llh='ls --color=auto -alFh'
alias grep='grep --color=auto'
alias telegram='exec $HOME/Downloads/Telegram/Telegram &'
# alias intelij='MESA_LOADER_DRIVER_OVERRIDE=nouveau $HOME/Downloads/downloaded_programs/jetbrains/idea-IC-252.26830.84/bin/idea'
alias intelij='LIBGL_ALWAYS_SOFTWARE=true LIBGL_KOPPER_DISABLE=true MESA_LOADER_DRIVER_OVERRIDE=nouveau idea'
alias sway_cfg='edit $HOME/.config/sway/config'
alias sway_start='sway 2>sway_err.log'
# alias chromium='chromium --disable-gpu --disable-software-rasterizer --password-store=basic'
# alias chromium='MESA_LOADER_DRIVER_OVERRIDE=nouveau chromium --disable-gpu --disable-software-rasterizer --password-store=basic'
alias chromium='MESA_LOADER_DRIVER_OVERRIDE=nouveau chromium --disable-gpu --disable-software-rasterizer --password-store=basic --disable-features=Vulkan'
alias firefox='MESA_LOADER_DRIVER_OVERRIDE=nouveau firefox'
alias mysqlworkbench='MYSQL_WORKBENCH_NO_KEYRING=1 mysql-workbench'
alias prismlauncher='export GDK_BACKEND=wayland,x11 ; export QT_QPA_PLATFORM=wayland;prismlauncher'
alias duls='du -a --block-size=MiB --max-depth=1 | sort -n'
alias shutdown='sudo pkill -15 chrome ; sudo pkill -15 chromium ; shutdown'
alias reboot='sudo pkill -15 chrome ; sudo pkill -15 chromium ; reboot'
alias kill_chrome='sudo pkill -15 chrome ; sudo pkill -15 chromium'

#export MESA_LOADER_DRIVER_OVERRIDE=nouveau
export GALLIUM_DRIVER=llvmpipe
export WLR_RENDERER=gles2
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_STYLE_OVERRIDE=kvantum
export EDITOR=vim

export WLR_NO_HARDWARE_CURSORS=1
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


