#! /bin/bash

./build.sh

package=`cat ./configure.ac | sed -ne 's/^AC_INIT(\([^,]*\)\s*,.*/\1/gp'`

#
# Set up to emulate system installation process
#

echo
echo Test installation ...
echo

destdir=inst

rm -rf $destdir 2>&-

./configure

make install DESTDIR=$destdir || exit 1


#
# Set up to test scripts locally
#

echo
echo Setup test units ...
echo

destdir=`pwd`/test

rm -rf $destdir

# Configure for local path to run test
./configure --prefix=$destdir/usr --localstatedir=$destdir/var \
            --sysconfdir=$destdir/etc --datadir=$destdir/usr/share/oradba/$package \
            --libexecdir=$destdir/usr/libexec/oradba/$package \
            --with-liblsb=$destdir/lib/lsb \
            --with-confdir=$destdir/etc/oracle/oradba

make install || exit 1

# Copy function libraries
install -D ../oracle-base/orabase-functions $destdir/lib/lsb/orabase-functions

# Run tests
echo
echo Run tests ...
echo

export ORACLE_SID=default

$destdir/usr/sbin/oradba-schema-create-users > test/create_users.sql
$destdir/usr/sbin/oradba-schema-create-profiles > test/create_profiles.sql
#$destdir/usr/sbin/oradba-schema-create-triggers > test/create_triggers.sql
$destdir/usr/sbin/oradba-schema-create-roles > test/create_roles.sql
#$destdir/usr/sbin/oradba-schema-create-tbsps > test/create_tbsps.sql

$destdir/usr/sbin/oradba-schema-drop-users > test/drop_users.sql
$destdir/usr/sbin/oradba-schema-drop-profiles > test/drop_profiles.sql
#$destdir/usr/sbin/oradba-schema-drop-triggers > test/drop_triggers.sql
$destdir/usr/sbin/oradba-schema-drop-roles > test/drop_roles.sql
#$destdir/usr/sbin/oradba-schema-drop-tbsps > test/drop_tbsps.sql

ls -l test/*.sql

exit 0
