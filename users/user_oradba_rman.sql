--
-- User to support RMAN backups
--
-- DROP USER &user_name CASCADE;
--

define user_name = ORADBA_RMAN
define user_pwd  = "oRa_rman"

create user &&user_name  identified by "&user_pwd" account LOCK
    default tablespace &&ORADBA_TBSP_TBLS
    temporary tablespace &&ORADBA_TBSP_TEMP
    profile ORADBA_DEFAULT;

alter user &&user_name password EXPIRE;

-- System privileges
grant CONNECT                to &&user_name;
grant RESOURCE               to &&user_name;
grant RECOVERY_CATALOG_OWNER to &&user_name;

