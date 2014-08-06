## Source this, don't run it! ##
# e.g. 'source /path/to/color_prompt.sh' in .bash_profile
#
# Creates a custom, colorized prompts depending
# on the hostname of the machine.
#
# Include this in your .bash_profile on remote
# servers you use frequently, and (optionally) add 
# per-host customizations below.
#
# For original source and to suggest patches:
# https://github.com/usernamenumber/sysadmisc
#
# Credit where it's due: I probably got the idea for this
# from a stackexchange post somewhere, but I don't have the
# URL any more. So thank you, random SE person. :)
#


if [ -n "$TERM" ] && which tput &> /dev/null
then
    tput init

    HOSTNAME=`hostname`
    case $HOSTNAME in 
        importantserver)     
            COLOR="red"
            HOSTNAME="PRODUCTION :: \h"
            ;;
        dev-*)
            COLOR="purple"
            HOSTNAME="DEV :: $(hostname | cut -d. -f1 | tr a-z A-Z)"
            ;;
         *)
             COLOR="yellow"
             HOSTNAME="REMOTE::\h"
    esac

    reset='\['$(tput sgr0)'\]'
    bold='\['$(tput bold)'\]'
    case $COLOR in 
        "red")		ccode='\['$(tput setaf 1)'\]' ;;
        "pink")     ccode='\033[1;35m' ;;
        "green") 	ccode='\['$(tput setaf 2)'\]' ;;
        "yellow")	ccode='\['$(tput setaf 3)'\]' ;;
        "blue")		ccode='\['$(tput setaf 4)'\]' ;;
        "purple")	ccode='\['$(tput setaf 5)'\]' ;;
        "cyan")		ccode='\['$(tput setaf 6)'\]' ;;
        "gray")		ccode='\['$(tput setaf 7)'\]' ;;
        "grey")		ccode='\['$(tput setaf 7)'\]' ;;
        *)		ccode=$reset ;;
    esac
    COLOR_START=${ccode}
    COLOR_RESET=${reset}
else
    COLOR_START=''
    COLOR_RESET=''
fi

PS1=${COLOR_START}'\w'${COLOR_RESET}'\n[\u@'${COLOR_START}${HOSTNAME}${COLOR_RESET}' \!]$ '
#PS1="${COLOR_START}${PROMPT}${COLOR_RESET}"
export PS1

