--
-- ORADBA_CLEANING - Role for cleaning jobs
--
--
-- DROP ROLE &&L_ROLE_NAME;
--

define L_ROLE_NAME = RIAS_CLEANING

declare
  l$cnt integer := 0;
  l$sql varchar2(1024) := 'create role &&L_ROLE_NAME not identified';
begin
  select count(1) into l$cnt
    from sys.dba_roles
   where role = '&&L_ROLE_NAME';

   if l$cnt = 0 then
     begin
       execute immediate l$sql;
       execute immediate 'revoke &&L_ROLE_NAME from SYS' ;
       dbms_output.put_line( CHR(10) || 'I: Role &&L_ROLE_NAME created' );
     end;
   else
       dbms_output.put_line( CHR(10) || 'W: Role &&L_ROLE_NAME already exists' );
   end if;
end;
/

-- System privileges
grant CREATE SESSION to &&L_ROLE_NAME;

undefine L_ROLE_NAME
