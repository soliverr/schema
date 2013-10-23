#! /bin/bash
#
# Create DDLs for roles
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
  NAMES=`find $datadir/users/ -type f -name 'role_*.sql' -print0 |
         xargs -0 -L 1 basename 2>/dev/null | sed -ne 's/^role_\(.\+\)\.sql/\1/gp'`
fi

cat << __EOF__ | $sqlfile
/* *************************************
Create roles:

$NAMES

**************************************** */

set time on
set verify off

@$confdir/$PACKAGE_NAME-define.sql

__EOF__

# Create roles
for role in $NAMES ; do
  orabase_info "Creating role $role"
  role="$datadir/users/role_$role.sql"
  if [ ! -r "$role" ] ; then
    orabase_error "Error reading file $role"
    continue
  fi
  echo | $sqlfile
  echo "-- @@$role" | $sqlfile
  cat "$role" | $sqlfile
done

#echo >> $sqlfile
#echo "exit;" >> $sqlfile

