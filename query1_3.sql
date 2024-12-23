.mode table
.header on

DROP VIEW VBOOK_LOAN_INFO;

CREATE VIEW IF NOT EXISTS VBOOK_LOAN_INFO
AS SELECT BL.CARD_NO, 
		  BR.NAME AS BORROWER_NAME,
		  BL.DATE_OUT,
		  BL.DUE_DATE,
		  BL.RETURNED_DATE, 

		  CASE 
			 WHEN BL.RETURNED_DATE IS NULL
			 THEN JULIANDAY('NOW') - JULIANDAY(BL.DATE_OUT)

			 ELSE JULIANDAY(BL.RETURNED_DATE) - JULIANDAY(BL.DATE_OUT)
			END 
			AS TOTAL_DAYS,

		  B.TITLE AS BOOK_TITLE,

		  CASE 
			 WHEN BL.RETURNED_DATE IS NULL
			 THEN JULIANDAY('NOW') - JULIANDAY(BL.DUE_DATE)

			 WHEN JULIANDAY(BL.RETURNED_DATE) > JULIANDAY(BL.DUE_DATE)
			 THEN JULIANDAY(BL.RETURNED_DATE) - JULIANDAY(BL.DUE_DATE)

			 ELSE 0
			 END 
			 AS LATE_DAYS,

		  BL.BRANCH_ID,

		  CASE 
		  	WHEN BL.LATE = 1
		  	THEN (JULIANDAY(BL.RETURNED_DATE) - JULIANDAY(BL.DUE_DATE))* LB.LATE_FEE

		  	ELSE 0
		  	END 
		  	AS LATE_FEE_BALANCE

FROM BOOK B NATURAL JOIN BOOK_LOANS BL 
NATURAL JOIN BORROWER BR
NATURAL JOIN LIBRARY_BRANCH LB;

