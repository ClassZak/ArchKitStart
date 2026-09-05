# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export QT_QPA_PLATFORM=wayland

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="robbyrussell"
#ZSH_THEME="3den"
#line 
#ZSH_THEME="af-magic"
#ZSH_THEME="amuse"

#bad
#ZSH_THEME="avit"
#exit code
#ZSH_THEME="rgm"
#ZSH_THEME="takashiyoshida"
ZSH_THEME="my_zsh_theme"
#ZSH_THEME="af-magic"


# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto	  # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git virtualenv zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# EXPORTS
# export MANPATH="/usr/local/man:$MANPATH"
#export MESA_LOADER_DRIVER_OVERRIDE=nouveau
export GALLIUM_DRIVER=llvmpipe
export WLR_RENDERER=gles2
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORM=wayland
export QT_WAYLAND_DISABLE_WINDOWDECORATION=1
export __GLX_VENDOR_LIBRARY_NAME=nvidia
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_STYLE_OVERRIDE=kvantum
#exec export GBM_BACKEND=nvidia-drm
export WLR_NO_HARDWARE_CURSORS=1
export TERMINAL=foot
#export XDG_CURRENT_DESKTOP=sway
export GTK_THEME=Adwaita:dark
export EDITOR=vim

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='nvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch $(uname -m)"

# Set personal aliases, overriding those provided by Oh My Zsh libs,
# plugins, and themes. Aliases can be placed here, though Oh My Zsh
# users are encouraged to define aliases within a top-level file in
# the $ZSH_CUSTOM folder, with .zsh extension. Examples:
# - $ZSH_CUSTOM/aliases.zsh
# - $ZSH_CUSTOM/macos.zsh
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"
#
# ALIASES
alias vim-safe='MESA_LOADER_DRIVER_OVERRIDE=nouveau vim -u NONE -U NONE +"set noswapfile"'
alias ls='ls --color=auto'
alias ll='ls --color=auto -alF'
alias llh='ls --color=auto -alFh'
alias grep='grep --color=auto'
alias telegram='exec $HOME/Downloads/Telegram/Telegram &'
alias amnezia='LD_LIBRARY_PATH=/opt/AmneziaVPN/client/lib QT_QPA_PLATFORM=xcb /opt/AmneziaVPN/client/bin/AmneziaVPN'

# alias intelij='LIBGL_ALWAYS_SOFTWARE=true LIBGL_KOPPER_DISABLE=true MESA_LOADER_DRIVER_OVERRIDE=nouveau _JAVA_OPTIONS="-Dsun.java2d.opengl=false" $HOME/Downloads/downloaded_programs/jetbrains/idea-IC-252.26830.84/bin/idea'
alias intelij='LIBGL_ALWAYS_SOFTWARE=true LIBGL_KOPPER_DISABLE=true MESA_LOADER_DRIVER_OVERRIDE=nouveau idea'
alias sway_cfg='vim $HOME/.config/sway/config'
alias hypr_cfg='vim $HOME/.config/hypr/hyprland.conf'
alias sway_start='$HOME/.local/bin/sway-start.sh'
alias hypr_start='$HOME/.local/bin/hypr-start.sh'
# alias chromium='chromium --disable-gpu --disable-software-rasterizer --password-store=basic'
# alias chromium='MESA_LOADER_DRIVER_OVERRIDE=nouveau chromium --disable-gpu --disable-software-rasterizer --password-store=basic'
alias chromium_launch='MESA_LOADER_DRIVER_OVERRIDE=nouveau chromium --disable-gpu --disable-software-rasterizer --password-store=basic --disable-features=Vulkan --ozone-platform=wayland --ozone-platform-hint=wayland'
alias firefox='MESA_LOADER_DRIVER_OVERRIDE=nouveau firefox'
# alias mysqlworkbench='MYSQL_WORKBENCH_NO_KEYRING=1 mysql-workbench'
alias mysqlworkbench='MYSQL_WORKBENCH_NO_KEYRING=1 mysql-workbench LIBGL_ALWAYS_SOFTWARE=true LIBGL_KOPPER_DISABLE=true MESA_LOADER_DRIVER_OVERRIDE=nouveau '
alias prismlauncher='export GDK_BACKEND=wayland,x11 ; export QT_QPA_PLATFORM=wayland ;prismlauncher'
alias duls='du -a --block-size=MiB --max-depth=1 | sort -n'
alias shutdown='sudo pkill -15 chrome ; sudo pkill -15 chromium ; shutdown'
alias reboot='sudo pkill -15 chrome ; sudo pkill -15 chromium ; reboot'
alias kill_chrome='sudo pkill -15 chrome ; sudo pkill -15 chromium'
# Load Angular CLI autocompletion.
#source <(ng completion script)
