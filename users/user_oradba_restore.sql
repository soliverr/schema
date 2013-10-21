--
-- User for restore jobs
--
-- DROP USER &user_name CASCADE;
--

define user_name = ORADBA_RESTORE
define user_pwd  = rstrst

create user &&user_name  identified by "&&user_pwd" account LOCK
  default tablespace &&ORADBA_TBSP_TBLS
  temporary tablespace &&ORADBA_TBSP_TEMP
  profile ORADBA_DEFAULT;

alter user &&user_name password EXPIRE;

-- System privileges
grant UNLIMITED TABLESPACE  to &&user_name;

-- Roles
grant RESOURCE  to &&user_name;

