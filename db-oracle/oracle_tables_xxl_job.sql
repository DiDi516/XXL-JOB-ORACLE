CREATE TABLE xxl_job_info
(
    id number PRIMARY KEY,
    job_group number NOT NULL,
    job_cron varchar2(128) NOT NULL,
    job_desc varchar2(255) NOT NULL,
    add_time date DEFAULT sysdate,
    update_time date,
    author varchar2(64),
    alarm_email varchar2(255),
    executor_route_strategy varchar2(50),
    executor_handler varchar2(255),
    executor_param varchar2(512),
    executor_block_strategy varchar2(50),
    executor_timeout number DEFAULT 0 NOT NULL,
    executor_fail_retry_count number DEFAULT 0 NOT NULL,
    glue_type varchar2(50) NOT NULL,
    glue_source clob,
    glue_remark varchar2(128),
    glue_updatetime date,
    child_jobid varchar2(255),
    trigger_status number DEFAULT 0 NOT NULL,
    trigger_last_time number DEFAULT 0 NOT NULL,
    trigger_next_time number DEFAULT 0 NOT NULL
);
COMMENT ON COLUMN xxl_job_info.job_group IS '执行器主键ID';
COMMENT ON COLUMN xxl_job_info.job_cron IS '任务执行CRON';
COMMENT ON COLUMN xxl_job_info.author IS '作者';
COMMENT ON COLUMN xxl_job_info.alarm_email IS '报警邮件';
COMMENT ON COLUMN xxl_job_info.executor_route_strategy IS '执行器路由策略';
COMMENT ON COLUMN xxl_job_info.executor_handler IS '执行器任务handler';
COMMENT ON COLUMN xxl_job_info.executor_param IS '执行器任务参数';
COMMENT ON COLUMN xxl_job_info.executor_block_strategy IS '阻塞处理策略';
COMMENT ON COLUMN xxl_job_info.executor_timeout IS '任务执行超时时间，单位秒';
COMMENT ON COLUMN xxl_job_info.executor_fail_retry_count IS '失败重试次数';
COMMENT ON COLUMN xxl_job_info.glue_type IS 'GLUE类型';
COMMENT ON COLUMN xxl_job_info.glue_source IS 'GLUE源代码';
COMMENT ON COLUMN xxl_job_info.glue_remark IS 'GLUE备注';
COMMENT ON COLUMN xxl_job_info.glue_updatetime IS 'GLUE更新时间';
COMMENT ON COLUMN xxl_job_info.child_jobid IS '子任务ID，多个逗号分隔';
COMMENT ON COLUMN xxl_job_info.trigger_status IS '调度状态：0-停止，1-运行';
COMMENT ON COLUMN xxl_job_info.trigger_last_time IS '上次调度时间';
COMMENT ON COLUMN xxl_job_info.trigger_next_time IS '下次调度时间';
create sequence xxl_job_info_seq
  start with 1
  increment by 1
  maxvalue 999999999;

--==========================================================================

CREATE TABLE xxl_job_log
(
    id number PRIMARY KEY,
    job_group number NOT NULL,
    job_id number NOT NULL,
    executor_address varchar2(255),
    executor_handler varchar2(255),
    executor_param varchar2(512),
    executor_sharding_param varchar2(20),
    executor_fail_retry_count number DEFAULT 0 NOT NULL,
    trigger_time date,
    trigger_code number,
    trigger_msg clob,
    handle_time date,
    handle_code number NOT NULL,
    handle_msg clob,
    alarm_status number DEFAULT 0 NOT NULL
);
COMMENT ON COLUMN xxl_job_log.job_group IS '执行器主键ID';
COMMENT ON COLUMN xxl_job_log.job_id IS '任务，主键ID';
COMMENT ON COLUMN xxl_job_log.executor_address IS '执行器地址，本次执行的地址';
COMMENT ON COLUMN xxl_job_log.executor_handler IS '执行器任务handler';
COMMENT ON COLUMN xxl_job_log.executor_param IS '执行器任务参数';
COMMENT ON COLUMN xxl_job_log.executor_sharding_param IS '执行器任务分片参数，格式如 1/2';
COMMENT ON COLUMN xxl_job_log.executor_fail_retry_count IS '失败重试次数';
COMMENT ON COLUMN xxl_job_log.trigger_time IS '调度-时间';
COMMENT ON COLUMN xxl_job_log.trigger_code IS '调度-结果';
COMMENT ON COLUMN xxl_job_log.trigger_msg IS '调度-日志';
COMMENT ON COLUMN xxl_job_log.handle_time IS '执行-时间';
COMMENT ON COLUMN xxl_job_log.handle_code IS '执行-状态';
COMMENT ON COLUMN xxl_job_log.handle_msg IS '执行-日志';
COMMENT ON COLUMN xxl_job_log.alarm_status IS '告警状态：0-默认、1-无需告警、2-告警成功、3-告警失败';
create sequence xxl_job_log_seq
  start with 1
  increment by 1
  maxvalue 999999999;

--==========================================================================

CREATE TABLE xxl_job_logglue
(
    id number PRIMARY KEY,
    job_id number NOT NULL,
    glue_type varchar2(50),
    glue_source clob,
    glue_remark varchar2(128) NOT NULL,
    add_time date DEFAULT sysdate,
    update_time date
);
COMMENT ON COLUMN xxl_job_logglue.job_id IS '任务，主键ID';
COMMENT ON COLUMN xxl_job_logglue.glue_type IS 'GLUE类型';
COMMENT ON COLUMN xxl_job_logglue.glue_source IS 'GLUE源代码';
COMMENT ON COLUMN xxl_job_logglue.glue_remark IS 'GLUE备注';
create sequence xxl_job_logglue_seq
  start with 1
  increment by 1
  maxvalue 999999999;

--==========================================================================

CREATE TABLE xxl_job_registry
(
    id number PRIMARY KEY,
    registry_group varchar2(255) NOT NULL,
    registry_key varchar2(255) NOT NULL,
    registry_value varchar2(255) NOT NULL,
    update_time date
);
create sequence xxl_job_registry_seq
  start with 1
  increment by 1
  maxvalue 999999999;

--==========================================================================

CREATE TABLE xxl_job_group
(
    id number PRIMARY KEY,
    app_name varchar2(64) NOT NULL,
    title varchar2(12) NOT NULL,
    sort number DEFAULT 0 NOT NULL,
    address_type number DEFAULT 0 NOT NULL,
    address_list varchar2(512)
);
COMMENT ON COLUMN xxl_job_group.app_name IS '执行器AppName';
COMMENT ON COLUMN xxl_job_group.title IS '执行器名称';
COMMENT ON COLUMN xxl_job_group.sort IS '排序';
COMMENT ON COLUMN xxl_job_group.address_type IS '执行器地址类型：0=自动注册、1=手动录入';
COMMENT ON COLUMN xxl_job_group.address_list IS '执行器地址列表，多地址逗号分隔';
create sequence xxl_job_group_seq
  start with 1
  increment by 1
  maxvalue 999999999;

--==========================================================================

CREATE TABLE xxl_job_user
(
    id number PRIMARY KEY,
    username varchar2(50) NOT NULL,
    password varchar2(50) NOT NULL,
    role number NOT NULL,
    permission varchar2(255)
);
COMMENT ON COLUMN xxl_job_user.username IS '账号';
COMMENT ON COLUMN xxl_job_user.password IS '密码';
COMMENT ON COLUMN xxl_job_user.role IS '角色：0-普通用户、1-管理员';
COMMENT ON COLUMN xxl_job_user.permission IS '权限：执行器ID列表，多个逗号分割';
create sequence xxl_job_user_seq
  start with 1
  increment by 1
  maxvalue 999999999;

--==========================================================================

CREATE TABLE xxl_job_lock
(
    lock_name varchar2(50) PRIMARY KEY
);
COMMENT ON COLUMN xxl_job_lock.lock_name IS '锁名称';

--==========================================================================

INSERT INTO XXL_JOB_GROUP (ID, APP_NAME, TITLE, SORT, ADDRESS_TYPE, ADDRESS_LIST) VALUES (23, 'test-execute', 'test-execute', 1, 0, '127.0.0.1:9999');
INSERT INTO XXL_JOB_INFO (ID, JOB_GROUP, JOB_CRON, JOB_DESC, ADD_TIME, UPDATE_TIME, AUTHOR, ALARM_EMAIL, EXECUTOR_ROUTE_STRATEGY, EXECUTOR_HANDLER, EXECUTOR_PARAM, EXECUTOR_BLOCK_STRATEGY, EXECUTOR_TIMEOUT, EXECUTOR_FAIL_RETRY_COUNT, GLUE_TYPE, GLUE_SOURCE, GLUE_REMARK, GLUE_UPDATETIME, CHILD_JOBID, TRIGGER_STATUS, TRIGGER_LAST_TIME, TRIGGER_NEXT_TIME) VALUES (21, 23, '0/5 * * * * ? *', '测试', TO_DATE('2019-08-28 14:27:27', 'YYYY-MM-DD HH24:MI:SS'), TO_DATE('2019-08-28 14:27:27', 'YYYY-MM-DD HH24:MI:SS'), '胡一兰', null, 'FIRST', 'TestJob', null, 'SERIAL_EXECUTION', 0, 0, 'BEAN', null, 'GLUE代码初始化', TO_DATE('2019-08-28 14:27:27', 'YYYY-MM-DD HH24:MI:SS'), null, 0, 0, 0);
INSERT INTO XXL_JOB_USER (ID, USERNAME, PASSWORD, ROLE, PERMISSION) VALUES (1, 'admin', 'e10adc3949ba59abbe56e057f20f883e', 1, null);
INSERT INTO XXL_JOB_LOCK ( lock_name) VALUES ( 'schedule_lock');

commit;

