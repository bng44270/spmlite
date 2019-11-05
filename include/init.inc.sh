progressdot_start() {
	[[ -z "$1" ]] && DELAY="0.5" || DELAY="$1"
	while true; do
		printf "."
		sleep $DELAY
	done &
}

progressdot_stop() {
	PROGRESSPID=$(jobs -l | grep 'while true; do' | awk '{ print $2 }')

	disown
	kill $PROGRESSPID
}


usage() {
	echo "usage:"
	echo "       spm.sh <start | stop> <port-number>"
	echo "       spm.sh add <local-port> <remote-host> <remote-port>"
	echo "       spm.sh del <local-port>"
	echo "       spm.sh list"
}
