function toon {
  echo -n "சதாசிவம் 🍀 "
}

# Must use Powerline font, for \uE0A0 to render.
ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[magenta]%}\uE0A0 "
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}!"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[green]%}?"
ZSH_THEME_GIT_PROMPT_CLEAN=""

ZSH_THEME_RUBY_PROMPT_PREFIX="%{$fg_bold[red]%}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"

setopt prompt_subst
PROMPT='
%{$fg_bold[magenta]%}$(toon)%{$reset_color%}%~/ %{$reset_color%}${vcs_info_msg_0_}%{$reset_color%}$(git_prompt_info) ⌚ %{$fg_bold[red]%}%*%{$reset_color%}
$ '

RPROMPT='$(ruby_prompt_info)'



# PROMPT='%{$fg[magenta]%}$(toon)%{$reset_color%} %~/ %{$reset_color%}${vcs_info_msg_0_}%{$reset_color%}'

autoload -U add-zsh-hook
