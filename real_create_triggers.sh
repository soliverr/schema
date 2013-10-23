#! /bin/bash
#
# Create DDLs for triggers
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
/* *************************************
Create triggers:

$NAMES

**************************************** */

set time on
set verify off

@$confdir/$PACKAGE_NAME-define.sql

__EOF__

# Create triggers
# Add system triggers
#[ -z "$nosystemtriggers" ] && NAMES="set_local_time_zone $NAMES"
#
for trig in $NAMES ; do
  orabase_info "Creating trigger $t"
  t="$datadir/triggers/$trig.sql"
  if [ ! -r "$t" ] ; then
    orabase_error "Error reading file $t"
    continue
  fi
  echo | $sqlfile
  echo "-- @@$t" | $sqlfile
  cat "$t" | sed -e "s#^@@#@$datadir/triggers/#" | $sqlfile
done

#echo >> $sqlfile
#echo "exit;" >> $sqlfile

