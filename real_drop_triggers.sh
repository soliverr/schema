#! /bin/bash
#
# Create DDLs to drop triggers
#

source $liblsb/orabase-functions

sqlfile=${SQL_FILE:-cat}

nosystemtriggers=

if [ $# -gt 0  ]; then
  while true ; do
    case "$1" in
      --no-system-triggers ) nosystemtriggers="true" ; shift ;;
      --* ) shift ;;
      * ) break ;;
    esac
  done
  NAMES="$@"
fi

cat << __EOF__ | $sqlfile
set time on
set verify off

__EOF__

if [ $# -gt 0  ]; then
 NAMES="$@"
fi

#FIXME: Trigger names shoud be get from script
#[ -z "$nosystemtriggers" ] && NAMES="system.orabase_set_local_time_zone $NAMES"
for t in $NAMES ; do
  orabase_info "Droping trigger $t"
  echo "drop trigger $t;" | $sqlfile
done

#echo >> $sqlfile
#echo "exit;" >> $sqlfile

