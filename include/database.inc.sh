SPMDB="$SPMBASE/db/proxy.db"

sqlite_binary() {
	ls /usr/bin/sqlite* | head -n 1
}

db_initialize() {
	if [  ! -f "$SPMDB" ]; then
		printf "Initializing database..."
		$(sqlite_binary) $SPMDB 'CREATE TABLE proxy(reponame text, remotehost text, remoteport text, status text);'
		printf "done\n"
	fi	
}

db_proxy_port_add() {
	LOCALPORT="$1"
	REMOTEHOST="$2"
	REMOTEPORT="$3"

	$(sqlite_binary) $SPMDB "INSERT INTO proxy VALUES ('"$LOCALPORT"','"$REMOTEHOST"','"$REMOTEPORT"','"DOWN"');"
}

db_proxy_port_del() {
	LOCALPORT="$1"

	$(sqlite_binary) $SPMDB "DELETE FROM proxy WHERE localport='"$LOCALPORT"';"
}

db_proxy_port_exist() {
	LOCALPORT="$1"

	RESULT="$($(sqlite_binary) $SPMDB "SELECT * FROM proxy WHERE localport='"$LOCALPORT"';")"

	echo ${#RESULT}
}

db_proxy_port_list() {
	$(sqlite_binary) $SPMDB 'SELECT * FROM proxy' | awk 'BEGIN { FS="|"; printf "%-12s %-17s %-12s %-8s\n","LocalPort","RemoteHost","RemotePort","Status" } { printf "%-12s %-17s %-12s %-8s\n",$1, $2, $3, $4 }'
}


