-- search for seller_id duplicates
SELECT seller_id
FROM silver.selr_sellers
GROUP BY seller_id
HAVING COUNT(*) > 1
-- no duplicate ids

-- rectify seller city name errors
DELIMITER //
CREATE FUNCTION normalize_seller_city_name(city TEXT)
RETURNS TEXT DETERMINISTIC
BEGIN
    SET city = LOWER(TRIM(city));-- search for seller_id duplicates
SELECT seller_id
FROM silver.selr_sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;

-- rectify seller city name errors
DELIMITER //
CREATE FUNCTION normalize_seller_city_name(city TEXT)
RETURNS TEXT DETERMINISTIC
BEGIN
    SET city = LOWER(TRIM(city));
    SET city = REPLACE(city, '4482255', 'N/A');
    SET city = REPLACE(city, 'angra dos reis rj', 'angra dos reis');
    SET city = REPLACE(city, 'ararangua', 'araranquara');
    SET city = REPLACE(city, 'balenario camboriu', 'balneario camboriu');
    SET city = REPLACE(city, 'belo horizont', 'belo horizonte');
    SET city = REPLACE(city, 'cascavael', 'cascavel');
    SET city = REPLACE(city, '  ', ' ');
    SET city = REPLACE(city, 'imbituba', 'imbituva');
    SET city = REPLACE(city, 'mogi das cruses', 'mogi das cruzes');
    SET city = REPLACE(city, 'ribeirao pretp', 'ribeirao preto');
    SET city = REPLACE(city, 'riberao preto', 'ribeirao preto');
    SET city = REPLACE(city, 'rio de janeiro io de janeiro', 'rio de janeiro');	
    SET city = REPLACE(city, 'rio de janeiro, rio de janeiro, brasil', 'rio de janeiro');
    SET city = REPLACE(city, "santa barbara d´oeste", "santa barbara d'oeste");
    SET city = REPLACE(city, 'santa barbara d oeste', "santa barbara d'oeste");
    SET city = REPLACE(city, 'sao bernardo do capo', 'sao bernardo do campo');
    SET city = REPLACE(city, 'sao jose do rio pret', 'sao jose do rio preto');
    SET city = REPLACE(city, 'sao jose dos pinhas', 'sao jose dos pinhais');
    SET city = REPLACE(city, 'sao miguel do oeste', "sao miguel d'oeste");
    SET city = REPLACE(city, 'sao paulo - sp', 'sao paulo sp');
    SET city = REPLACE(city, 'sao paulo / sao paulo', 'sao paulo');
    SET city = REPLACE(city, 'sao paulop', 'sao paulo');
    SET city = REPLACE(city, 'sao pauo', 'sao paulo');
    SET city = REPLACE(city, '@', ' ');
    RETURN city;
END //
DELIMITER ;

UPDATE silver.selr_sellers
SET seller_city = TRIM(normalize_seller_city_name(seller_city));

-- search for blanks and null
SELECT * 
FROM silver.selr_sellers
WHERE "" IN (seller_id, seller_zipcode_prefix, seller_city, seller_state) OR NULL IN (seller_id, seller_zipcode_prefix, seller_city, seller_state);