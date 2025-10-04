# AMUSE-MAGIC THEME ----------------------------------------------------------------------------------
# vim:ft=zsh ts=2 sw=2 sts=2

autoload -U colors && colors

# Цвета в стиле af-magic
FG=()
for color in {000..255}; do
    FG[$color]="%{color}m%}"
done

# Git настройки (из Amuse)
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}\uE0A0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%}"

# Виртуальное окружение (из Amuse)
VIRTUAL_ENV_DISABLE_PROMPT=0
ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX=" %{$fg[green]%}🐍 "
ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="%{$reset_color%}"

# Функция для разделителя (из af-magic)
function afmagic_dashes {
    local python_env_dir="${VIRTUAL_ENV:-$CONDA_DEFAULT_ENV}"
    local python_env="${python_env_dir##*/}"

    if [[ -n "$python_env" && "$PS1" = *\(${python_env}\)* ]]; then
        echo $(( COLUMNS - ${#python_env} - 3 ))
    elif [[ -n "$VIRTUAL_ENV_PROMPT" && "$PS1" = *${VIRTUAL_ENV_PROMPT}* ]]; then
        echo $(( COLUMNS - ${#VIRTUAL_ENV_PROMPT} - 3 ))
    else
        echo $COLUMNS
    fi
}

# Основной промпт (объединение Amuse и af-magic)
setopt PROMPT_SUBST
PROMPT='
${FG[237]}${(l.$(afmagic_dashes)..-.)}%{$reset_color%}
%{$fg_bold[green]%}%~%{$reset_color%}$(git_prompt_info)$(virtualenv_prompt_info) ⌚ %{$fg_bold[red]%}%*%{$reset_color%}
%(?.%{$fg[green]%}✓ .%{$fg[red]%}✘ %?)${FG[105]}%(!.#.»)%{$reset_color%} '

# Правый промпт (из af-magic)
RPS1="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
if (( $+functions[virtualenv_prompt_info] )); then
    RPS1+='$(virtualenv_prompt_info)'
fi
RPS1+=" ${FG[237]}%n@%m%{$reset_color%}"

# Вторичный промпт (из af-magic)
PS2="%{$fg[red]%}\ %{$reset_color%}"

# Настройки LS (из Amuse)
export LS_COLORS="di=38;2;255;255;255;48;2;44;62;80:"
