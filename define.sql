--
-- Base configuration for installation process for ORADBA packages
--

-- Name/owner of system schema of ORADBA (should be closed)
define ORADBA_SYS_OWNER = ORADBA

-- Commont name/owner of main target schema (should be opened)
define ORADBA_SCHEMA_OWNER = ORADBA_EXECUTOR

-- Current names/owners for all exists target schemas of ORADBA: main & additional schemas
variable SCHEMA_OWNERS refcursor

-- Name/owner of cleaning schema
define ORADBA_SCHEMA_CLEANER = ORADBA_CLEANER

-- Role to grant permissions to use packages in cleaning schema
define ORADBA_ROLE_CLEANER = ORADBA_CLEANING

-- Tablespace name to create tables into
define ORADBA_TBSP_TBLS = USERS

-- Tablespace name to create indexes into
define ORADBA_TBSP_INDX = USERS

-- Tablespace name for temporary objects
define ORADBA_TBSP_TEMP = TEMP

--
-- Local variables
--
undefine l_cur_schema l_cur_user
--
-- Current schema
--
col l_schema new_value l_cur_schema heading 'Current schema' format a32
--
-- Current user
--
col l_user new_value l_cur_user heading 'Current user' format a32
--
-- Current instance number
--
col l_instance_number new_value l_cur_instno heading 'Current instance number'

-- Set target schema's names for main and additional oradba schemas
-- (When schemas multiplexing is needed)
col SCHEMA_OWNER new_value ORADBA_SCHEMA_OWNER
col SCHEMA_OWNER_2 new_value ORADBA_SCHEMA_OWNER_2
col SCHEMA_OWNER_3 new_value ORADBA_SCHEMA_OWNER_3

set feedback off
select NULL "SCHEMA_OWNER"   from dual where rownum = 0;
select NULL "SCHEMA_OWNER_2" from dual where rownum = 0;
select NULL "SCHEMA_OWNER_3" from dual where rownum = 0;

select sys_context( 'userenv', 'current_user' ) l_user,
       sys_context( 'userenv', 'current_schema' ) l_schema
  from dual;

select instance_number l_instance_number from sys.v_$instance;
set feedback on

-- Add additional schemas definitions here --

-- End of schemas additional definitions --

-- Initialize cursor whith existing shema names
set feedback off
set verify off
begin
  open :SCHEMA_OWNERS for
    select upper(username) username
      from all_users
     where username in ( '&&ORADBA_SCHEMA_OWNER', '&&ORADBA_SCHEMA_OWNER_2', '&&ORADBA_SCHEMA_OWNER_3' );
end;
/

prompt
prompt I: Current schema: &&l_cur_schema  Current username: &&l_cur_user  Current instance number: &&l_cur_instno
prompt
