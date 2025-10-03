#
# ~/.bashrc



# If not running interactively, don't do anything
[[ $- != *i* ]] && return



alias ls='ls --color=auto'
alias ll='ls -alF --color=auto'
alias grep='grep --color=auto'
alias edit='vim'
PS1='[\u@\h \W]\$ '

export TERM=xterm-256color



# Буфер обмена для tty
#bind '"\e[2~": paste-from-gpm'
#paste-from-gpm(){
#	local text
#	text=$(gpm -s 2>/dev/null)
#	READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}$text${READLINE_LINE:$READLINE_POINT}"
#	READLINE_POINT=$((READLINE_POINT + ${#text}))
#}

