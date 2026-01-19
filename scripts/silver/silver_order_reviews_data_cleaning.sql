-- check for null or blank review score(all reviews must have a score)
SELECT review_score
FROM silver.ord_order_reviews
WHERE review_score IS NULL;
-- no nulls found.

-- check if review answer date is greater than review creation date.
SELECT *
FROM (
	SELECT *, CASE 
	WHEN DATEDIFF(review_answer_timestamp, review_creation_date) >=0 OR
		YEAR(TIMEDIFF(review_answer_timestamp, review_creation_date)) >=0 OR
        MONTH(TIMEDIFF(review_answer_timestamp, review_creation_date)) >=0 OR
        DAY(TIMEDIFF(review_answer_timestamp, review_creation_date)) >=0 THEN 'correct'
        ELSE 'incorrect'
END AS date_interval
FROM silver.ord_order_reviews
) determine_table
WHERE date_interval != 'correct';

-- clean irrelevant dates(0000-00)
UPDATE silver.ord_order_reviews
SET
    review_creation_date = CASE
        WHEN 0 IN (
            YEAR(review_creation_date),
            MONTH(review_creation_date),
            DAY(review_creation_date)
        )
        THEN NULL
        ELSE review_creation_date
    END,

    review_answer_timestamp = CASE
        WHEN 0 IN (
            YEAR(review_answer_timestamp),
            MONTH(review_answer_timestamp),
            DAY(review_answer_timestamp)
        )
        THEN NULL
        ELSE review_answer_timestamp
    END
WHERE
    0 IN (
        YEAR(review_creation_date),
        MONTH(review_creation_date),
        DAY(review_creation_date),
        YEAR(review_answer_timestamp),
        MONTH(review_answer_timestamp),
        DAY(review_answer_timestamp)
    );