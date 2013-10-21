--
-- System schema for ORADBA. Should be alway locked.
--
--  This schema is used to store ORADBA database objects.
--  Don't use this schema for connections and other database operations.
--
--
-- DROP USER &user_name CASCADE;
--

define user_name = ORADBA
define user_pwd  = "oRa_$BA"

create user &&user_name  identified by "&&user_pwd" account LOCK
    default tablespace &&ORADBA_TBSP_TBLS
    temporary tablespace &&ORADBA_TBSP_TEMP
    profile ORADBA_DEFAULT;

alter user &&user_name password EXPIRE;

-- System privileges
grant UNLIMITED TABLESPACE	to &&user_name;

