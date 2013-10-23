#! /bin/bash
#
# Create DDLs to drop user
#

source $liblsb/orabase-functions

sqlfile=${SQL_FILE:-cat}

nopublicgrants=

if [ $# -gt 0  ]; then
    while true ; do
        case "$1" in
          --no-public-grants ) nopublicgrants="true" ; shift ;;
          --* ) shift ;;
          * ) break ;;
        esac
    done
    NAMES="$@"
fi

cat << __EOF__ | $sqlfile
--
-- Drop users for $NAMES
--
set time on
set verify off

@$confdir/$PACKAGE_NAME-define.sql

__EOF__

if [ "$NAMES" = "all" -o -z "$NAMES" ] ; then
  NAMES=`find $datadir/users/ -type f -name 'user_*.sql' -print0 |
         xargs -0 -L 1 basename 2>/dev/null | sed -ne 's/^user_\(.\+\)\.sql/\1/gp'`
fi

# Drop users
for f in $NAMES ; do
  orabase_info "Droping user $f"
  f="$datadir/users/user_$f.sql"
  if [ ! -r "$f" ] ; then 
    orabase_error "Error reading file $f"
    continue
  fi
  l_define=`sed -ne '/^define\s\+user_name.*/p' "$f"`
  if [ -n "$l_define" ] ; then
    echo $l_define | $sqlfile
    sed -ne 's/^--\s*\(DROP\s\+USER.*\)$/\1/ip' "$f" | $sqlfile
  else
    orabase_error "There is no define for user name"
  fi
  echo
done

#echo >> $sqlfile
#echo "exit;" >> $sqlfile

