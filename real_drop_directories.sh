#! /bin/bash
#
# Create DDLs to drop directories
#
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
  NAMES=`find $datadir/directories/ -type f -name 'directory_*.sql' -print0 |
         xargs -0 -L 1 basename 2>/dev/null | sed -ne 's/^directory_\(.\+\)\.sql/\1/gp'`
fi

for f in $NAMES ; do
  orabase_info "Droping directory $f"
  f="$datadir/directories/directory_$f.sql"
  if [ ! -r "$f" ] ; then 
    orabase_error "Error reading file $f"
    continue
  fi
  l_define=`sed -ne '/^define\s\+L_DIR_NAME.*/p' "$f"`
  if [ -n "$l_define" ] ; then
    echo $l_define | $sqlfile
    sed -ne 's/^--\s*\(DROP\s\+DIRECTORY.*\)$/\1/ip' "$f" | $sqlfile
  else
    orabase_error "There is no define for directory name"
  fi
  echo
done

#echo >> $sqlfile
#echo "exit;" >> $sqlfile

