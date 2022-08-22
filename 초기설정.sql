CREATE USER SQLD IDENTIFIED BY 1234;
ALTER USER SQLD ACCOUNT UNLOCK;
GRANT RESOURCE, DBA, CONNECT TO SQLD;

CREATE TABLESPACE SQLD_DATA
DATAFILE 'C:\oraclexe\app\oracle\oradata\XE\SQLD_DATA.dbf' SIZE 4G
AUTOEXTEND ON NEXT 512M MAXSIZE UNLIMITED
LOGGING
ONLINE
PERMANENT
EXTENT MANAGEMENT LOCAL AUTOALLOCATE
BLOCKSIZE 8K
SEGMENT SPACE MANAGEMENT AUTO
FLASHBACK ON;

CREATE TEMPORARY TABLESPACE SQLD_TEMP
TEMPFILE 'C:\oraclexe\app\oracle\oradata\XE\SQLD_TEMP.dbf' SIZE 1G
AUTOEXTEND ON NEXT 100M MAXSIZE UNLIMITED;

ALTER USER SQLD DEFAULT TABLESPACE SQLD_DATA;
ALTER USER SQLD TEMPORARY TABLESPACE SQLD_TEMP;

SELECT ROWNUM AS 순번
     , TABLE_NAME AS 테이블명
     , (SELECT L.COMMENTS
          FROM DBA_TAB_COMMENTS L
         WHERE L.OWNER = 'SQLD'
           AND L.TABLE_NAME = A.TABLE_NAME) AS 테이블한글명
     , DATA_CNT AS 테이블행수
     , COUNT(*) OVER() AS 총테이블수
     , SUM(DATA_CNT) OVER() AS 총행수
  FROM
     (
       SELECT TRIM('TB_ADRES_CL') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_ADRES_CL
       UNION ALL
       SELECT TRIM('TB_ADRES_CL_SE') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_ADRES_CL_SE
       UNION ALL
       SELECT TRIM('TB_ADSTRD') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_ADSTRD
       UNION ALL
       SELECT TRIM('TB_AGRDE_SE') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_AGRDE_SE
       UNION ALL
       SELECT TRIM('TB_PLOT_SE') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_PLOT_SE
       UNION ALL
       SELECT TRIM('TB_POPLTN') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_POPLTN
       UNION ALL
       SELECT TRIM('TB_POPLTN_SE') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_POPLTN_SE
       UNION ALL
       SELECT TRIM('TB_RN') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_RN
       UNION ALL
       SELECT TRIM('TB_STDR_INDUST_CL') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_STDR_INDUST_CL
       UNION ALL
       SELECT TRIM('TB_SUBWAY_STATN') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_SUBWAY_STATN
       UNION ALL
       SELECT TRIM('TB_SUBWAY_STATN_TK_GFF') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_SUBWAY_STATN_TK_GFF
       UNION ALL
       SELECT TRIM('TB_TK_GFF_SE') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_TK_GFF_SE
       UNION ALL
       SELECT TRIM('TB_BSSH') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_BSSH
       UNION ALL
       SELECT TRIM('TB_INDUTY_CL') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_INDUTY_CL
       UNION ALL
       SELECT TRIM('TB_INDUTY_CL_SE') AS TABLE_NAME, COUNT(*) DATA_CNT FROM TB_INDUTY_CL_SE
     ) A
;