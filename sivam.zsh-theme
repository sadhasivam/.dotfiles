# ~/.zsh-theme — Tech Stack Prompt

########################################
# Custom Identity
########################################
function nameplate() {
  echo -n "%F{93}சதாசிவம்\u200D🚚%f"  # FedEx Purple name - strongest custom identity
}

########################################
# Git Status (Enhanced with Nerd Fonts)
########################################
function git_prompt_enhanced() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    local git_status=""

    # Dirty/clean indicator
    if [[ -n $(git status --porcelain 2>/dev/null) ]]; then
      git_status+="%F{red}●%f"
    else
      git_status+="%F{green}✓%f"
    fi

    # Ahead/behind counts
    local ahead=$(git rev-list @{u}..HEAD 2>/dev/null | wc -l | tr -d ' ')
    local behind=$(git rev-list HEAD..@{u} 2>/dev/null | wc -l | tr -d ' ')
    [[ $ahead -gt 0 ]] && git_status+=" %F{cyan}↑$ahead%f"
    [[ $behind -gt 0 ]] && git_status+=" %F{magenta}↓$behind%f"

    echo " on %F{208} $branch%f $git_status"
  fi
}

########################################
# Runtime Versions (contextual, Nerd Font glyphs)
########################################
function runtime_versions() {
  local versions=""

  # Node (if .node-version or package.json exists)
  if [[ -f .node-version ]] || [[ -f package.json ]]; then
    local node_ver=$(node -v 2>/dev/null | sed 's/v//')
    [[ -n "$node_ver" ]] && versions+="%F{green} $node_ver%f │ "
  fi

  # Python (if .python-version or requirements.txt exists)
  if [[ -f .python-version ]] || [[ -f requirements.txt ]] || [[ -f pyproject.toml ]]; then
    local python_ver=$(python --version 2>/dev/null | cut -d' ' -f2)
    [[ -n "$python_ver" ]] && versions+="%F{blue} $python_ver%f │ "
  fi

  echo -n "$versions"
}

########################################
# AWS Context (profile + region)
########################################
function aws_context() {
  local aws_info=""

  if [[ -n "$AWS_PROFILE" ]]; then
    aws_info+="%F{208} $AWS_PROFILE%f"

    # Add region if set
    if [[ -n "$AWS_REGION" ]]; then
      aws_info+="%F{208}:$AWS_REGION%f"
    elif [[ -n "$AWS_DEFAULT_REGION" ]]; then
      aws_info+="%F{208}:$AWS_DEFAULT_REGION%f"
    fi

    aws_info+=" │ "
  fi

  echo -n "$aws_info"
}

########################################
# Kubernetes Context (context + namespace)
########################################
function k8s_context() {
  local k8s_info=""

  if command -v kubectl &>/dev/null; then
    local ctx=$(kubectl config current-context 2>/dev/null)

    if [[ -n "$ctx" ]]; then
      # Skip local development contexts
      if [[ ! "$ctx" =~ ^(orbstack|docker-desktop|minikube|kind-.*)$ ]]; then
        # Shorten common patterns (e.g., arn:aws:eks:... -> eks:cluster-name)
        ctx=$(echo "$ctx" | sed 's/.*\///' | cut -c1-20)

        # Get namespace
        local ns=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
        [[ -z "$ns" ]] && ns="default"

        k8s_info+="%F{blue}☸ $ctx%f%F{cyan}:$ns%f │ "
      fi
    fi
  fi

  echo -n "$k8s_info"
}

########################################
# Exit Code Indicator
########################################
function exit_code() {
  echo "%(?.%F{green}.%F{red} %?)%f"
}

########################################
# Command Duration (for long-running commands)
########################################
function preexec() {
  cmd_start_time=$SECONDS
}

function precmd() {
  if [ $cmd_start_time ]; then
    local elapsed=$((SECONDS - cmd_start_time))

    # Show duration if > 3 seconds
    if [[ $elapsed -gt 3 ]]; then
      local duration=""
      if [[ $elapsed -ge 60 ]]; then
        local mins=$((elapsed / 60))
        local secs=$((elapsed % 60))
        duration="${mins}m${secs}s"
      else
        duration="${elapsed}s"
      fi
      export CMD_DURATION="%F{yellow} $duration%f │ "
    else
      export CMD_DURATION=""
    fi

    unset cmd_start_time
  fi
}

########################################
# Prompt Substitution
########################################
setopt prompt_subst

########################################
# PROMPT (Two-line layout)
########################################
PROMPT=$'
%F{93}$(nameplate)%f %F{white}%~%f$(git_prompt_enhanced)
$(exit_code) $ '

########################################
# RPROMPT (Right side: segmented tech stack context)
########################################
RPROMPT='$(runtime_versions)$(aws_context)$(k8s_context)${CMD_DURATION}%F{208} %@%f'

########################################
# Hook Setup
########################################
autoload -U add-zsh-hook
add-zsh-hook preexec preexec
add-zsh-hook precmd precmd
