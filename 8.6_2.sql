--조인 컬럼이 SELECT 절에 존재한다면 ORDER BY 절에는 테이블 앨리어스를 붙일 필요가 없다.
--8-51 INNER JOIN SQL문 - ORDER BY
SELECT A.ADSTRD_CD, A.STD_YM, A.POPLTN_SE_CD, A.AGRDE_SE_CD, A.POPLTN_CNT, B.ADSTRD_NM 
  FROM TB_POPLTN A INNER JOIN TB_ADSTRD B 
    ON (A.ADSTRD_CD = B.ADSTRD_CD)
 WHERE A.ADSTRD_CD = '4128157500'
   AND A.POPLTN_SE_CD IN ('M','F')
   AND A.AGRDE_SE_CD IN ('000','010')
 ORDER BY ADSTRD_CD
;

--8-52 INNER JOIN SQL문 - ORDER BY - 에러 발생
SELECT A.STD_YM, A.POPLTN_SE_CD, A.AGRDE_SE_CD, A.POPLTN_CNT, B.ADSTRD_NM 
  FROM TB_POPLTN A INNER JOIN TB_ADSTRD B 
    ON (A.ADSTRD_CD = B.ADSTRD_CD)
 WHERE A.ADSTRD_CD = '4128157500'
   AND A.POPLTN_SE_CD IN ('M','F')
   AND A.AGRDE_SE_CD IN ('000','010')
 ORDER BY ADSTRD_CD
;
--SQL Error [918] [42000]: ORA-00918: column ambiguously defined


--USING 절 조인 시 조인 컬럼에는 테이블 앨리어스를 쓸 수 없다.
--8-53 USING절 사용 - 조인 컬럼에 테이블 앨리어스 안 붙임 - 정상 실행
SELECT ADSTRD_CD 
     , A.STD_YM 
     , A.POPLTN_SE_CD 
     , A.AGRDE_SE_CD 
     , A.POPLTN_CNT 
     , B.ADSTRD_NM 
  FROM TB_POPLTN A INNER JOIN TB_ADSTRD B 
 USING (ADSTRD_CD)
 WHERE ADSTRD_CD = '4128157500' --경기도 고양시 덕양구 삼송동
   AND A.POPLTN_SE_CD IN ('M','F')
   AND A.AGRDE_SE_CD IN ('000','010')
;
--8-54 USING절 사용 - 조인 컬럼에 테이블 앨리어스 붙임 - 에러 발생
SELECT A.ADSTRD_CD 
     , A.STD_YM 
     , A.POPLTN_SE_CD 
     , A.AGRDE_SE_CD 
     , A.POPLTN_CNT 
     , B.ADSTRD_NM 
  FROM TB_POPLTN A INNER JOIN TB_ADSTRD B 
 USING (ADSTRD_CD)
 WHERE ADSTRD_CD = '4128157500' --경기도 고양시 덕양구 삼송동
   AND A.POPLTN_SE_CD IN ('M','F')
   AND A.AGRDE_SE_CD IN ('000','010')
;
--SQL Error [25154] [99999]: ORA-25154: column part of USING clause cannot have qualifier


--USING 절 사용 시 ORDER BY 절에 조인 컬럼을 기재할 때도 앨리어스를 사용하지 않아야 함
--8-55 USING절 사용 - ORDER BY 절 기재 시 앨리어스 안 붙임 - 정상 실행
SELECT ADSTRD_CD 
     , A.STD_YM 
     , A.POPLTN_SE_CD 
     , A.AGRDE_SE_CD 
     , A.POPLTN_CNT 
     , B.ADSTRD_NM 
  FROM TB_POPLTN A INNER JOIN TB_ADSTRD B 
 USING (ADSTRD_CD)
 WHERE ADSTRD_CD = '4128157500' --경기도 고양시 덕양구 삼송동
   AND A.POPLTN_SE_CD IN ('M','F')
   AND A.AGRDE_SE_CD IN ('000','010')
 ORDER BY ADSTRD_CD
;

--8-56 USING절 사용 - ORDER BY 절 기재 시 앨리어스 붙임 - 에러 발생
SELECT ADSTRD_CD 
     , A.STD_YM 
     , A.POPLTN_SE_CD 
     , A.AGRDE_SE_CD 
     , A.POPLTN_CNT 
     , B.ADSTRD_NM 
  FROM TB_POPLTN A INNER JOIN TB_ADSTRD B 
 USING (ADSTRD_CD)
 WHERE ADSTRD_CD = '4128157500' --경기도 고양시 덕양구 삼송동
   AND A.POPLTN_SE_CD IN ('M','F')
   AND A.AGRDE_SE_CD IN ('000','010')
 ORDER BY A.ADSTRD_CD
;
--SQL Error [25154] [99999]: ORA-25154: column part of USING clause cannot have qualifier
