#! /bin/bash
#
# Create DDLs for tablespaces
#

source $liblsb/orabase-functions

sqlfile=${SQL_FILE:-cat}


# Directory location
echo | $sqlfile
echo "-- Directory location for SID $ORACLE_SID" | $sqlfile
echo "-- @$confdir/dirs_$ORACLE_SID" | $sqlfile
cat $confdir/dirs_$ORACLE_SID.sql 2>/dev/null || orabase_error "File $confdir/dirs_$ORACLE_SID.sql is not exists" | $sqlfile

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
--
-- create tablespace for $NAMES
--
set time on
set verify off

@$confdir/$PACKAGE_NAME-define.sql

__EOF__

# Create tablespaces
for tbsp in $NAMES ; do
  orabase_info "Creating tablespace $tbsp"
  tbsp="$datadir/tbsp/tbsp_$tbsp.sql"
  if [ ! -r "$tbsp" ] ; then
    oracle_error "Error reading file $tbsp"
    continue
  fi
  echo | $sqlfile
  echo "-- @@$tbsp" | $sqlfile
  cat "$tbsp" | $sqlfile
done

# Resize tablespaces
echo | $sqlfile
echo "-- Resize tablespaces for SID $ORACLE_SID" | $sqlfile
echo "-- @$confdir/dirs_${ORACLE_SID}_resize.sql" | $sqlfile
cat $confdir/dirs_${ORACLE_SID}_resize.sql 2>/dev/null || orabase_error "File $confdir/dirs_${ORACLE_SID}_resize.sql is not exists" | $sqlfile

#echo >> $sqlfile
#echo "exit;" >> $sqlfile

