--6.9.3 지하철역의 각 노선별 승하차인원이 가장 많은 지하철역

--6-11 지하철역별 승하차인원수 합계
SELECT 
       A. SUBWAY_STATN_NO
     , B.STATN_NM
     , B.LN_NM
     , SUM(A.TK_GFF_CNT) AS SUM_TK_GFF_CNT
  FROM TB_SUBWAY_STATN_TK_GFF A
     , TB_SUBWAY_STATN B
 WHERE A.STD_YM = '202010'
   AND A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO
 GROUP BY A.SUBWAY_STATN_NO, B.STATN_NM, B.LN_NM
 ORDER BY SUM_TK_GFF_CNT DESC
;

--6-112 노선별 승하차인원수 합계 1위 구하기
SELECT *
  FROM
     (
      SELECT
             A.SUBWAY_STATN_NO
           , A.STATN_NM
           , A.LN_NM
           , A.SUM_TK_GFF_CNT
           , ROW_NUMBER()
                  OVER(PARTITION BY A.LN_NM
                           ORDER BY A.SUM_TK_GFF_CNT DESC
                      ) AS RNUM_LN_NM_SUM_TK_GFF_CNT
        FROM
           (
            SELECT 
                   A. SUBWAY_STATN_NO
                 , B.STATN_NM
                 , B.LN_NM
                 , SUM(A.TK_GFF_CNT) AS SUM_TK_GFF_CNT
              FROM TB_SUBWAY_STATN_TK_GFF A
                 , TB_SUBWAY_STATN B
             WHERE A.STD_YM = '202010'
               AND A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO
             GROUP BY A.SUBWAY_STATN_NO, B.STATN_NM, B.LN_NM
             ORDER BY SUM_TK_GFF_CNT DESC
            ) A
      ) A
 WHERE RNUM_LN_NM_SUM_TK_GFF_CNT = 1
 ORDER BY SUM_TK_GFF_CNT DESC;
