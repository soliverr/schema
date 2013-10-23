#! /bin/bash
#
# Create DDLs for users' schemas
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
-- create users for $NAMES
--
set time on
set verify off

@$confdir/$PACKAGE_NAME-define.sql

__EOF__

# Grant public privileges
if [ -z "$nopublicgrants" ] ; then
    orabase_info "Grant public rights"
    t="$datadir/users/grant_public.sql"
    if [ -r "$t" ] ; then
        echo | $sqlfile
        echo "-- @@grant_public" | $sqlfile
        cat "$t" | $sqlfile
    else
        orabase_error "Error reading file $t"
    fi
fi

if [ "$NAMES" = "all" -o -z "$NAMES" ] ; then
  NAMES=`find $datadir/users/ -type f -name 'user_*.sql' -print0 |
         xargs -0 -L 1 basename 2>/dev/null | sed -ne 's/^user_\(.\+\)\.sql/\1/gp'`
fi

# Create users/schemas
for user in $NAMES ; do
  orabase_info "Creating user $user"
  u="$datadir/users/user_$user.sql"
  if [ ! -r "$u" ] ; then
    orabase_error "Ошибка чтения файла $u"
    continue
  fi
  echo | $sqlfile
  echo "-- @@$u" | $sqlfile
  cat "$u" | $sqlfile
  echo "-- Grants by ROLE" | $sqlfile
  $libexecdir/grant_role_privs.sh "$u" | $sqlfile
  trig="$datadir/triggers/$user.sql"
  if [ -r "$trig" ] ; then
      orabase_info "Creating user's trigger for $user"
      echo "-- @@$trig" | $sqlfile
      cat "$trig" | $sqlfile
  fi
done

#echo >> $sqlfile
#echo "exit;" >> $sqlfile
