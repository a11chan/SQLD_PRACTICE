--6.9.2 각 시/군/구 기준 학원 1개당 00대~10대 인구수가 가장 많은 순으로 출력

SELECT SUBSTR(A.ADSTRD_CD, 1, 5) 시군구코드
     , (SELECT L.ADRES_CL_NM
          FROM TB_ADRES_CL L
         WHERE L.ADRES_CL_SE_CD = 'ACS001'
           AND L.ADRES_CL_CD = B.UPPER_ADRES_CL_CD) 시도 --결과값이 1개 이하여야 하니 이 코드를 넣었을까?
     , B.ADRES_CL_NM 시군구
     , SUM(A.POPLTN_CNT) 인구수
  FROM TB_POPLTN A, TB_ADRES_CL B
 WHERE SUBSTR(A.ADSTRD_CD, 1, 5) = B.ADRES_CL_CD
   AND B.ADRES_CL_SE_CD = 'ACS002'
   AND A.POPLTN_SE_CD = 'T'
   AND A.AGRDE_SE_CD IN ('000', '010')
 GROUP BY SUBSTR(A.ADSTRD_CD, 1, 5), B.ADRES_CL_NM, B.UPPER_ADRES_CL_CD
 ORDER BY 시군구코드
;

--6-110 시군구별 10대까지의 인구수 합계 기준 학원 1개당 인구수

SELECT
       A.시군구코드
     , A.시도
     , A.시군구
     , A.인구수
     , A.ACADEMY_CNT
     , TRUNC(A.인구수/A.ACADEMY_CNT) AS 학원1개당인구수
  FROM
     (
      SELECT A.시군구코드 --시군구별 인구수+학원수
           , A.시도
           , A.시군구
           , A.인구수
           , COUNT(*) ACADEMY_CNT
        FROM
           (
            SELECT SUBSTR(A.ADSTRD_CD, 1, 5) 시군구코드 --시군구별 인구수
                 , (SELECT L.ADRES_CL_NM
                      FROM TB_ADRES_CL L
                     WHERE L.ADRES_CL_SE_CD = 'ACS001' --주소체계 최상위 그룹이면서
                       AND L.ADRES_CL_CD = B.UPPER_ADRES_CL_CD) 시도 --FROM->WHERE->GROUP BY 결과행과 일치하는 주소분류코드 값
                 , B.ADRES_CL_NM 시군구
                 , SUM(A.POPLTN_CNT) 인구수
              FROM TB_POPLTN A, TB_ADRES_CL B
             WHERE SUBSTR(A.ADSTRD_CD, 1, 5) = B.ADRES_CL_CD
               AND B.ADRES_CL_SE_CD = 'ACS002'
               AND A.POPLTN_SE_CD = 'T'
               AND A.AGRDE_SE_CD IN ('000', '010')
             GROUP BY SUBSTR(A.ADSTRD_CD, 1, 5), B.ADRES_CL_NM, B.UPPER_ADRES_CL_CD
             ORDER BY 시군구코드
           ) A
           , TB_BSSH C
       WHERE 1=1
         AND A.시군구코드 = C.SIGNGU_CD
         AND C.INDUTY_MIDDL_CL_CD IN (
               'R01' --보습교습입시
             , 'R02' --창업취업취미
             , 'R03' --자격/국가고시
             , 'R04' --어학
             , 'R05' --음악미술무용
             , 'R06' --컴퓨터
             , 'R07' --예능취미체육
             , 'R08' --유아교육
             )
       GROUP BY A.시군구코드, A.시도, A.시군구, A.인구수
    ) A
    ORDER BY 학원1개당인구수 DESC
;