#! /bin/bash
#
# Create DDLs for profiles
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

if [ "$NAMES" = "all" -o -z "$NAMES" ] ; then
  NAMES=`find $datadir/users/ -type f -name 'profile_*.sql' -print0 |
         xargs -0 -L 1 basename 2>/dev/null | sed -ne 's/^profile_\(.\+\)\.sql/\1/gp'`
fi

cat << __EOF__ | $sqlfile
/* *************************************
Create profiles:

$NAMES

**************************************** */

set time on
set verify off

@$confdir/$PACKAGE_NAME-define.sql

__EOF__

# Create profiles
for p in $NAMES ; do
  orabase_info "Creating profile $p"
  p="$datadir/users/profile_$p.sql"
  if [ ! -r "$p" ] ; then
    orabase_error "Error reading file $p"
    continue
  fi
  echo | $sqlfile
  echo "-- @@$p" | $sqlfile
  cat "$p" | $sqlfile
done

#echo >> $sqlfile
#echo "exit;" >> $sqlfile

