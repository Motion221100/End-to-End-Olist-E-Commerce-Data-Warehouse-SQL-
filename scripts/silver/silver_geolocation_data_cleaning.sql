-- GEOLOCATION CLEANSING AND STANDARDIZATION.
-- search for duplicate geo_zipcode_prefix
SELECT *
FROM (
	SELECT geo_zipcode_prefix, ROW_NUMBER() OVER(PARTITION BY geo_zipcode_prefix) dupl_number
    FROM silver.geo_geolocation
) dupl_zipcode
WHERE dupl_number > 1;
-- duplicate geozipcode prefixes found for every, but each represent a unique coordinate. longitude and latitude columns are redundant.

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
	SELECT geo_longitude, ROW_NUMBER() OVER(PARTITION BY geo_longitude) AS duplicates
    FROM silver.geo_geolocation
    GROUP BY geo_longitude
) dupl_geo_lat
WHERE duplicates > 1;

-- standardize the geo_city column(genAI generated code)
DELIMITER //
CREATE FUNCTION normalize_city_name(city VARCHAR(255))
RETURNS VARCHAR(255) DETERMINISTIC
BEGIN
    SET city = LOWER(TRIM(city));
    
    -- Remove/replace common Portuguese/Brazilian diacritics
    SET city = REPLACE(city, 'ã', 'a');
    SET city = REPLACE(city, 'á', 'a');
    SET city = REPLACE(city, 'â', 'a');
    SET city = REPLACE(city, 'à', 'a');
    SET city = REPLACE(city, 'ä', 'a');
    SET city = REPLACE(city, 'é', 'e');
    SET city = REPLACE(city, 'ê', 'e');
    SET city = REPLACE(city, 'è', 'e');
    SET city = REPLACE(city, 'ë', 'e');
    SET city = REPLACE(city, 'í', 'i');
    SET city = REPLACE(city, 'î', 'i');
    SET city = REPLACE(city, 'ì', 'i');
    SET city = REPLACE(city, 'ï', 'i');
    SET city = REPLACE(city, 'õ', 'o');
    SET city = REPLACE(city, 'ó', 'o');
    SET city = REPLACE(city, 'ô', 'o');
    SET city = REPLACE(city, 'ò', 'o');
    SET city = REPLACE(city, 'ö', 'o');
    SET city = REPLACE(city, 'ú', 'u');
    SET city = REPLACE(city, 'û', 'u');
    SET city = REPLACE(city, 'ù', 'u');
    SET city = REPLACE(city, 'ü', 'u');
    SET city = REPLACE(city, 'ç', 'c');
    SET city = REPLACE(city, 'ñ', 'n');
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
   
SELECT 
    geo_city
FROM silver.geo_geolocation
GROUP BY geo_city
ORDER BY geo_city asc;
