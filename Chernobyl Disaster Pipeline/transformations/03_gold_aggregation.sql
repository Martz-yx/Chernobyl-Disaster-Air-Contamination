CREATE MATERIALIZED VIEW max_contamination_by_city AS
SELECT
    City,
    Country,
    lattitude,
    longitude,
    max(iodine_131) as max_Iodine_131,
    max(caesium_134) as max_Caesium_134,
    max(caesium_137) as max_Caesium_137,
    -- General index of radiation contamination as the sum of max values of the isotopes
    (max(iodine_131) + max(caesium_134) + max(caesium_137)) as general_radiation_index
FROM Chernoclean
GROUP BY City, Country, lattitude, longitude;

CREATE MATERIALIZED VIEW avg_contamination_by_country AS
SELECT
    Country,
    Date,
    avg(iodine_131) as avg_Iodine_131,
    avg(caesium_134)as avg_Caesium_134,
    avg(caesium_137)as avg_Caesium_137
FROM Chernoclean
GROUP BY  Country, Date;


CREATE OR REPLACE MATERIALIZED VIEW contamination_expantion AS
WITH all_dates AS (
    SELECT DISTINCT Date FROM Chernoclean
    UNION
    SELECT DISTINCT date_add(Date, -n) AS Date
    FROM Chernoclean
    LATERAL VIEW posexplode(array(1,2,3,4,5)) AS n, _
),
city_info AS (
    SELECT DISTINCT City, Country, lattitude, longitude FROM Chernoclean
),
city_dates AS (
    SELECT c.City, c.Country, c.lattitude, c.longitude, d.Date
    FROM city_info c
    CROSS JOIN all_dates d
),
contamination AS (
    SELECT
        cd.City,
        cd.Country,
        cd.lattitude,
        cd.longitude,
        cd.Date,
        max(s.iodine_131) as max_Iodine_131,
        max(s.caesium_134) as max_Caesium_134,
        max(s.caesium_137) as max_Caesium_137
    FROM city_dates cd
    LEFT JOIN Chernoclean s
        ON cd.City = s.City
        AND cd.Country = s.Country
        AND cd.lattitude = s.lattitude
        AND cd.longitude = s.longitude
        AND cd.Date = s.Date
    GROUP BY cd.City, cd.Country, cd.lattitude, cd.longitude, cd.Date
),
weather_agg AS (
    SELECT
        Country, City, Date, 
        SUM(Precipitation) as Precipitation,
        AVG(TAVG) as TAVG
    FROM weatherclean
    GROUP BY Country, City, Date
)
SELECT 
    c.*,
    w.Precipitation,
    w.TAVG
FROM contamination c
LEFT JOIN weather_agg w
    ON c.Country = w.Country
    AND c.City = w.City
    AND c.Date = w.Date;


CREATE MATERIALIZED VIEW Rainfall_by_City AS
SELECT
    *
FROM weatherclean