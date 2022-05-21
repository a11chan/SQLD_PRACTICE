--6.1.5 INNER JOIN
SELECT A.SUBWAY_STATN_NO
     , A.LN_NM
     , A.STATN_NM
     , B.BEGIN_TIME
     , B.END_TIME
     , CASE WHEN B.TK_GFF_SE_CD = 'TGS001' THEN '승차'
            WHEN B.TK_GFF_SE_CD = 'TGS002' THEN '하차'
            END TK_GFF_SE_NM
     , B.TK_GFF_CNT
FROM TB_SUBWAY_STATN A
   , TB_SUBWAY_STATN_TK_GFF B
WHERE A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO
  AND A.SUBWAY_STATN_NO = '000001'
  AND B.STD_YM = '202010'
  AND B.BEGIN_TIME = '0800'
  AND B.END_TIME = '0900'
ORDER BY B.TK_GFF_CNT DESC
;

--6.1.6 NATURAL JOIN
CREATE TABLE TB_DEPT_6_1_6
(
  DEPT_CD CHAR(4)
, DEPT_NM VARCHAR2(50)
, CONSTRAINT PK_TB_DEPT_6_1_6 PRIMARY KEY(DEPT_CD)
);

INSERT INTO TB_DEPT_6_1_6 (DEPT_CD, DEPT_NM) VALUES ('D001', '데이터팀');
INSERT INTO TB_DEPT_6_1_6 (DEPT_CD, DEPT_NM) VALUES ('D002', '영업팀');
INSERT INTO TB_DEPT_6_1_6 (DEPT_CD, DEPT_NM) VALUES ('D003', 'IT개발팀');

CREATE TABLE TB_EMP_6_1_6
(
  EMP_NO CHAR(4)
, EMP_NM VARCHAR2(50)
, DEPT_CD CHAR(4)
, CONSTRAINT PK_TB_EMP_6_1_6 PRIMARY KEY(EMP_NO)
);

INSERT INTO TB_EMP_6_1_6 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E001', '이경오', 'D001');
INSERT INTO TB_EMP_6_1_6 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E002', '이수지', 'D001');
INSERT INTO TB_EMP_6_1_6 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E003', '김영업', 'D002');
INSERT INTO TB_EMP_6_1_6 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E004', '박영업', 'D002');
INSERT INTO TB_EMP_6_1_6 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E005', '최개발', 'D003');
INSERT INTO TB_EMP_6_1_6 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E006', '정개발', 'D003');

SELECT * FROM TB_EMP_6_1_6;

ALTER TABLE TB_EMP_6_1_6
ADD CONSTRAINT FK_TB_EMP_6_1_6 FOREIGN KEY (DEPT_CD)
REFERENCES TB_DEPT_6_1_6 (DEPT_CD);

--NATURAL JOIN 시에는 JOIN 대상 칼럼에 ALIAS 부여 불가
SELECT DEPT_CD
     , A.DEPT_NM
     , B.EMP_NO
     , B.EMP_NM
FROM TB_DEPT_6_1_6 A NATURAL JOIN TB_EMP_6_1_6 B
ORDER BY DEPT_CD;

--NATURAL JOIN을 INNER JOIN으로 변환
SELECT A.DEPT_CD
     , A.DEPT_NM
     , B.EMP_NO
     , B.EMP_NM
FROM TB_DEPT_6_1_6 A
   , TB_EMP_6_1_6 B
WHERE A.DEPT_CD = B.DEPT_CD
ORDER BY A.DEPT_CD
;
--JOIN은 EXCEL에서의 VLOOKUP류 함수와 구조가 비슷하다.

--USING을 이용한 JOIN
SELECT SUBWAY_STATN_NO
     , A.LN_NM
     , A.STATN_NM
     , B.BEGIN_TIME
     , B.END_TIME
     , CASE WHEN B.TK_GFF_SE_CD = 'TGS001' THEN '승차'
            WHEN B.TK_GFF_SE_CD = 'TGS002' THEN '하차'
            END TK_GFF_SE_NM
     , B.TK_GFF_CNT
FROM TB_SUBWAY_STATN A
JOIN TB_SUBWAY_STATN_TK_GFF B
USING (SUBWAY_STATN_NO)
WHERE SUBWAY_STATN_NO = '000001'
  AND B.STD_YM = '202010'
  AND B.BEGIN_TIME = '0800'
  AND B.END_TIME = '0900'
ORDER BY B.TK_GFF_CNT DESC
;

--ON을 사용한 JOIN
SELECT A.SUBWAY_STATN_NO
     , A.LN_NM
     , A.STATN_NM
     , B.BEGIN_TIME
     , B.END_TIME
     , CASE WHEN B.TK_GFF_SE_CD = 'TGS001' THEN '승차'
            WHEN B.TK_GFF_SE_CD = 'TGS002' THEN '하차'
            END TK_GFF_SE_NM
     , B.TK_GFF_CNT
FROM TB_SUBWAY_STATN A
INNER JOIN TB_SUBWAY_STATN_TK_GFF B
ON (A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO)
WHERE A.SUBWAY_STATN_NO = '000001'
  AND B.STD_YM = '202010'
  AND B.BEGIN_TIME = '0800'
  AND B.END_TIME = '0900'
ORDER BY B.TK_GFF_CNT DESC
;
--3개 테이블 조인
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
ORDER BY B.TK_GFF_CNT
;

SELECT A.SUBWAY_STATN_NO
     , A.LN_NM
     , A.STATN_NM
     , B.BEGIN_TIME
     , B.END_TIME
     , C.TK_GFF_SE_NM
     , B.TK_GFF_CNT
FROM TB_SUBWAY_STATN A
INNER JOIN TB_SUBWAY_STATN_TK_GFF B
ON (A.SUBWAY_STATN_NO = B.SUBWAY_STATN_NO)
INNER JOIN TB_TK_GFF_SE C
ON (B.TK_GFF_SE_CD = C.TK_GFF_SE_CD)
WHERE A.SUBWAY_STATN_NO = '000032'
  AND B.STD_YM = '202010'
  AND B.BEGIN_TIME = '0800'
  AND B.END_TIME = '0900'
ORDER BY B.TK_GFF_CNT
;

--6.1.10 OUTER JOIN
CREATE TABLE TB_DEPT_6_1_10
(
  DEPT_CD CHAR(4)
, DEPT_NM VARCHAR2(50)
, CONSTRAINT PK_TB_DEPT_6_1_10 PRIMARY KEY(DEPT_CD)
);

INSERT INTO TB_DEPT_6_1_10 (DEPT_CD, DEPT_NM) VALUES ('D001', '데이터팀');
INSERT INTO TB_DEPT_6_1_10 (DEPT_CD, DEPT_NM) VALUES ('D002', '영업팀');
INSERT INTO TB_DEPT_6_1_10 (DEPT_CD, DEPT_NM) VALUES ('D003', 'IT개발팀');
INSERT INTO TB_DEPT_6_1_10 (DEPT_CD, DEPT_NM) VALUES ('D004', '4차산업혁명팀');
INSERT INTO TB_DEPT_6_1_10 (DEPT_CD, DEPT_NM) VALUES ('D005', 'AI연구팀');

CREATE TABLE TB_EMP_6_1_10
(
  EMP_NO CHAR(4)
, EMP_NM VARCHAR2(50)
, DEPT_CD CHAR(4)
, CONSTRAINT PK_TB_TMP_6_1_10 PRIMARY KEY (EMP_NO)
);

INSERT INTO TB_EMP_6_1_10 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E001', '이경오', 'D001');
INSERT INTO TB_EMP_6_1_10 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E002', '이수지', 'D001');
INSERT INTO TB_EMP_6_1_10 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E003', '김영업', 'D002');
INSERT INTO TB_EMP_6_1_10 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E004', '박영업', 'D002');
INSERT INTO TB_EMP_6_1_10 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E005', '최개발', 'D003');
INSERT INTO TB_EMP_6_1_10 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E006', '정개발', 'D003');
INSERT INTO TB_EMP_6_1_10 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E007', '석신입', NULL);
INSERT INTO TB_EMP_6_1_10 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E008', '차인턴', NULL);
INSERT INTO TB_EMP_6_1_10 (EMP_NO, EMP_NM, DEPT_CD) VALUES ('E009', '강회장', 'D000');

--6.1.11 LEFT OUTER JOIN - 오라클 방식
SELECT NVL(A.DEPT_CD, '(NULL)') AS A_DEPT_CD
     , NVL(A.DEPT_NM, '(NULL)') AS A_DEPT_NM
     , NVL(B.EMP_NO, '(NULL)') AS B_EMP_NO
     , NVL(B.EMP_NM, '(NULL)') AS B_EMP_NM
     , NVL(B.DEPT_CD, '(NULL)') AS B_DEPT_NO
FROM TB_DEPT_6_1_10 A, TB_EMP_6_1_10 B
WHERE A.DEPT_CD = B.DEPT_CD(+)
ORDER BY A.DEPT_CD
;

--LEFT OUTER JOIN - ANSI 방식
SELECT NVL(A.DEPT_CD, '(NULL)') AS A_DEPT_CD
     , NVL(A.DEPT_NM, '(NULL)') AS A_DEPT_NM
     , NVL(B.EMP_NO, '(NULL)') AS B_EMP_NO
     , NVL(B.EMP_NM, '(NULL)') AS B_EMP_NM
     , NVL(B.DEPT_CD, '(NULL)') AS B_DEPT_NO
FROM TB_DEPT_6_1_10 A LEFT OUTER JOIN TB_EMP_6_1_10 B
  ON (A.DEPT_CD = B.DEPT_CD)
ORDER BY A.DEPT_CD
;

--RIGHT OUTER JOIN - ORACLE METHOD
SELECT NVL(A.DEPT_CD, '(NULL)') AS A_DEPT_CD
     , NVL(A.DEPT_NM, '(NULL)') AS A_DEPT_NM
     , NVL(B.EMP_NO, '(NULL)') AS B_EMP_NO
     , NVL(B.EMP_NM, '(NULL)') AS B_EMP_NM
     , NVL(B.DEPT_CD, '(NULL)') AS B_DEPT_NO
FROM TB_DEPT_6_1_10 A, TB_EMP_6_1_10 B
WHERE A.DEPT_CD(+) = B.DEPT_CD
;

--RIGHT OUTER JOIN - ANSI METHOD
SELECT NVL(A.DEPT_CD, '(NULL)') AS A_DEPT_CD
    , NVL(A.DEPT_NM, '(NULL)') AS A_DEPT_NM
    , NVL(B.EMP_NO, '(NULL)') AS B_EMP_NO
    , NVL(B.EMP_NM, '(NULL)') AS B_EMP_NM
    , NVL(B.DEPT_CD, '(NULL)') AS B_DEPT_CD
FROM TB_DEPT_6_1_10 A RIGHT OUTER JOIN TB_EMP_6_1_10 B
ON (A.DEPT_CD = B.DEPT_CD)
ORDER BY A.DEPT_CD
;

--FULL OUTER JOIN - ANSI METHOD ONLY EXIST
SELECT NVL(A.DEPT_CD, '(NULL)') AS A_DEPT_CD
     , NVL(A.DEPT_NM, '(NULL)') AS A_DEPT_NM
     , NVL(B.EMP_NO, '(NULL)') AS B_EMP_NO
     , NVL(B.EMP_NM, '(NULL)') AS B_EMP_NM
     , NVL(B.DEPT_CD, '(NULL)') AS B_DEPT_CD
FROM TB_DEPT_6_1_10 A FULL OUTER JOIN TB_EMP_6_1_10 B
  ON (A.DEPT_CD = B.DEPT_CD)
;

--CROSS JOIN
