#!/bin/bash
### BEGIN INIT INFO
# Provides:          himbeer-gpio-service
# Required-Start:    $all
# Required-Stop:     $all
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: himbeer gpio service
# Description:       himbeer gpio service webrick server autostart-script
### END INIT INFO

. /lib/lsb/init-functions

# Modify it to your configuration
DIR=/opt/himbeer-gpio-service

# Start himbeer gpio service in daemon mode.
start(){
	log_daemon_msg "Starting himbeer gpio service"
	cd $DIR
	log_progress_msg
	bundle exec ruby start_service.rb &> /dev/null &
	log_progress_msg
	log_end_msg 0
}

# Stop himbeer gpio service daemon
stop(){
	log_daemon_msg "Stopping gpio service WebRick"
	RUBYPID=`ps aux | grep "ruby start_service.rb" | grep -v grep | awk '{print $2}'`
	log_progress_msg
	if [ "x$RUBYPID" != "x" ]; then
		kill -9 $RUBYPID
	fi
	log_end_msg 0
}

# Check if gpio service is running
status(){
	RUBYPID=`ps aux | grep "ruby start_service.rb" | grep -v grep | awk '{print $2}'`
	if [ "x$RUBYPID" = "x" ]; then
		echo "* gpio service is not running"
	else
		echo "* gpio service is running"
	fi
}


case "$1" in
	start)
		start
		;;
	
	stop)
		stop
		;;
	
	status)
		status
		;;
	
	restart|force-reload)
		stop
		start
		;;

	*)
		echo "Usage: $0 {start|stop|restart|force-reload|status}"
		exit 1

esac
