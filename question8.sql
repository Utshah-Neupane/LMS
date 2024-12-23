.mode table
.header on

SELECT BK.TITLE, MAX(
	CAST(
		CASE 
			 WHEN BL.RETURNED_DATE IS NULL
			 THEN JULIANDAY('NOW') - JULIANDAY(BL.DATE_OUT)

			 ELSE JULIANDAY(BL.RETURNED_DATE) - JULIANDAY(BL.DATE_OUT)
		END
		AS INTEGER)
	)
	AS MAX_BORROWED_DAYS


FROM BOOK BK NATURAL JOIN BOOK_LOANS BL
GROUP BY BK.TITLE
ORDER BY MAX_BORROWED_DAYS DESC;



