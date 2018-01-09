# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs


export JAVA_HOME=/usr/java/latest
export JRE_HOME=/usr/java/latest/jre
export PATH=$PATH:/usr/java/latest/bin:/usr/java/latest/jre/bin

PATH=$PATH:$HOME/.local/bin:$HOME/bin

export PATH
