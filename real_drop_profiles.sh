#! /bin/bash
#
# Create DDLs to drop profiles
#

source $liblsb/orabase-functions

sqlfile=${SQL_FILE:-cat}

cat << __EOF__ | $sqlfile
set time on
set verify off

__EOF__

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
  NAMES=`find $datadir/users/ -type f -name 'profile_*.sql' -a -not -name 'profile_default.sql' -print0 |
         xargs -0 -L 1 basename 2>/dev/null | sed -ne 's/^profile_\(.\+\)\.sql/\1/gp'`
fi

for p in $NAMES ; do
  orabase_info "Droping profile $p"
  p="$datadir/users/profile_$p.sql"
  if [ ! -r "$p" ] ; then 
    orabase_error "Error reading file $p"
    continue
  fi
  l_define=`sed -ne '/^define\s\+L_PROFILE_NAME.*/p' "$p"`
  if [ -n "$l_define" ] ; then
    echo $l_define | $sqlfile
    sed -ne 's/^--\s*\(DROP PROFILE.*\)$/\1/ip' "$p" | $sqlfile
  else
    orabase_error "There is no define for profile name"
  fi
done

#echo >> $sqlfile
#echo "exit;" >> $sqlfile

