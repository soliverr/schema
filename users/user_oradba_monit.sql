--
-- User for ORADBA monitoring
--
-- DROP USER &user_name CASCADE;
--

define user_name = ORADBA_MONIT
define user_pwd  = m0nitor1NG

create user &&user_name  identified by "&user_pwd" account LOCK
    default tablespace &&ORADBA_TBSP_TBLS
    temporary tablespace &&ORADBA_TBSP_TEMP
    profile ORADBA_MONITORING;

-- System privileges
grant CREATE SESSION		to &&user_name;
grant ALTER SESSION	    	to &&user_name;
grant UNLIMITED TABLESPACE	to &&user_name;

