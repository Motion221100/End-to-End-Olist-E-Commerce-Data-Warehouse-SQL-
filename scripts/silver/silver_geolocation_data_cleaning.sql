-- GEOLOCATION CLEANSING AND STANDARDIZATION.
-- search for duplicate geo_zipcode_prefix
SELECT *
FROM (
    SELECT geo_zipcode_prefix, ROW_NUMBER() OVER(PARTITION BY geo_zipcode_prefix) dupl_number
    FROM silver.geo_geolocation
) dupl_zipcode
WHERE dupl_number > 1;

-- search for duplicate longitude and latitude.
SELECT *
FROM (
	SELECT geo_latitude, ROW_NUMBER() OVER(PARTITION BY geo_latitude) AS duplicates
    FROM silver.geo_geolocation
    GROUP BY geo_latitude
) dupl_geo_lat
WHERE duplicates > 1;
-- no duplicate latitudes

-- search for duplicate longitudes
SELECT *
FROM (
    SELECT geo_latitude, ROW_NUMBER() OVER(PARTITION BY geo_latitude) AS duplicates
    FROM silver.geo_geolocation
    GROUP BY geo_latitude
) dupl_geo_lat
WHERE duplicates > 1;

-- standardize the geo_city column
DELIMITER //
CREATE FUNCTION normalize_city_name(city VARCHAR(255))
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
    SET city = LOWER(TRIM(city));
    SET city = REPLACE(city, '...', '');
    SET city = REPLACE(city, '*', '');
    SET city = REPLACE(city, '´t', 't');
    SET city = REPLACE(city, '4º', '');
    SET city = REPLACE(city, '4o.', '');
    -- Clean up multiple spaces (very rare but safe)
    WHILE LOCATE('  ', city) > 0 DO
        SET city = REPLACE(city, '  ', ' ');
    END WHILE;
    RETURN city;
END //
DELIMITER ;

UPDATE silver.geo_geolocation
SET geo_city = TRIM(normalize_city_name(geo_city));

SELECT DISTINCT geo_city
FROM silver.geo_geolocation
WHERE geo_city REGEXP '[A-ZÀÁÂÃÄÇÉÊÈËÍÎÌÏÕÓÔÒÖÚÛÙÜÑ]'
   OR geo_city != LOWER(geo_city)
   OR geo_city REGEXP '[ãáâàäéêèëíîìïõóôòöúûùüçñ]';
   
SELECT geo_city
FROM silver.geo_geolocation
GROUP BY geo_city
ORDER BY geo_city ASC;
