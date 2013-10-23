#! /bin/bash
#
# Create DDLs to drop roles
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
Drop roles:

$NAMES

**************************************** */

set time on
set verify off

@$confdir/$PACKAGE_NAME-define.sql

__EOF__

# Drop roles
for f in $NAMES ; do
  orabase_info "Droping role $f"
  f="$datadir/users/role_$f.sql"
  if [ ! -r "$f" ] ; then 
    orabase_error "Error reading file $f"
    continue
  fi
  l_define=`sed -ne '/^define\s\+L_ROLE_NAME.*/p' "$f"`
  if [ -n "$l_define" ] ; then
    echo $l_define | $sqlfile
    sed -ne 's/^--\s*\(DROP\s\+ROLE.*\)$/\1/ip' "$f" | $sqlfile
  else
    orabase_error "There is no define for role name"
  fi
  echo
done

#echo >> $sqlfile
#echo "exit;" >> $sqlfile

