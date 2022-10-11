--8.5 계층형 SQL문
--계층형 SQL문에서 WHERE 절은 FROM 절 바로 아래에 위치해야 한다.
--8-40 계층형 SQL문
SELECT A.INDUTY_CL_CD 
     , A.INDUTY_CL_NM
     , B.INDUTY_CL_SE_CD 
     , B.INDUTY_CL_SE_NM 
     , LEVEL LVL
     , LPAD(' ', 4*(LEVEL-1))|| A.INDUTY_CL_CD || '(' || A.INDUTY_CL_NM || ')' AS "업종분류코드(명)"
     , CONNECT_BY_ISLEAF AS CBI
  FROM TB_INDUTY_CL A
     , TB_INDUTY_CL_SE B
 WHERE A.INDUTY_CL_SE_CD = B.INDUTY_CL_SE_CD
 START WITH A.UPPER_INDUTY_CL_CD IS NULL 
 CONNECT BY PRIOR A.INDUTY_CL_CD = A.UPPER_INDUTY_CL_CD 
 ORDER SIBLINGS BY A.INDUTY_CL_CD
 ;
 
--8-41 WHERE 절이 START WITH절 바로 아래 위치
SELECT A.INDUTY_CL_CD 
     , A.INDUTY_CL_NM
     , B.INDUTY_CL_SE_CD 
     , B.INDUTY_CL_SE_NM 
     , LEVEL LVL
     , LPAD(' ', 4*(LEVEL-1))|| A.INDUTY_CL_CD || '(' || A.INDUTY_CL_NM || ')' AS "업종분류코드(명)"
     , CONNECT_BY_ISLEAF AS CBI
  FROM TB_INDUTY_CL A
     , TB_INDUTY_CL_SE B
 START WITH A.UPPER_INDUTY_CL_CD IS NULL 
 WHERE A.INDUTY_CL_SE_CD = B.INDUTY_CL_SE_CD
 CONNECT BY PRIOR A.INDUTY_CL_CD = A.UPPER_INDUTY_CL_CD 
 ORDER SIBLINGS BY A.INDUTY_CL_CD
 ;
--SQL Error [1788] [42000]: ORA-01788: CONNECT BY clause required in this query block
 

--8-42 WHERE 절이 CONNECT BY 절 바로 아래 위치
SELECT A.INDUTY_CL_CD 
     , A.INDUTY_CL_NM
     , B.INDUTY_CL_SE_CD 
     , B.INDUTY_CL_SE_NM 
     , LEVEL LVL
     , LPAD(' ', 4*(LEVEL-1))|| A.INDUTY_CL_CD || '(' || A.INDUTY_CL_NM || ')' AS "업종분류코드(명)"
     , CONNECT_BY_ISLEAF AS CBI
  FROM TB_INDUTY_CL A
     , TB_INDUTY_CL_SE B
 START WITH A.UPPER_INDUTY_CL_CD IS NULL 
 CONNECT BY PRIOR A.INDUTY_CL_CD = A.UPPER_INDUTY_CL_CD 
 WHERE A.INDUTY_CL_SE_CD = B.INDUTY_CL_SE_CD
 ORDER SIBLINGS BY A.INDUTY_CL_CD
 ;
 --SQL Error [933] [42000]: ORA-00933: SQL command not properly ended
 
 
 --CONNECT_BY_PATH 함수 이용 시 구분자로 사용되는 문자가 출력되는 칼럼값 안에 존재하면 SQL 문법 에러가 발생한다.
 --8-44 실습환경 구축
 CREATE TABLE TB_DEPT_8_5_2
 (
  DEPT_CD CHAR(6)
, DEPT_NM VARCHAR2(50)
, UPPER_DEPT_CD CHAR(6)
, CONSTRAINT PK_TB_DEPT_8_5_2 PRIMARY KEY(DEPT_CD)
 )
 ;
 
 INSERT INTO TB_DEPT_8_5_2 VALUES ('D00001','데이터사업본부',NULL);
 INSERT INTO TB_DEPT_8_5_2 VALUES ('D00002','데이터수집,적재팀','D00001');
 INSERT INTO TB_DEPT_8_5_2 VALUES ('D00003','데이터시각화팀','D00001');
 INSERT INTO TB_DEPT_8_5_2 VALUES ('D00004','데이터분석팀','D00001');
 
 SELECT * FROM TB_DEPT_8_5_2 ;
 
 
 --8-45 CONNECT_BY_PATH 함수를 이용한 계층형 SQL문
SELECT DEPT_CD, DEPT_NM
     , LPAD(' ',4*(LEVEL-1))||DEPT_CD||'('||DEPT_NM||')' AS "부서정보"
     , SYS_CONNECT_BY_PATH(DEPT_NM, '^') "부서정보_2"
     , NVL(UPPER_DEPT_CD, '[NULL]') AS UPPER_DEPT_CD
  FROM TB_DEPT_8_5_2 
 START WITH UPPER_DEPT_CD IS NULL
 CONNECT BY PRIOR DEPT_CD = UPPER_DEPT_CD
;

--8-46 SYS_CONNECT_BY_PATH 함수 이용 시 SQL 문법 에러 발생
SELECT DEPT_CD, DEPT_NM
     , LPAD(' ',4*(LEVEL-1))||DEPT_CD||'('||DEPT_NM||')' AS "부서정보"
     , SYS_CONNECT_BY_PATH(DEPT_NM, ',') "부서정보_2"
     , NVL(UPPER_DEPT_CD, '[NULL]') AS UPPER_DEPT_CD
  FROM TB_DEPT_8_5_2 
 START WITH UPPER_DEPT_CD IS NULL
 CONNECT BY PRIOR DEPT_CD = UPPER_DEPT_CD
;
--SQL Error [30004] [99999]: ORA-30004: when using SYS_CONNECT_BY_PATH function, cannot have separator as part of column value