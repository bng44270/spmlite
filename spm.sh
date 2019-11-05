#!/bin/bash

SPMBASE="."

. $SPMBASE/include/init.inc.sh
. $SPMBASE/include/database.inc.sh
. $SPMBASE/include/proxy.inc.sh

db_initialize

case "$1" in
	"start")
		if [ "$(db_proxy_port_exist $2)" -gt 0 ]; then
			proxy_port_start $2
		else
			echo "Port $2 not configured or specified"
		fi
		;;
	"stop")
		if [ "$(proxy_port_running $2)" -gt 0 ]; then
			proxy_port_stop $2
		else
			echo "Port $2 not running or specified"
		fi
		;;
	"add")
		if [ "$(db_proxy_port_exist $2)" -eq 0 ]; then
			if [ -n "$2" ] && [ -n "$3" ] && [ -n "$4" ]; then
				db_proxy_port_add $2 $3 $4
			else
				echo "Please specify local port, remote host, and remote port"
				usage
			fi
		else
			echo "Port already exists or not specified"
		fi
		;;
	"del")
		if [ "$(db_proxy_port_exist $2)" -gt 0 ]; then
			db_proxy_port_del $2
		else
			echo "Port does not exist or not specified"
		fi
		;;
	"list")
		db_proxy_port_list
		;;
	*)
		usage
		;;
esac
