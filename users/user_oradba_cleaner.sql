--
-- User to run clean jobs
--
-- DROP USER &user_name CASCADE;
--

define user_name = ORADBA_CLEANER
define user_pwd  = orA_clean1NG

create user &&user_name  identified by "&user_pwd" account LOCK
    default tablespace &&ORADBA_TBSP_TBLS
    temporary tablespace &&ORADBA_TBSP_TEMP
    profile ORADBA_CLEANING;

alter user &&user_name password EXPIRE;

-- System privileges
grant CREATE SESSION		to &&user_name;
grant ALTER SESSION		    to &&user_name;

-- User roles
grant &&ORADBA_ROLE_CLEANER	to &&user_name;

