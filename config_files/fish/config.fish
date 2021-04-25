##########################################################
############    FISH SHELL CONFIG FILE    ################
##########################################################


### ADDING TO PATH ###

# Add /home/pulkit/bin to PATH
export PATH="/home/pulkit/bin:$PATH"
# Add /home/pulkit/.local/bin to PATH
export PATH="/home/pulkit/.local/bin:$PATH"
# Add /home/pulkit/packages/psi4conda/bin to PATH
#export PATH="/home/pulkit/packages/psi4conda/bin:$PATH"

### PATH ENDS ###


# Removes ugly background color from some directories
export LS_COLORS="$LS_COLORS:ow=1;34:tw=1;34:"


# Set vim as the default editor
set EDITOR vim


# functions needed for !! and !$
function __history_previous_command
    switch (commandline -t)
    case "!"
        commandline -t $history[1]; commandline -f repaint
    case "*"
        commandline -i !
    end
end

function __history_previous_command_arguments
    switch (commandline -t)
    case "!"
        commandline -t ""
        commandline -f history-token-search-backward
    case "*"
        commandline -i '$'
    end
end

bind ! __history_previous_command
bind '$' __history_previous_command_arguments


### ALIASES ###

alias vi='vim'
alias lrt='ls -lrth'
alias psi4='/home/pulkit/packages/psi4conda/bin/psi4'
alias restartfish='source /home/pulkit/.config/fish/config.fish'

### ALIASES END ###


### USED DEFINED FUNCTIONS ###

# for printing a column (splits input on whitespaces)
function grabcol
    while read -l input
        echo $input | awk '{print $'$argv[1]'}'
    end
end

# for printing a row
function grabrow --argument index
    sed -n "$index p"
end
