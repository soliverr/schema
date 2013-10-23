#! /bin/bash
#
# Create DDLs to drop tablespaces
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
  NAMES=`find $datadir/tbsp/ -type f -name 'tbsp_*.sql' -print0 |
         xargs -0 -L 1 basename 2>/dev/null | sed -ne 's/^tbsp_\(.\+\)\.sql/\1/gp'`
fi

cat << __EOF__ | $sqlfile
/* *************************************
Drop tablespaces:

$NAMES

**************************************** */

set time on
set verify off

@$confdir/$PACKAGE_NAME-define.sql

__EOF__

# Drop tablespaces
for tbspf in $NAMES ; do
 orabase_info "Droping tablespace $tbspf"
 tbspf="$datadir/tbsp/tbsp_$tbspf.sql"
 if [ ! -r "$tbspf" ] ; then 
  orabase_error "Error reading file $tbspf"
  continue
 fi
 l_define=`sed -ne 's/^--\s*\(DROP TABLESPACE.*\)$/\1/ip' "$tbspf"`
 if [ -n "$l_define" ] ; then
    echo $l_define | $sqlfile
 else
    orabase_error "There is no define for tablespace"
 fi
 echo
done

#echo >> $sqlfile
#echo "exit;" >> $sqlfile

