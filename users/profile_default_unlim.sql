--
-- Unlimited default profile
--
--
-- DROP PROFILE &&L_PROFILE_NAME;
--

define L_PROFILE_NAME = DEFAULT_UNLIM

declare
  l$cnt integer := 0;
  l$sql varchar2(1024) :=
' sessions_per_user		unlimited
  cpu_per_session		unlimited
  cpu_per_call			unlimited
  connect_time			unlimited
  idle_time			unlimited
  logical_reads_per_session	unlimited
  logical_reads_per_call	unlimited
  composite_limit		unlimited
  private_sga			unlimited
  failed_login_attempts		unlimited
  password_life_time		unlimited
  password_reuse_time		unlimited
  password_reuse_max		unlimited
  password_lock_time		unlimited
  password_grace_time		unlimited
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
