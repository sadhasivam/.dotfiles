# ~/.zsh-theme — FedEx Style Prompt

########################################
# Custom Identity
########################################
function nameplate() {
  echo -n "%F{93}சதாசிவம்\u200D🚚%f"  # FedEx Purple name
}

########################################
# Git Prompt Symbols (requires Powerline font for \uE0A0)
########################################
ZSH_THEME_GIT_PROMPT_PREFIX=" on %F{208}\uE0A0 "   # Orange repo icon
ZSH_THEME_GIT_PROMPT_SUFFIX="%f"
ZSH_THEME_GIT_PROMPT_DIRTY="%F{red}!"              # Red for dirty
ZSH_THEME_GIT_PROMPT_UNTRACKED="%F{green}?"        # Green for untracked
ZSH_THEME_GIT_PROMPT_CLEAN="%f"                    # Clean = no extra symbol

########################################
# Ruby Prompt (right-side)
########################################
ZSH_THEME_RUBY_PROMPT_PREFIX="%F{208}‹"            # Orange angle
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%f"

########################################
# Prompt Substitution
########################################
setopt prompt_subst

########################################
# PROMPT
########################################
PROMPT=$'
%F{93}$(nameplate)%f %F{white}%~%f $(git_prompt_info) \
⌚ %F{208}%*%f
$ '

RPROMPT='$(ruby_prompt_info)'
autoload -U add-zsh-hook
