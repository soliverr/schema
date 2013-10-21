--
-- Grant public grants
--

--grant select on sys.v_$database to public;
--grant select on sys.v_$instance to public;

grant EXECUTE ON sys.dbms_session to public;
grant EXECUTE ON sys.dbms_utility to public;
grant EXECUTE ON sys.dbms_lock to public;

