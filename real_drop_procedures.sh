#! /bin/bash
#
# Create DDLs to drio procedures
#
#

source $liblsb/orabase-functions

sqlfile=${SQL_FILE:-cat}


if [ $# -gt 0  ]; then
  while true ; do
    case "$1" in
      --* ) shift ;;
      * ) break ;;
    esac
  done
  NAMES="$@"
fi

#if [ "$NAMES" = "all" -o -z "$NAMES" ] ; then
#  NAMES="system.orabase_set_local_time_zone"
#fi

cat << __EOF__ | $sqlfile
/* *************************************
Drop procedures:

$NAMES

**************************************** */

set time on
set verify off

@$confdir/$PACKAGE_NAME-define.sql

__EOF__

# Drop procedures
#FIXME: procedure name should be defined in script
for t in $NAMES ; do
  orabase_info "Droping procedure $t"
  echo "drop procedure $t;" | $sqlfile
done

#echo "drop public synonym orabase_set_local_time_zone;" | $sqlfile

#echo >> $sqlfile
#echo "exit;" >> $sqlfile

