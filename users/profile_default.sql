--
-- Default profile
--

alter profile default limit
  sessions_per_user         unlimited
  cpu_per_session           unlimited
  cpu_per_call              unlimited
  connect_time              unlimited
  idle_time                 480
  logical_reads_per_session unlimited
  logical_reads_per_call    unlimited
  composite_limit           unlimited
  private_sga               unlimited
  failed_login_attempts     unlimited
  password_life_time        unlimited
  password_reuse_time       unlimited
  password_reuse_max        unlimited
  password_lock_time        unlimited
  password_grace_time       unlimited
  password_verify_function  null;
