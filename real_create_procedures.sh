#! /bin/bash
#
# Create DDLs for procedures
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

cat << __EOF__ | $sqlfile
--
-- create system procedures for $NAMES
--
set time on
set verify off

@$confdir/$PACKAGE_NAME-define.sql

__EOF__

# Create procedures
for proc in $NAMES ; do
  orabase_info "Creating procedure $t"
  t="$datadir/procedures/$proc.sql"
  if [ ! -r "$t" ] ; then
    orabase_error "Error reading file $t"
    continue
  fi
  echo | $sqlfile
  echo "-- @@$t" | $sqlfile
  cat "$t" | sed -e "s#^@@#@$datadir/procedures/#" | $sqlfile
done

#echo >> $sqlfile
#echo "exit;" >> $sqlfile

