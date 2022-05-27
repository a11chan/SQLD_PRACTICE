SELECT A.ADSTRD_CD
     , A.ADSTRD_NM
     , A.AGRDE_SE_CD
     , A.POPLTN_CNT
     , COUNT(*) OVER() �Ѱ�����
     , COUNT(*) OVER(PARTITION BY A.ADSTRD_CD) AS �����������
     , SUM(A.POPLTN_CNT) OVER(PARTITION BY A.ADSTRD_CD) AS SUM_1
     , SUM(A.POPLTN_CNT) OVER(PARTITION BY A.ADSTRD_CD
       ORDER BY A.POPLTN_CNT RANGE UNBOUNDED PRECEDING) AS SUM_2
     , SUM(A.POPLTN_CNT) OVER(PARTITION BY A.ADSTRD_CD
       ORDER BY A.POPLTN_CNT ROWS UNBOUNDED PRECEDING) AS SUM_3
     , SUM(A.POPLTN_CNT) OVER(PARTITION BY A.ADSTRD_CD
                                  ORDER BY A.POPLTN_CNT
                                  RANGE BETWEEN UNBOUNDED PRECEDING
                                            AND UNBOUNDED FOLLOWING) AS SUM_4
  FROM 
     (
      SELECT A.ADSTRD_CD
           , B.ADSTRD_NM AS ADSTRD_NM
           , A.AGRDE_SE_CD
           , A.POPLTN_CNT
        FROM TB_POPLTN A, TB_ADSTRD B
       WHERE A.POPLTN_SE_CD = 'T'
         AND A.STD_YM = '202010'
         AND A.ADSTRD_CD = B.ADSTRD_CD
         AND A.POPLTN_CNT > 0
         AND B.ADSTRD_NM LIKE '��⵵%����%���籸%'
         ORDER BY A.ADSTRD_CD
     ) A
;

--�� ���� ���� �Լ� �ǽ�(LEAD, LAG, FIRST_VALUE, LAST_VALUE)
SELECT A.SUBWAY_STATN_NO AS ����ö����ȣ --ALIAS�� ������ ������ ���� �߻���
     , A.LN_NM AS �뼱��
     , A.STATN_NM AS ����
     , B.STD_YM AS ���س��
     , B.BEGIN_TIME AS ���۽ð�
     , B.END_TIME AS ����ð�
     , (SELECT L.TK_GFF_SE_NM
          FROM TB_TK_GFF_SE L
         WHERE L.TK_GFF_SE_CD = B.TK_GFF_SE_CD
       ) AS �������и�
     , B.TK_GFF_CNT AS ������Ƚ��
     , FIRST_VALUE(B.TK_GFF_CNT ) OVER(PARTITION BY B.TK_GFF_SE_CD
                                          ORDER BY B.BEGIN_TIME
                                           ROWS UNBOUNDED PRECEDING
                                     ) AS FIRST_VALUE
     , LAST_VALUE(B.TK_GFF_CNT ) OVER(PARTITION BY B.TK_GFF_SE_CD
                                         ORDER BY B.BEGIN_TIME
                                          ROWS BETWEEN CURRENT ROW
                                                   AND UNBOUNDED FOLLOWING
                                    ) AS LAST_VALUE
     , LAG(B.TK_GFF_CNT , 1) OVER(PARTITION BY B.TK_GFF_SE_CD
                                     ORDER BY B.BEGIN_TIME
                                ) AS LAG
     , LEAD(B.TK_GFF_CNT , 1) OVER(PARTITION BY B.TK_GFF_SE_CD
                                      ORDER BY B.BEGIN_TIME
                                 ) AS LEAD
  FROM TB_SUBWAY_STATN A, TB_SUBWAY_STATN_TK_GFF B
 WHERE A.SUBWAY_STATN_NO = '000031' --2ȣ�� ����
   AND A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO
   AND B.BEGIN_TIME BETWEEN '0700' AND '1000'
   AND B.END_TIME BETWEEN '0800' AND '1100'
   AND B.STD_YM = '202010'
 ORDER BY B.TK_GFF_SE_CD, B.BEGIN_TIME
;

--6-70 �׷� �� ���� ���� �Լ� �ǽ�
SELECT A.SUBWAY_STATN_NO AS ����ö����ȣ
     , A.LN_NM AS �뼱��
     , A.STATN_NM AS ����
     , B.STD_YM AS ���س��
     , B.BEGIN_TIME AS ���۽ð�
     , B.END_TIME AS ����ð�
     , (SELECT L.TK_GFF_SE_NM
          FROM TB_TK_GFF_SE L
         WHERE L.TK_GFF_SE_CD = B.TK_GFF_SE_CD
       ) AS �������и�
     , B.TK_GFF_CNT AS ������Ƚ��
     , ROUND(RATIO_TO_REPORT(B.TK_GFF_CNT) OVER(PARTITION BY B.TK_GFF_SE_CD), 2) AS RATIO_TO_REPORT
     , ROUND(PERCENT_RANK() OVER(PARTITION BY B.TK_GFF_SE_CD ORDER BY B.TK_GFF_CNT), 2) AS PERCENT_RANK
     , ROUND(CUME_DIST() OVER(PARTITION BY B.TK_GFF_SE_CD ORDER BY B.TK_GFF_CNT), 2) AS CUME_DIST
     , ROUND(NTILE(2) OVER(PARTITION BY B.TK_GFF_SE_CD ORDER BY B.TK_GFF_CNT), 2) AS NTILE
  FROM TB_SUBWAY_STATN A
     , TB_SUBWAY_STATN_TK_GFF B
 WHERE A.SUBWAY_STATN_NO = '000031' --2ȣ�� ����
   AND A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO
   AND B.BEGIN_TIME BETWEEN '0700' AND '1000'
   AND B.END_TIME BETWEEN '0800' AND '1100'
   AND B.STD_YM = '202010'
   ORDER BY B.TK_GFF_SE_CD, B.TK_GFF_CNT