--
-- ORADBA_MONITORING - Role for monitoring jobs
--
--
-- DROP ROLE &&L_ROLE_NAME;
--

define L_ROLE_NAME = RIAS_MONITORING

declare
  l$cnt integer := 0;
  l$sql varchar2(1024) := 'create role &&L_ROLE_NAME identified by "role_monitor1NG"';
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

-- Dinamic views privileges
grant select on sys.v_$bh                       to &&L_ROLE_NAME;
grant select on sys.v_$buffer_pool              to &&L_ROLE_NAME;
grant select on sys.v_$buffer_pool_statistics   to &&L_ROLE_NAME;
grant select on sys.v_$database                 to &&L_ROLE_NAME;
grant select on sys.v_$db_cache_advice          to &&L_ROLE_NAME;
grant select on sys.v_$dlm_misc                 to &&L_ROLE_NAME;
grant select on sys.v_$enqueue_stat             to &&L_ROLE_NAME;
grant select on sys.V_$event_name               to &&L_ROLE_NAME;
grant select on sys.v_$instance                 to &&L_ROLE_NAME;
grant select on sys.v_$instance_recovery        to &&L_ROLE_NAME;
grant select on sys.v_$latch                    to &&L_ROLE_NAME;
grant select on sys.v_$latch_misses             to &&L_ROLE_NAME;
grant select on sys.v_$latch_children           to &&L_ROLE_NAME;
grant select on sys.v_$latch_parent             to &&L_ROLE_NAME;
grant select on sys.v_$librarycache             to &&L_ROLE_NAME;
grant select on sys.v_$lock                     to &&L_ROLE_NAME;
grant select on sys.v_$locked_object            to &&L_ROLE_NAME;
grant select on sys.v_$mystat                   to &&L_ROLE_NAME;
grant select on sys.v_$open_cursor              to &&L_ROLE_NAME;
grant select on sys.v_$parameter                to &&L_ROLE_NAME;
grant select on sys.v_$pga_target_advice        to &&L_ROLE_NAME;
grant select on sys.v_$pgastat                  to &&L_ROLE_NAME;
grant select on sys.v_$process                  to &&L_ROLE_NAME;
grant select on sys.v_$resource_limit           to &&L_ROLE_NAME;
grant select on sys.v_$rollname                 to &&L_ROLE_NAME;
grant select on sys.v_$rollstat                 to &&L_ROLE_NAME;
grant select on sys.v_$rowcache                 to &&L_ROLE_NAME;
grant select on sys.v_$segment_statistics       to &&L_ROLE_NAME;
grant select on sys.v_$segstat                  to &&L_ROLE_NAME;
grant select on sys.v_$segstat_name             to &&L_ROLE_NAME;
grant select on sys.v_$sess_io                  to &&L_ROLE_NAME;
grant select on sys.v_$session                  to &&L_ROLE_NAME;
grant select on sys.v_$session_event            to &&L_ROLE_NAME;
grant select on sys.v_$session_wait             to &&L_ROLE_NAME;
grant select on sys.v_$sesstat                  to &&L_ROLE_NAME;
grant select on sys.v_$sga                      to &&L_ROLE_NAME;
grant select on sys.v_$sga_dynamic_components   to &&L_ROLE_NAME;
grant select on sys.v_$sga_resize_ops           to &&L_ROLE_NAME;
grant select on sys.v_$sgastat                  to &&L_ROLE_NAME;
grant select on sys.v_$shared_pool_advice       to &&L_ROLE_NAME;
grant select on sys.v_$sql                      to &&L_ROLE_NAME;
grant select on sys.v_$sql_plan                 to &&L_ROLE_NAME;
grant select on sys.v_$sql_workarea_histogram   to &&L_ROLE_NAME;
grant select on sys.v_$sqlarea                  to &&L_ROLE_NAME;
grant select on sys.v_$sqltext_with_newlines    to &&L_ROLE_NAME;
grant select on sys.v_$sqltext                  to &&L_ROLE_NAME;
grant select on sys.v_$statname                 to &&L_ROLE_NAME;
grant select on sys.v_$system_event             to &&L_ROLE_NAME;
grant select on sys.v_$system_parameter         to &&L_ROLE_NAME;
grant select on sys.v_$temp_space_header        to &&L_ROLE_NAME;
grant select on sys.v_$transaction              to &&L_ROLE_NAME;
grant select on sys.v_$timer                    to &&L_ROLE_NAME;
grant select on sys.v_$thread                   to &&L_ROLE_NAME;
grant select on sys.v_$undostat                 to &&L_ROLE_NAME;
grant select on sys.v_$waitstat                 to &&L_ROLE_NAME;

--
-- Database catalog privileges
--
grant select on sys.dba_tab_columns             to &&L_ROLE_NAME;
grant select on sys.dba_audit_trail             to &&L_ROLE_NAME;
grant select on sys.dba_data_files              to &&L_ROLE_NAME;
grant select on sys.dba_free_space              to &&L_ROLE_NAME;
grant select on sys.dba_jobs                    to &&L_ROLE_NAME;
grant select on sys.dba_jobs_running            to &&L_ROLE_NAME;
grant select on sys.dba_ind_columns             to &&L_ROLE_NAME;
grant select on sys.dba_source                  to &&L_ROLE_NAME;
grant select on sys.dba_stmt_audit_opts         to &&L_ROLE_NAME;
grant select on sys.dba_triggers                to &&L_ROLE_NAME;
grant select on sys.dba_objects                 to &&L_ROLE_NAME;
grant select on sys.dba_segments                to &&L_ROLE_NAME;
grant select on sys.dba_source                  to &&L_ROLE_NAME;
grant select on sys.DBA_SYNONYMS                to &&L_ROLE_NAME;
grant select on sys.DBA_TAB_PRIVS               to &&L_ROLE_NAME;
grant select on sys.dba_mview_logs              to &&L_ROLE_NAME;
grant select on sys.dba_db_links                to &&L_ROLE_NAME;

undefine L_ROLE_NAME
