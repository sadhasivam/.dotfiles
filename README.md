# .dotfiles

Personalized dotfiles setup for macOS, optimized for full-stack development with cloud infrastructure, multiple programming languages, and containerized environments.

## Features

- **Modern shell setup** with Zsh, Oh My Zsh, and custom theme
- **Polyglot development** environment (Python, Node.js, Java, Go, Rust, etc.)
- **Cloud-native tooling** (AWS, Azure, Kubernetes, Terraform)
- **Infrastructure as Code** with comprehensive security scanning
- **Version management** via mise (unified runtime manager)
- **Modern package management** (Homebrew, pnpm via corepack)
- **Security-first** with GPG, git-crypt, and credential management

---

## Quick Start

```bash
# Clone the repository
git clone git@github.com:YOUR_USERNAME/.dotfiles.git ~/.dotfiles

# Run the bootstrap script
cd ~/.dotfiles
./dotstrap.sh
```

---

## Prerequisites

### Required

- **macOS** 12.0 (Monterey) or later
- **Xcode Command Line Tools**
  ```bash
  xcode-select --install
  ```
- **Git** (install via Xcode CLI tools or Homebrew)
- **SSH key configured** for GitHub
  ```bash
  # Generate new SSH key if needed
  ssh-keygen -t ed25519 -C "your_email@fedex.com"

  # Add to GitHub: https://github.com/settings/keys
  cat ~/.ssh/id_ed25519.pub | pbcopy
  ```

### Optional (Installed by Bootstrap)

- Homebrew (installed automatically if missing)
- Oh My Zsh (installed automatically if missing)

---

## Installation

### 1. Clone Repository

```bash
git clone git@github.com:YOUR_USERNAME/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### 2. Run Bootstrap Script

```bash
./dotstrap.sh
```

This will:
1. ✅ Verify macOS compatibility
2. ✅ Install Oh My Zsh (if not present)
3. ✅ Install/update Homebrew
4. ✅ Install packages from Brewfile
5. ✅ Bootstrap runtime versions via mise
6. ✅ Symlink configuration files to `~/`
7. ✅ Set up VS Code settings (if installed)
8. ✅ Clean up and verify installation

### 3. Reload Shell

```bash
exec zsh -l
# Or open a new terminal window
```

---

## What Gets Installed

### Package Managers & Version Control

- **Homebrew** - macOS package manager
- **mise** - Polyglot runtime version manager
- **corepack** - Node.js package manager manager (pnpm, yarn)

### Development Tools

- **Languages**: Python 3.14, Node.js 24, Java 25, Go, Rust, Maven, Gradle
- **Shells**: Zsh with syntax highlighting, Bash (latest)
- **Editors**: Vim configuration
- **Version Control**: Git with modern config, Subversion, lazygit (Git TUI)
- **Python Tools**: ruff (fast linter/formatter), pipx (isolated CLI tools)

### Modern CLI Tools

- **Better replacements**: eza (ls), bat (cat), ripgrep (grep), fd (find), btop (htop)
- **Productivity**: fzf (fuzzy finder), zoxide (smart cd), direnv (auto env)
- **Git**: delta (beautiful diffs), lazygit (TUI)
- **Network**: httpie (modern HTTP client)
- **Rendering**: glow (markdown viewer)

### Cloud & Infrastructure

- **Cloud CLIs**: AWS CLI, Azure CLI
- **Containers**: OrbStack (Docker Desktop alternative), lazydocker (Docker TUI)
- **Kubernetes**: kubectl, kubectx, kubens, k9s (K8s TUI), stern (log tailing), helm, kustomize
- **Terraform Stack**: tfenv, tfsec, checkov, tflint, infracost, terrascan, terraform-docs

### Security & Encryption

- GPG/GnuPG
- git-crypt
- pass (password manager)
- mkcert (local TLS certificates)

### Utilities

- **Core Utils**: coreutils, grep, tree, htop, nmap, wget
- **Network**: mitmproxy, wifi-password
- **Data**: jq, duckdb, sqlite
- **Media**: ffmpeg
- **Server**: caddy (HTTP server with auto-HTTPS)
- **AI**: Claude Code CLI

### Fonts

- **JetBrains Mono** - Primary coding font (with ligatures)
- **Fira Code** - Alternative coding font (with ligatures)
- **Monaspace** - GitHub's modern font family
- **Hack** - Fallback monospace font

---

## Directory Structure

```
~/.dotfiles/
├── dotstrap.sh              # Main bootstrap script
├── sivam.zsh-theme          # Custom Zsh theme
├── .aliases                 # Common shell aliases
├── .aliases.work            # Work-specific aliases (gitignored)
│
├── install/                 # Installation scripts
│   ├── macos.sh             # macOS bootstrap automation
│   ├── bootstrap-mise.sh    # Runtime version setup via mise
│   └── Brewfile             # Homebrew package definitions
│
├── symlink/                 # Config files to be symlinked
│   ├── zshrc                # Zsh configuration
│   ├── gitconfig            # Git configuration
│   ├── gitignore_global     # Global git ignore patterns
│   ├── npmrc                # NPM configuration
│   ├── curlrc               # Curl defaults
│   ├── editorconfig         # Editor settings
│   ├── vimrc                # Vim configuration
│   └── mise.toml            # mise runtime version configuration
│
├── fn/                      # Custom shell functions
│   ├── functions            # General utilities
│   ├── agam                 # Personal functions
│   └── cloud                # Cloud provider helpers
│
└── ide/                     # IDE configurations
    └── vscode/
        └── settings.json    # VS Code user settings
```

---

## Configuration Files

After installation, these files are symlinked to your home directory:

- `~/.zshrc` → `~/.dotfiles/symlink/zshrc`
- `~/.gitconfig` → `~/.dotfiles/symlink/gitconfig`
- `~/.gitignore_global` → `~/.dotfiles/symlink/gitignore_global`
- `~/.npmrc` → `~/.dotfiles/symlink/npmrc`
- `~/.curlrc` → `~/.dotfiles/symlink/curlrc`
- `~/.editorconfig` → `~/.dotfiles/symlink/editorconfig`
- `~/.vimrc` → `~/.dotfiles/symlink/vimrc`
- `~/.config/mise/config.toml` → `~/.dotfiles/symlink/mise.toml`

---

## Updating

To update your dotfiles and installed packages:

```bash
# Update dotfiles repository
cd ~/.dotfiles
git pull origin main

# Re-run bootstrap to apply changes
./dotstrap.sh

# Update packages
brew update && brew upgrade && brew cleanup
mise upgrade
```

Or use the `update` alias (updates Homebrew and mise):
```bash
update
```

---

## Key Aliases

### Navigation
- `dotfiles` - cd to ~/.dotfiles
- `library` - cd to ~/Library
- `sites` - cd to ~/Sites

### Development
- `nstrap` - Fresh npm install (removes node_modules and lock file)
- `watch` - Run npm watch script
- `ws` - Start Python 3 HTTP server on port 1234

### Modern CLI Tools
- `ls` / `la` - eza with icons and git status (auto-enabled if eza installed)
- `lt` - Tree view with icons (2 levels deep)
- `cat` - bat with syntax highlighting (auto-enabled if bat installed)
- `cd` / `z` - zoxide smart directory jumping (auto-enabled if zoxide installed)

### Git
- `gst` - git status
- Git log aliases: `lol`, `lola` (pretty graph views)

### AWS Profiles
- `pro` - Production (ReadOnly)
- `ppd` - Pre-production (Developer)
- `sd` - Sandbox (Developer)
- `legd` - Legacy Development
- `dro` - Databricks (ReadOnly)

### Kubernetes
- `k` - kubectl
- `kx` - kubectx (switch contexts)
- `kns` - kubens (switch namespaces)
- `mk` - minikube

### Utilities
- `c` - clear
- `localip` - Show local IP address
- `week` - Get current week number
- `path` - Print PATH entries (one per line)
- `cleanup` - Delete .DS_Store files recursively
- `emptytrash` - Empty all trash and clear logs
- `reloadshell` - Reload shell configuration
- `reloaddns` - Flush DNS cache
- `shrug` - Copy ¯\_(ツ)_/¯ to clipboard

### Time Zones
- `inr` - Show time in India (Asia/Calcutta)
- `nyc` - Show time in New York
- `utc` - Show UTC time

### Docker
- `drm` - Remove all Docker containers

### NPM Registry
- `npm-sr` - Switch to internal artifactory
- `npm-default` - Switch to public npm registry

### Azure
- `azal` - List Azure accounts with tenant IDs

---

## Key Functions

### Development
- `whoseport <port>` - Find process using a specific port
- `code` - Open VS Code from command line
- `docker-clean` - Remove dangling Docker images
- `gitd <branch>` - Delete local and remote git branch
- `venv` - Set up Python virtual environment with PYTHONPATH
- `trex` - Enhanced tree command with colors and pager

### Cloud
- `dokeymd5` - Get Digital Ocean SSH key MD5 fingerprint
- `dotf` - Terraform wrapper for Digital Ocean
- `dlecr` - Docker login to AWS ECR

### Personal
- `me` - Load personal rc file (.sadhasivamrc)
- `them` - Load standard zshrc
- `ww` - Set up Terraform/AWS profile for environment

---

## Runtime Versions

| Tool       | Version  | Configuration Location |
|------------|----------|------------------------|
| Python     | 3.14.3   | `symlink/mise.toml` |
| Node.js    | 24.13.1  | `symlink/mise.toml` |
| pnpm       | latest   | `symlink/mise.toml` |
| yarn       | latest   | `symlink/mise.toml` |
| Java       | 25       | `symlink/mise.toml` |
| Maven      | 3.9.12   | `symlink/mise.toml` |
| Gradle     | 9.3.1    | `symlink/mise.toml` |
| Go         | Latest   | Homebrew (via Brewfile) |
| Rust       | Latest   | Homebrew (via Brewfile) |

**Note:** All development tools are managed by **mise** via `~/.config/mise/config.toml` (symlinked from `symlink/mise.toml`). Go and Rust use Homebrew since they're already installed system-wide.

### How mise Works

**Declarative Configuration:**
- Tool versions are defined in `symlink/mise.toml`
- Symlinked to `~/.config/mise/config.toml` during bootstrap
- mise **auto-installs** missing versions when you start a new shell
- No manual `mise install` needed - it's automatic!

**Activation:**
- Your `~/.zshrc` includes `eval "$(mise activate zsh)"`
- This reads the config and adds tools to your PATH
- Works across all terminal sessions automatically

**Changing Versions:**

**For global defaults** (edit `symlink/mise.toml`):
```toml
[tools]
python = "3.13.1"  # Change version here
node = "22.0.0"
```

**For specific projects** (create project-local config):
```bash
# In your project directory
mise use python@3.12  # Creates .mise.toml
mise use node@20      # Overrides global version for this project
```

**Installing additional versions:**
```bash
# Install and switch globally
mise use -g python@3.12

# Install without switching
mise install python@3.11
```

**Per-project overrides** (create project-local `.mise.toml`):
```bash
# In your project directory
mise use pnpm@9.15.0   # Project-specific version
mise use node@20.0.0   # Different Node version for this project
```

Or use `package.json` for package managers (corepack respects this):
```json
{
  "packageManager": "pnpm@9.15.0"
}
```

---

## Troubleshooting

### "command not found: brew"

Homebrew may not be in PATH. Add to your shell config:
```bash
# For Apple Silicon (M1/M2/M3)
eval "$(/opt/homebrew/bin/brew shellenv)"

# For Intel Macs
eval "$(/usr/local/bin/brew shellenv)"
```

### "mise: command not found"

Ensure mise activation is in your zshrc:
```bash
eval "$(mise activate zsh)"
```

### Oh My Zsh theme not loading

Verify `ZSH_CUSTOM` points to dotfiles:
```bash
echo $ZSH_CUSTOM  # Should show /Users/yourname/.dotfiles
ls -la ~/.dotfiles/sivam.zsh-theme
```

### Git config not applied

Re-symlink git configuration:
```bash
ln -sf ~/.dotfiles/symlink/gitconfig ~/.gitconfig
```

### Homebrew packages not installing

Update Homebrew and retry:
```bash
brew update
brew doctor  # Check for issues
cd ~/.dotfiles && brew bundle --file=install/Brewfile
```

### VS Code settings not syncing

If VS Code is installed, manually copy settings:
```bash
cp ~/.dotfiles/ide/vscode/settings.json ~/Library/Application\ Support/Code/User/settings.json
```

### Permission denied errors

Ensure scripts are executable:
```bash
chmod +x ~/.dotfiles/dotstrap.sh
chmod +x ~/.dotfiles/install/macos.sh
```

### Shell startup is slow

Profile your zsh startup time:
```bash
time zsh -i -c exit
```

Common causes:
- Too many Oh My Zsh plugins (keep it under 10)
- Slow network calls in shell config
- Large history file

### Fonts tap error

If you see errors about `homebrew/fonts` or `homebrew/cask-fonts` taps:

```
Error: homebrew/fonts tap not found
```

**Solution**: Fonts are now in Homebrew core - no tap needed! Remove any `tap` lines from your Brewfile. Font casks work directly:

```ruby
# ✅ Correct - no tap needed
cask 'font-jetbrains-mono'
cask 'font-fira-code'
```

---

## Customization

### Work-Specific Configuration

Create `.aliases.work` (gitignored) for environment-specific settings:

```bash
# ~/.dotfiles/.aliases.work
export CUSTOM_VAR="value"
alias work-alias="command"
```

This file is automatically sourced if it exists.

### Adding New Packages

1. Add to `install/Brewfile`:
   ```ruby
   brew 'package-name'
   # or
   cask 'app-name'
   ```

2. Install:
   ```bash
   brew bundle --file=~/.dotfiles/install/Brewfile
   ```

### Custom Aliases

Add to `.aliases` and reload:
```bash
echo "alias myalias='command'" >> ~/.dotfiles/.aliases
source ~/.zshrc
```

---

## macOS System Settings

The bootstrap script configures sensible defaults. To customize further, see `install/macos.sh`.

---

## Security Notes

- **Never commit** `.aliases.work` (contains sensitive credentials)
- **SSH keys** should be kept secure and backed up separately
- **GPG keys** should be backed up to secure offline storage
- **AWS credentials** are managed via profiles, not hardcoded
- **Secrets** should use `git-crypt` or `pass` for encryption

---

## Credits

- Zsh theme inspired by [@subnixr's minimal theme](https://github.com/subnixr/minimal)
- Dotfiles structure inspired by [@driesvints](https://github.com/driesvints)
- Built with ❤️ for the FedEx development team

---

## License

This is personal configuration. Feel free to fork and adapt to your needs.

---

## Support

For issues or questions:
- Check the [Troubleshooting](#troubleshooting) section
- Review recent commits: `git log --oneline`
- Verify file permissions: `ls -la ~/.dotfiles`

**Last Updated**: February 2026
