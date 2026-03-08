#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls --color=auto -alF'
alias llh='ls --color=auto -alFh'
alias grep='grep --color=auto'
alias telegram='exec /home/zak/Downloads/Telegram/Telegram &'
# alias intelij='MESA_LOADER_DRIVER_OVERRIDE=nouveau /home/zak/Downloads/downloaded_programs/jetbrains/idea-IC-252.26830.84/bin/idea'
alias intelij='MESA_LOADER_DRIVER_OVERRIDE=nouveau _JAVA_OPTIONS="-Dsun.java2d.opengl=false" /home/zak/Downloads/downloaded_programs/jetbrains/idea-IC-252.26830.84/bin/idea'
alias sway_cfg='edit /home/zak/.config/sway/config'
alias sway_start='sway 2>sway_err.log'
# alias chromium='chromium --disable-gpu --disable-software-rasterizer --password-store=basic'
# alias chromium='MESA_LOADER_DRIVER_OVERRIDE=nouveau chromium --disable-gpu --disable-software-rasterizer --password-store=basic'
alias chromium='MESA_LOADER_DRIVER_OVERRIDE=nouveau chromium --disable-gpu --disable-software-rasterizer --password-store=basic --disable-features=Vulkan'
alias firefox='MESA_LOADER_DRIVER_OVERRIDE=nouveau firefox'
alias mysqlworkbench='MYSQL_WORKBENCH_NO_KEYRING=1 mysql-workbench'
alias prismlauncher='export GDK_BACKEND=wayland,x11 ; export QT_QPA_PLATFORM=wayland;prismlauncher'

#export MESA_LOADER_DRIVER_OVERRIDE=nouveau
export GALLIUM_DRIVER=llvmpipe
export WLR_RENDERER=gles2
export QT_QPA_PLATFORM=wayland

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
