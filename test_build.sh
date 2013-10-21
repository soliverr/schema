#! /bin/bash

./build.sh

package=`cat ./configure.ac | sed -ne 's/^AC_INIT(\([^,]*\)\s*,.*/\1/gp'`


#
# Set up to test scripts locally
#

destdir=`pwd`/test

rm -rf $destdir

# Configure for local path to test scripts
./configure --prefix=$destdir/usr --localstatedir=$destdir/var \
            --sysconfdir=$destdir/etc --datadir=$destdir/usr/share/$package \
            --libexecdir=$destdir/usr/libexec/$package \
            --with-liblsb=$destdir/lib/lsb \
            --with-confdir=$destdir/etc/oracle/oradba

make install || exit 1

# Run tests
#export ORACLE_SID=billing

#$destdir/opt/rias/sbin/dba_schema_create_users | tee test/create_users.sql
#$destdir/opt/rias/sbin/dba_schema_create_profiles | tee test/create_profiles.sql
#$destdir/opt/rias/sbin/dba_schema_create_triggers perm | tee test/create_triggers.sql
#$destdir/opt/rias/sbin/dba_schema_create_roles | tee test/create_roles.sql
#$destdir/opt/rias/sbin/dba_schema_create_tbsps | tee test/create_tbsps.sql

#$destdir/opt/rias/sbin/dba_schema_drop_users | tee test/drop_users.sql
#$destdir/opt/rias/sbin/dba_schema_drop_profiles | tee test/drop_profiles.sql
#$destdir/opt/rias/sbin/dba_schema_drop_triggers | tee test/drop_triggers.sql
#$destdir/opt/rias/sbin/dba_schema_drop_roles | tee test/drop_roles.sql
#$destdir/opt/rias/sbin/dba_schema_drop_tbsps | tee test/drop_tbsps.sql


#
# Set up to emulate system installation process
#

destdir=inst

rm -rf $destdir 2>&-

./configure --with-confdir=/etc/oracle/oradba

make install DESTDIR=$destdir || exit 1

