# MADE BY DEFAULT OH-MY-ZSH THEMES!!1
#
# AF-MAGIC-------------------------------------------------------------------------------
# af-magic.zsh-theme
#
# Author: Andy Fleming
# URL: http://andyfleming.com/

# dashed separator size
function afmagic_dashes {
  # check either virtualenv or condaenv variables
  local python_env_dir="${VIRTUAL_ENV:-$CONDA_DEFAULT_ENV}"
  local python_env="${python_env_dir##*/}"

  # if there is a python virtual environment and it is displayed in
  # the prompt, account for it when returning the number of dashes
  if [[ -n "$python_env" && "$PS1" = *\(${python_env}\)* ]]; then
    echo $(( COLUMNS - ${#python_env} - 3 ))
  elif [[ -n "$VIRTUAL_ENV_PROMPT" && "$PS1" = *${VIRTUAL_ENV_PROMPT}* ]]; then
    echo $(( COLUMNS - ${#VIRTUAL_ENV_PROMPT} - 3 ))
  else
		echo $COLUMNS
	fi
}

check_status() {
    local last_status=$?
    if [ $last_status -eq 0 ]; then
        printf "✓ %-4s"
    else
			printf "$fg_bold[red]✘ %-4s$reset_color" "$last_status"
    fi
}
# primary prompt: dashed separator, directory and vcs info
PS1="${FG[237]}\${(l.\$(afmagic_dashes)..-.)}%{$reset_color%}
⌚ %{$fg_bold[red]%}%*%{$reset_color%} ${FG[050]}%~\$(git_prompt_info)\$(virtualenv_prompt_info)\$(hg_prompt_info) ${FG[105]}%(!.#.
%(?.%{$fg[green]%}✓ .%{$fg[red]%}✘ %?)	${FG[105]}»)%{$reset_color%}"
PS2="%{$fg[red]%}\ %{$reset_color%}"

#%(?.%{$fg[green]%}✓ .%{$fg[red]%}✘ %?)$

# right prompt: return code, virtualenv and context (user@host)

RPS1="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
if (( $+functions[virtualenv_prompt_info] )); then
  RPS1+='$(virtualenv_prompt_info)'
fi
RPS1+=" ${FG[237]}%n@%m%{$reset_color%}"

# git settings
ZSH_THEME_GIT_PROMPT_PREFIX=" ${FG[075]}(${FG[078]}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
ZSH_THEME_GIT_PROMPT_DIRTY="${FG[214]}*%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="${FG[075]})%{$reset_color%}"

# hg settings
ZSH_THEME_HG_PROMPT_PREFIX=" ${FG[075]}(${FG[078]}"
ZSH_THEME_HG_PROMPT_CLEAN=""
ZSH_THEME_HG_PROMPT_DIRTY="${FG[214]}*%{$reset_color%}"
ZSH_THEME_HG_PROMPT_SUFFIX="${FG[075]})%{$reset_color%}"

# virtualenv settings
ZSH_THEME_VIRTUALENV_PREFIX=" ${FG[075]}["
ZSH_THEME_VIRTUALENV_SUFFIX="]%{$reset_color%}"



# AMUSE ---------------------------------------------------------------------------------


# vim:ft=zsh ts=2 sw=2 sts=2

# Must use Powerline font, for \uE0A0 to render.
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}\uE0A0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

#ZSH_THEME_RUBY_PROMPT_PREFIX="%{$fg_bold[red]%}‹"
#ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"

#PROMPT='
#%{$fg_bold[green]%}%~%{$reset_color%}$(git_prompt_info)$(virtualenv_prompt_info) ⌚ %{$fg_bold[red]%}%*%{$reset_color%}
#$ '


VIRTUAL_ENV_DISABLE_PROMPT=0
ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX=" %{$fg[green]%}🐍 "
ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_VIRTUALENV_PREFIX=$ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX
ZSH_THEME_VIRTUALENV_SUFFIX=$ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX

