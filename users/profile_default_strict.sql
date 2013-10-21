--
-- Paranoid default profile
--
--
-- DROP PROFILE &&L_PROFILE_NAME;
--

define L_PROFILE_NAME = DEFAULT_STRICT

declare
  l$cnt integer := 0;
  l$sql varchar2(1024) :=
' sessions_per_user		1
  cpu_per_session		1
  cpu_per_call			1
  connect_time			1
  idle_time			1
  logical_reads_per_session	1
  logical_reads_per_call	1
  composite_limit		1
  private_sga			1
  failed_login_attempts		1
  password_life_time		1
  password_reuse_time		1
  password_reuse_max		1
  password_lock_time		2
  password_grace_time		1
  password_verify_function	default
';

begin
  select count(1) into l$cnt
    from sys.dba_profiles
   where profile = '&&L_PROFILE_NAME';

   if l$cnt = 0 then
     l$sql := 'create profile &&L_PROFILE_NAME limit ' || l$sql;
     execute immediate l$sql;
     dbms_output.put_line( CHR(10) || 'I: Profile &&L_PROFILE_NAME created' );
   else
     dbms_output.put_line( CHR(10) || 'W: Profile &&L_PROFILE_NAME already exists' );
     l$sql := 'alter profile &&L_PROFILE_NAME limit ' || l$sql;
     execute immediate l$sql;
     dbms_output.put_line( CHR(10) || 'I: Profile &&L_PROFILE_NAME altered' );
   end if;
end;
/

undefine L_PROFILE_NAME
