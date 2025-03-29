#!/bin/bash
set -euo pipefail
stty -echoctl 
usage() { 
	echo "$0 [-p <variable>]"
	exit 1
}
exit_handler() {
	echo "Quitting..."
	exit 2 
}
trap exit_handler SIGINT

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
