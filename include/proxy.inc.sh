SSHUSER="spm"
SSHPASS="spm"
SSHHOST="localhost"

proxy_port_start() {
	LOCALPORT="$1"
	REMOTE=$($(sqlite_binary) $SPMDB "SELECT remotehost,remoteport FROM proxy WHERE localport='"$LOCALPORT"';" | sed 's/|/:/g')

	printf "Starting proxy port $LOCALPORT"
	
	progressdot_start

	expect <<HERE 2>&1 > /dev/null
spawn ssh -f -N -L $LOCALPORT:$REMOTE $SSHUSER@$SSHHOST
expect "spm@localhost's password:"
send "$SSHPASS\n"
expect
HERE

	sleep .5

	$(sqlite_binary) $SPMDB "UPDATE proxy SET status='UP' WHERE localport='"$LOCALPORT"';"

	progressdot_stop

	printf "done\n"
}

proxy_port_stop() {
	LOCALPORT="$1"
	
	printf "Stopping proxy port $LOCALPORT"
	
	progressdot_start 0.1
	
	ps -ef | grep "[s]sh.*$LOCALPORT:" | awk '{ print $2 }' | xargs kill -9
	$(sqlite_binary) $SPMDB "UPDATE proxy SET status='DOWN' WHERE localport='"$LOCALPORT"';"
	
	progressdot_stop
	
	printf "done\n"
}

proxy_port_running() {
	LOCALPORT="$1"

	RESULT="$(ps -ef | grep "[s]sh.*$LOCALPORT:")"

	echo ${#RESULT}
}
