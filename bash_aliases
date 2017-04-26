# package manager
alias install='sudo apt install'
alias update='sudo apt update'
alias upgrade='sudo apt update && sudo apt upgrade'
alias show='apt-cache show'
alias search='apt-cache search'
alias autoremove='sudo apt autoremove --purge'

# symfony
alias sy='php bin/console'
alias sy_dbupdate='sy doctrine:schema:update'
alias sy_ge='sy doctrine:generate:entity'
alias sy_gf='sy doctrine:generate:form'
alias sy_ges='sy doctrine:generate:entities'
alias sy_clearp='sy cache:clear --env=prod'
alias sy_cleard='sy cache:clear --env=dev'

# divers
alias gdb='gdb -q'
alias go='gnome-open'
alias taille='du -hs'
alias ccat='pygmentize -g'
