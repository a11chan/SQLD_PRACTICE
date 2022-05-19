SELECT A.SUBWAY_STATN_NO
, SUM(CASE WHEN A.TK_GFF_SE_CD = 'TGS001' 
           THEN A.TK_GFF_CNT
           ELSE 0 END ) AS "승차인원수합계"
, SUM(CASE WHEN A.TK_GFF_SE_CD = 'TGS002'
           THEN A.TK_GFF_CNT
           ELSE 0 END ) AS "하차인원수합계"
, SUM(CASE WHEN A.BEGIN_TIME = '0800' 
            AND A.END_TIME = '0900' 
            AND A.TK_GFF_SE_CD = 'TGS001' 
           THEN A.TK_GFF_CNT
           ELSE 0 END) AS "출근시간대 승차인원수합계"
, SUM(CASE WHEN A.BEGIN_TIME = '0800'
            AND A.END_TIME = '0900'
            AND A.TK_GFF_SE_CD = 'TGS002'
           THEN A.TK_GFF_CNT
           ELSE 0 END) AS "출근시간대 하차인원수합계"
, SUM(CASE WHEN A.BEGIN_TIME = '1800'
            AND A.END_TIME = '1900'
            AND A.TK_GFF_SE_CD = 'TGS001'
           THEN A.TK_GFF_CNT
           ELSE 0 END) AS "퇴근시간대 승차인원수합계"
, SUM(CASE WHEN A.BEGIN_TIME = '1800'
            AND A.END_TIME = '1900'
            AND A.TK_GFF_SE_CD = 'TGS002'
           THEN A.TK_GFF_CNT
           ELSE 0 END) AS "퇴근시간대 하차인원수합계"
, SUM(TK_GFF_CNT) AS "승하차인원수합계"
FROM TB_SUBWAY_STATN_TK_GFF A
WHERE A.STD_YM = '202010'
GROUP BY A.SUBWAY_STATN_NO
HAVING SUM(CASE WHEN A.TK_GFF_SE_CD = 'TGS001' --승차인원수 
           THEN A.TK_GFF_CNT
           ELSE 0 END ) >= 1000000
    OR SUM(CASE WHEN A.TK_GFF_SE_CD = 'TGS002' --하차인원수
           THEN A.TK_GFF_CNT
           ELSE 0 END ) >= 1000000
;

SELECT A.SUBWAY_STATN_NO 
, A.LN_NM 
, A.STATN_NM 
FROM TB_SUBWAY_STATN A
WHERE A.SUBWAY_STATN_NO = '000040'
;

CREATE TABLE TB_AGG_NULL_TEST
(
  NUM NUMBER(15,2)
);

INSERT INTO TB_AGG_NULL_TEST (NUM) VALUES (NULL);
INSERT INTO TB_AGG_NULL_TEST (NUM) VALUES (10);
INSERT INTO TB_AGG_NULL_TEST (NUM) VALUES (20);
INSERT INTO TB_AGG_NULL_TEST (NUM) VALUES (30);
INSERT INTO TB_AGG_NULL_TEST (NUM) VALUES (40);

SELECT * FROM TB_AGG_NULL_TEST;

SELECT SUM(NUM) AS "NUM의 합계"
, AVG(NUM) AS "NUM의 평균"
, MAX(NUM) AS "NUM의 최대"
, MIN(NUM) AS "NUM의 최소"
, COUNT(NUM) AS "NUM의 개수"
FROM TB_AGG_NULL_TEST 
; -- 컬럼이 하나여서 GROUP BY 절이 없어도 에러가 나지 않는 건가?

CREATE TABLE TB_AGG_NULL_TEST2
(
  NUM NUMBER(15,2)
, NUM2 NUMBER(15,2)
);

INSERT INTO TB_AGG_NULL_TEST2 (NUM, NUM2) VALUES (NULL, NULL);
INSERT INTO TB_AGG_NULL_TEST2 (NUM, NUM2) VALUES (10, 15);
INSERT INTO TB_AGG_NULL_TEST2 (NUM, NUM2) VALUES (20, 25);
INSERT INTO TB_AGG_NULL_TEST2 (NUM, NUM2) VALUES (30, 35);
INSERT INTO TB_AGG_NULL_TEST2 (NUM, NUM2) VALUES (40, 45);
INSERT INTO TB_AGG_NULL_TEST2 (NUM, NUM2) VALUES (50, 55);

DELETE FROM TB_AGG_NULL_TEST2 WHERE NUM = 50;

SELECT * FROM TB_AGG_NULL_TEST2;

SELECT SUM(NUM) AS "NUM의 합계"
, AVG(NUM) AS "NUM의 평균"
, MAX(NUM) AS "NUM의 최대"
, MIN(NUM) AS "NUM의 최소"
, COUNT(NUM) AS "NUM의 개수"
FROM TB_AGG_NULL_TEST2
; --여러 컬럼일 때 GROUP BY 없어도 실행됨

SELECT SUM(NUM) AS "NUM의 합계"
, AVG(NUM) AS "NUM의 평균"
, MAX(NUM) AS "NUM의 최대"
, MIN(NUM) AS "NUM의 최소"
, COUNT(*) AS "NUM의 개수"
FROM TB_AGG_NULL_TEST2
;

SELECT A.INDUTY_CL_CD 
, A.INDUTY_CL_NM 
, A.INDUTY_CL_SE_CD 
, NVL(A.UPPER_INDUTY_CL_CD, '(NULL)') AS UPPER_INDUTY_CL_CD 
FROM TB_INDUTY_CL A
WHERE A.INDUTY_CL_SE_CD = 'ICS001' --대
ORDER BY A.INDUTY_CL_CD DESC
;

SELECT A.INDUTY_CL_CD AS "업종분류코드"
     , A.INDUTY_CL_NM AS "업종분류명"
     , A.INDUTY_CL_SE_CD AS "업종분류구분코드"
     , NVL(A.UPPER_INDUTY_CL_CD, '(NULL)') AS "상위업종분류코드"
FROM TB_INDUTY_CL A
WHERE A.INDUTY_CL_CD LIKE 'Q%'
  AND A.INDUTY_CL_NM LIKE '%음식%'
ORDER BY A.UPPER_INDUTY_CL_CD DESC 
;

--5.8.8 SELECT절에 존재하지 않는 컬럼으로 정렬
SELECT A.SUBWAY_STATN_NO 
     , A.LN_NM 
FROM TB_SUBWAY_STATN A
WHERE A.LN_NM = '9호선'
ORDER BY A.STATN_NM 
;

SELECT A.SUBWAY_STATN_NO 
, A.LN_NM 
, A.STATN_NM 
FROM TB_SUBWAY_STATN A
WHERE A.SUBWAY_STATN_NO = '000607'
;

--5.8.6 GROUP BY 절 사용 시 정렬작업
SELECT A.AGRDE_SE_CD 
     , SUM(A.POPLTN_CNT) AS SUM_POPLTN_CNT
FROM TB_POPLTN A
WHERE A.STD_YM = '202010'
  AND A.POPLTN_SE_CD IN('M', 'F')
GROUP BY A.AGRDE_SE_CD 
ORDER BY SUM(A.POPLTN_CNT) DESC --SELECT절에 존재하지 않으면 에러 발생 -> ORA-00979 : not a GROUP BY expression
; 

--10건의 행만을 출력 - ORDER BY, ROWNUM
SELECT A.BSSH_NO
     , A.CMPNM_NM
     , A.BHF_NM
     , A.LNM_ADRES 
     , A.LO 
     , A.LA
FROM TB_BSSH A
WHERE ROWNUM <= 10
ORDER BY A.LO 
;

--전체 데이터의 정렬결과 중에서 상위 10건만 출력하기 - 제대로 된 부분 범위 처리
SELECT A.BSSH_NO
     , A.CMPNM_NM
     , A.BHF_NM
     , A.LNM_ADRES
     , A.LO
     , A.LA
FROM 
  ( 
    SELECT A.BSSH_NO
         , A.CMPNM_NM 
         , A.BHF_NM
         , A.LNM_ADRES
         , A.LO
         , A.LA
    FROM TB_BSSH A
    ORDER BY A.LO
  ) A
WHERE ROWNUM <= 10
;

--강남역 기준, 2020년 10월 1달간 출근시간대(08-09) 승하차 인원수 구하기
SELECT A.SUBWAY_STATN_NO 
     , A.LN_NM 
     , A.STATN_NM
     , B.BEGIN_TIME 
     , B.END_TIME 
     , CASE WHEN TK_GFF_SE_CD = 'TGS001' THEN '승차'
            WHEN TK_GFF_SE_CD = 'TGS002' THEN '하차'
            END TK_GFF_SE_NM
     , B.TK_GFF_CNT 
FROM TB_SUBWAY_STATN A
   , TB_SUBWAY_STATN_TK_GFF B
WHERE A.SUBWAY_STATN_NO  = B.SUBWAY_STATN_NO 
  AND A.SUBWAY_STATN_NO = '000032' --2호선 강남
  AND B.STD_YM = '202010'
  AND B.BEGIN_TIME = '0800'
  AND B.END_TIME = '0900'
;

--승하차 코드를 조인을 통해 한글로 변경(3개 테이블 조인)
SELECT A.SUBWAY_STATN_NO 
     , A.LN_NM
     , A.STATN_NM
     , B.BEGIN_TIME 
     , B.END_TIME 
     , C.TK_GFF_SE_NM 
     , B.TK_GFF_CNT 
FROM TB_SUBWAY_STATN A
   , TB_SUBWAY_STATN_TK_GFF B
   , TB_TK_GFF_SE C
WHERE A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO
  AND A.SUBWAY_STATN_NO = '000032'
  AND B.STD_YM = '202010'
  AND B.BEGIN_TIME = '0800'
  AND B.END_TIME = '0900'
  AND B.TK_GFF_SE_CD = C.TK_GFF_SE_CD
;

--4개 테이블 조인
SELECT A.ADSTRD_CD 
     , D.ADSTRD_NM 
     , A.POPLTN_SE_CD 
     , B.POPLTN_SE_NM
     , A.AGRDE_SE_CD 
     , C.AGRDE_SE_NM 
     , A.POPLTN_CNT
FROM TB_POPLTN A
   , TB_POPLTN_SE B
   , TB_AGRDE_SE C
   , TB_ADSTRD D
WHERE A.ADSTRD_CD = D.ADSTRD_CD 
  AND A.POPLTN_SE_CD = B.POPLTN_SE_CD 
  AND A.AGRDE_SE_CD = C.AGRDE_SE_CD 
  AND A.POPLTN_SE_CD IN ('M', 'F')
  AND A.STD_YM = '202010'
  AND C.AGRDE_SE_CD IN ('020', '030', '040')
  AND D.ADSTRD_NM LIKE '%경기도%고양시%덕양구%삼송%'
ORDER BY A.POPLTN_CNT DESC
;

--5.10.1 각 지역별(시/도 기준) 스타벅스 커피 매장의 개수 구하기
SELECT A.CTPRVN_CD, A.CMPNM_NM, A.BHF_NM, A.LNM_ADRES
FROM TB_BSSH A
WHERE (A.CMPNM_NM LIKE '%스타%벅스%'
       OR
       UPPER(A.CMPNM_NM) LIKE '%STAR%BUCKS%'
      )
;
--GROUP BY절을 이용하여 시도코드(CTPRVN_CD) 칼럼으로 그룹화
--COUNT 함수를 이용하여 각 시/도별 스타벅스 매장 수 출력
--주소분류(TB_ADRES_CL) 테이블을 조인하여 각 시도코드가 어떤 지역인지
--시/도명인 주소분류명(ADRES_CL_NM) 칼럼 출력
SELECT A.CTPRVN_CD
    , B.ADRES_CL_NM
    , COUNT(*) AS CNT
FROM TB_BSSH A
   , TB_ADRES_CL B
WHERE (A.CMPNM_NM LIKE '%스타%벅스%' --상점명 칼럼
       OR
       UPPER(A.CMPNM_NM) LIKE '%STAR%BUCKS%'
      )
  AND A.CTPRVN_CD = B.ADRES_CL_CD --시도코드 == 주소분류코드
  AND B.ADRES_CL_SE_CD = 'ACS001' --시도 기준
GROUP BY A.CTPRVN_CD, B.ADRES_CL_NM
ORDER BY CNT DESC
;

--5.10.2 출근시간대 하차인원이 가장 많은 순으로 지하철역 정보 조회하기
SELECT A.SUBWAY_STATN_NO
     , B.LN_NM
     , B.STATN_NM
     , C.TK_GFF_SE_NM
     , A.BEGIN_TIME
     , A.END_TIME
     , A.TK_GFF_CNT
FROM TB_SUBWAY_STATN_TK_GFF A
   , TB_SUBWAY_STATN B
   , TB_TK_GFF_SE C
WHERE A.STD_YM = '202010'
  AND A.BEGIN_TIME = '0800'
  AND A.END_TIME = '0900'
  AND A.TK_GFF_SE_CD = 'TGS002' --하차
  AND A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO
  AND A.TK_GFF_SE_CD = C.TK_GFF_SE_CD
ORDER BY A.TK_GFF_CNT DESC
;

--연령대별 남성/여성 인구수 구하기
--인구(TB_POPLTN)테이블을 조회하여 연령대구분코드(AGRDE_SE_CD)칼럼별로 남성 및 여성의 인구수 조회
SELECT A.AGRDE_SE_CD
      , SUM(CASE WHEN A.POPLTN_SE_CD = 'M'
                 THEN A.POPLTN_CNT ELSE 0 END) MALE_POPLTN_CNT
      , SUM(CASE WHEN A.POPLTN_SE_CD = 'F'
                 THEN A.POPLTN_CNT ELSE 0 END) FEMALE_POPLTN_CNT
FROM TB_POPLTN A
GROUP BY A.AGRDE_SE_CD
ORDER BY A.AGRDE_SE_CD
;