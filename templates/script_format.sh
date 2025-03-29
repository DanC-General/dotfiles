#!/bin/bash
# Exit on command failure (-e), access of unset variable (-u), if any command in pipe fails (-o pipefail)
set -euo pipefail
# Suppress Ctrl^C printing
stty -echoctl 
usage() { 
	echo "$0 [-p <variable>]"
	exit 1
}
exit_handler() {
	echo "Quitting..."
	exit 2 
}
black='\033[0;30m'        # Black
red='\033[0;31m'          # Red
green='\033[0;32m'        # Green
yellow='\033[0;33m'       # Yellow
blue='\033[0;34m'         # Blue
purple='\033[0;35m'       # Purple
cyan='\033[0;36m'         # Cyan
white='\033[0;37m'        # White
pcol() { 
	local colour=$2
	echo -e "$2$1$white"
}
# Handle Ctrl^C 
trap exit_handler SIGINT

# Handle command line arguments
while getopts ":p:" "params"; do
	case ${params} in 
		p ) pm="${OPTARG}";;
		? ) echo "Invalid choice"
			usage ;;
		* ) echo "Chose $params $OPTARG" ;;
	esac	
done 

# declare -a indexed_arr 
# indexed_arr=( "v1" "v2" "v3" ) 
# declare -A assoc_array
# assoc_arr=(["k1"]="v1" ["k2"]="v2" ["k3"]="v3" )

