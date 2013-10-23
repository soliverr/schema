#! /bin/bash
#
# Create objects privilege from role privileges.
#
# Copyright (c) 2008, 2013 Kryazhevskikh Sergey, <soliverr@gmail.com>
#

list_grants() {
  local user="$2"

  #echo "$1 $2"

  sed -ne 's#^--.*PL/SQL.*grant[[:space:][:cntrl:]]\+\(ORADBA_\+\)#\1#ip' $1 | \
    sort | uniq | tr [A-Z] [a-z] | while read role
  do
      #echo $role
      if [ -z "$user" ] ; then
          user="`grep -i "^grant[[:space:][:cntrl:]]\+$role" $1 |
                 sed -e 's/[[:space:][:cntrl:]]\+/ /g; s/&/\\\\&/' | cut -d ' ' -f 4`"
      fi
      #echo $user
      grep -i '^grant.*sys\.' $datadir/users/role_${role}.sql | sed -e "s/\\&role_name;/$user/"

      # The role can be granted to other role
      list_grants $datadir/users/role_${role}.sql ${user}

  done
}

list_grants "$1" "$2"
