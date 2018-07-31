#!/bin/sh
### BEGIN INIT INFO
# Provides:          hwclock
# Required-Start:    
# Required-Stop:     $local_fs
# Default-Start:     S
# Default-Stop:      0 6
# Short-Description: Set system clock
# Description:       Set system clock to hardware clock, according to the UTC
#                    setting in /etc/default/rcS (see also rcS(5)).
### END INIT INFO
#
# WARNING:      If your hardware clock is not in UTC/GMT, this script
#               must know the local time zone. This information is
#               stored in /etc/localtime. This might be a problem if
#               your /etc/localtime is a symlink to something in
#               /usr/share/zoneinfo AND /usr isn't in the root
#               partition! The workaround is to define TZ either
#               in /etc/default/rcS, or in the proper place below.

[ ! -x /sbin/hwclock ] && exit 0

[ -f /etc/default/rcS ] && . /etc/default/rcS

[ "$UTC" = "yes" ] && tz="--utc" || tz="--localtime"
case "$1" in
        start)
                if [ "$VERBOSE" != no ]
                then
                        echo "System time was `date`."
                        echo "Setting system time from hardware clocks..."
                fi

		if [ "$HWCLOCKACCESS" != no ]
		then
			if [ -z "$TZ" ]
			then
	                   hwclock $tz --hctosys 2>/dev/null
			else
			   TZ="$TZ" hwclock $tz --hctosys 2>/dev/null
			fi
		fi

                if [ "$VERBOSE" != no ]
                then
                        echo "System clocks set. Local time is now `date`."
                fi
                ;;
        stop|restart|reload|force-reload)
		#
		# Updates the Hardware Clock with the System Clock time.
		# This will *override* any changes made to the Hardware Clock.
		#
		# WARNING: If you disable this, any changes to the system
		#          clock will not be carried across reboots.
		#
		if [ "$VERBOSE" != no ]
		then
			echo "Saving system time to hardware clocks..."
		fi
		if [ "$HWCLOCKACCESS" != no ]
		then
			hwclock $tz --systohc 2>/dev/null
		fi
		if [ "$VERBOSE" != no -a "$?" == "0" ]
		then
			echo "Hardware clocks updated to `date`."
		fi
                exit 0
                ;;
	show)
		if [ "$HWCLOCKACCESS" != no ]
		then
			hwclock $tz --show
		fi
		;;
        *)
                echo "Usage: hwclock.sh {start|stop|show|reload|restart}" >&2
		echo "       start sets kernel (system) clock from hardware (RTC) clock" >&2
		echo "       stop and reload set hardware (RTC) clock from kernel (system) clock" >&2
                exit 1
                ;;
esac
