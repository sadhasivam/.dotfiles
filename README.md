# The (.) DOTSTRAP  
collaborated dotfiles dogma & setup

## .setup 
Personalized dotflies setup tested only in macOS Monterey

### prerequisite 

- configure git ssh 
- install git 
- clone dotfiles repo

### macos setup 

- Run ./dostraph.sh  # bootstraps dot file

## .manual

### $R - Aliases 

- ppd = PreProd development AWS environment login
- pro = Production ReadOnly AWS environment login
- leg = Legacy AWS environemnt
- legd = Legacy-DEV AWS environemnt

### Aliases 

- localip = returns local ipaddress of the machine
- cleanup = deletes .DS_Store files recursively
- reloadshell = reload current shell with redefined SHELL values
- week = get week number
- path = echos verbose $PATH value
- npm-sr = sets SR artifactory 
- npm-default = sets npmregistry 
- localip = local ipaddress
- ws3 = server python 3.7 in port 1234
- ws  = server python 2.7 in port 1234 

### Functions 

- awscreds = write all AWS environment credentials
- dhelp = cat this file
- whoseport = find out program using the port
- gitd = deletes local and remote git repository
- docker-clean = clean docker images
- code = open visual code
- digga = dig with more useful information
- venv  = sets up python virtual environment ( .venv/bin/activiate) & configures PythonPATH to current working directory

### Credits

- Thanks to [@subnixr](https://github.com/subnixr) for [his awesome Zsh theme](https://github.com/subnixr/minimal)!
- Thanks to [@driesvints](https://github.com/driesvints) for dotfiles pointers
