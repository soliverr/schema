#! /bin/bash
#
# Create DDLs for directories
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

# Create directories
for directory in $NAMES ; do
  orabase_info "Creating directory $directory"
  directory="$datadir/directories/directory_$directory.sql"
  if [ ! -r "$directory" ] ; then
    orabase_error "Error reading file $directory"
    continue
  fi
  echo | $sqlfile
  echo "-- @@$directory" | $sqlfile
  cat "$directory" | $sqlfile
  
  folder=`sed -ne '/^define\s\+L_FOLDER.*/p' $directory 2>/dev/null`
  if [ -n "$folder" ] ; then
    echo $folder | $sqlfile
    echo "host mkdir -p &&L_FOLDER" | $sqlfile
  fi
done

#echo >> $sqlfile
#echo "exit;" >> $sqlfile
