--
-- Public account for ORADBA.
-- 
-- DROP USER &user_name CASCADE;
--

define user_name = ORADBA_EXECUTOR
define user_pwd  = "orA_$BA_exeC"

create user &&user_name  identified by "&user_pwd" account UNLOCK
    default tablespace &&ORADBA_TBSP_TBLS
    temporary tablespace &&ORADBA_TBSP_TEMP
    profile ORADBA_DEFAULT;

-- System privileges
grant create session                to &&user_name;

