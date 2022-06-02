--6.9.1 각 읍/면/동/ 기준 커피숍 1개당 인구수 구하기

--6-106 읍/면/동별 전체 인구수 합계
SELECT
       A.ADSTRD_CD
     , SUM(A.POPLTN_CNT) POPLTN_CNT
  FROM TB_POPLTN A
 WHERE A.STD_YM = '202010'
   AND A.POPLTN_SE_CD = 'T'
 GROUP BY A.ADSTRD_CD
;

--6-107 읍/면/동별 전체 인구수합계 집합과 상가 테이블 조인
SELECT A.ADSTRD_CD, B.ADSTRD_NM, A.POPLTN_CNT, COUNT(*) COFFEE_CNT
  FROM 
     (
      SELECT /*+ NO_MERGE */
             A.ADSTRD_CD
           , SUM(A.POPLTN_CNT) POPLTN_CNT
        FROM TB_POPLTN A
       WHERE A.STD_YM = '202010'
         AND A.POPLTN_SE_CD = 'T'
       GROUP BY A.ADSTRD_CD
     ) A
     , TB_ADSTRD B
     , TB_BSSH C
 WHERE A.ADSTRD_CD = B.ADSTRD_CD
   AND B.ADSTRD_CD = C.ADSTRD_CD
   AND C.INDUTY_SMALL_CL_CD = 'Q12A01'
 GROUP BY A.ADSTRD_CD, B.ADSTRD_NM, A.POPLTN_CNT
;

--6-108 읍/면/동별 커피숍 1개당 인구수
SELECT --인구수/커피숍개수 -> 커피숍 1개당 인구수
       A.ADSTRD_CD
     , A.ADSTRD_NM
     , A.POPLTN_CNT
     , A.COFFEE_CNT
     , TRUNC(A.POPLTN_CNT/A.COFFEE_CNT) AS 커피숍1개당인구수
  FROM 
     (
      SELECT --각 읍면동에 존재하는 커피숍 개수
             A.ADSTRD_CD
           , B.ADSTRD_NM
           , A.POPLTN_CNT
           , COUNT(*) COFFEE_CNT
      FROM 
         (
          SELECT --각 읍면동 기준 전체인구수
                 A.ADSTRD_CD
               , SUM(A.POPLTN_CNT) POPLTN_CNT
            FROM TB_POPLTN A
           WHERE A.STD_YM = '202010'
             AND A.POPLTN_SE_CD = 'T'
           GROUP BY A.ADSTRD_CD
         ) A
         , TB_ADSTRD B
         , TB_BSSH C
     WHERE A.ADSTRD_CD = B.ADSTRD_CD
       AND B.ADSTRD_CD = C.ADSTRD_CD
       AND C.INDUTY_SMALL_CL_CD = 'Q12A01'
     GROUP BY A.ADSTRD_CD, B.ADSTRD_NM, A.POPLTN_CNT
     ) A
 ORDER BY 커피숍1개당인구수 DESC
;