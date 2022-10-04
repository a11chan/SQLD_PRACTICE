--8.2 집계 함수
--공집합일 경우 MAX 함수를 써서 단 1건이라도 출력하게 할 수 있다.

--8-12 공집합이 리턴되는 SQL문
SELECT STATN_NM
  FROM TB_SUBWAY_STATN
 WHERE STATN_NM = '평양역'
;

--8-13 MAX 및 NVL 함수의 사용
SELECT NVL(MAX(STATN_NM), '역명없음') AS STATN_NM
  FROM TB_SUBWAY_STATN
 WHERE STATN_NM = '평양역'
;

--8-14 COUNT 및 MAX 함수의 사용, 공집합인 경우 COUNT(*)의 결과는 0이 리턴됨을 이용
SELECT CASE WHEN COUNT(*) = 0 THEN '역명없음'
            ELSE MAX(STATN_NM) END AS STATN_NM
  FROM TB_SUBWAY_STATN 
 WHERE STATN_NM = '평양역'
;

--SELECT 절에서 집계함수 이용 시 집계 함수를 이용하지 않은 컬럼은 GROUP BY 절에 기재해야 한다.
--8-15 집계 함수의 사용
SELECT MAX(POPLTN_CNT) POPLTN_CNT
  FROM TB_POPLTN
;

--8-16 집계 함수 사용 시 SELECT 절에 칼럼 기재
SELECT POPLTN_SE_CD
     , MAX(POPLTN_CNT) POPLTN_CNT
  FROM TB_POPLTN
;
--SQL Error [937] [42000]: ORA-00937: not a single-group group function

--8-17 집계 함수를 이용하지 않은 칼럼은 반드시 GROUP BY 절에 기재
SELECT POPLTN_SE_CD
     , MAX(POPLTN_CNT) POPLTN_CNT
  FROM TB_POPLTN
  GROUP BY POPLTN_SE_CD
;