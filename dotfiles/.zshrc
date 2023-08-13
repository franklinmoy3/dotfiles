# Case-insensitive tab completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
autoload -Uz compinit && compinit


# Aliases
alias ll='ls -lA'
alias mci="echo mvn clean install && mvn clean install"
alias mci-debug="echo mvn clean install -Dmaven.surefire.debug && mvn clean install -Dmaven.surefire.debug"
alias mdt="echo mvn dependency:tree && mvn dependency:tree"


# Force git pull upon terminal start (KEEP THIS AS THE LAST GROUP)
echo git pull
git pull
