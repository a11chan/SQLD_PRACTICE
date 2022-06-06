--6.9.2 �� ��/��/�� ���� �п� 1���� 00��~10�� �α����� ���� ���� ������ ���

SELECT SUBSTR(A.ADSTRD_CD, 1, 5) �ñ����ڵ�
     , (SELECT L.ADRES_CL_NM
          FROM TB_ADRES_CL L
         WHERE L.ADRES_CL_SE_CD = 'ACS001'
           AND L.ADRES_CL_CD = B.UPPER_ADRES_CL_CD) �õ� --������� 1�� ���Ͽ��� �ϴ� �� �ڵ带 �־�����?
     , B.ADRES_CL_NM �ñ���
     , SUM(A.POPLTN_CNT) �α���
  FROM TB_POPLTN A, TB_ADRES_CL B
 WHERE SUBSTR(A.ADSTRD_CD, 1, 5) = B.ADRES_CL_CD
   AND B.ADRES_CL_SE_CD = 'ACS002'
   AND A.POPLTN_SE_CD = 'T'
   AND A.AGRDE_SE_CD IN ('000', '010')
 GROUP BY SUBSTR(A.ADSTRD_CD, 1, 5), B.ADRES_CL_NM, B.UPPER_ADRES_CL_CD
 ORDER BY �ñ����ڵ�
;

--6-110 �ñ����� 10������� �α��� �հ� ���� �п� 1���� �α���

SELECT
       A.�ñ����ڵ�
     , A.�õ�
     , A.�ñ���
     , A.�α���
     , A.ACADEMY_CNT
     , TRUNC(A.�α���/A.ACADEMY_CNT) AS �п�1�����α���
  FROM
     (
      SELECT A.�ñ����ڵ� --�ñ����� �α���+�п���
           , A.�õ�
           , A.�ñ���
           , A.�α���
           , COUNT(*) ACADEMY_CNT
        FROM
           (
            SELECT SUBSTR(A.ADSTRD_CD, 1, 5) �ñ����ڵ� --�ñ����� �α���
                 , (SELECT L.ADRES_CL_NM
                      FROM TB_ADRES_CL L
                     WHERE L.ADRES_CL_SE_CD = 'ACS001' --�ּ�ü�� �ֻ��� �׷��̸鼭
                       AND L.ADRES_CL_CD = B.UPPER_ADRES_CL_CD) �õ� --FROM->WHERE->GROUP BY ������ ��ġ�ϴ� �ּҺз��ڵ� ��
                 , B.ADRES_CL_NM �ñ���
                 , SUM(A.POPLTN_CNT) �α���
              FROM TB_POPLTN A, TB_ADRES_CL B
             WHERE SUBSTR(A.ADSTRD_CD, 1, 5) = B.ADRES_CL_CD
               AND B.ADRES_CL_SE_CD = 'ACS002'
               AND A.POPLTN_SE_CD = 'T'
               AND A.AGRDE_SE_CD IN ('000', '010')
             GROUP BY SUBSTR(A.ADSTRD_CD, 1, 5), B.ADRES_CL_NM, B.UPPER_ADRES_CL_CD
             ORDER BY �ñ����ڵ�
           ) A
           , TB_BSSH C
       WHERE 1=1
         AND A.�ñ����ڵ� = C.SIGNGU_CD
         AND C.INDUTY_MIDDL_CL_CD IN (
               'R01' --���������Խ�
             , 'R02' --â��������
             , 'R03' --�ڰ�/�������
             , 'R04' --����
             , 'R05' --���ǹ̼�����
             , 'R06' --��ǻ��
             , 'R07' --�������ü��
             , 'R08' --���Ʊ���
             )
       GROUP BY A.�ñ����ڵ�, A.�õ�, A.�ñ���, A.�α���
    ) A
    ORDER BY �п�1�����α��� DESC
;