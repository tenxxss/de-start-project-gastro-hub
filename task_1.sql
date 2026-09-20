CREATE VIEW cafe.top_3_restaurants_by_type AS
WITH avg_checks AS (
    SELECT
        r.cafe_name,
        r.type,
        AVG(s.avg_check) AS avg_check
    FROM cafe.sales s
    JOIN cafe.restaurants r USING (restaurant_uuid)
    GROUP BY r.restaurant_uuid, r.cafe_name, r.type
),
ranked AS (
    SELECT
        cafe_name,
        type,
        avg_check,
        ROW_NUMBER() OVER (PARTITION BY type ORDER BY avg_check DESC) AS rn
    FROM avg_checks
)
SELECT
    cafe_name,
    type,
    ROUND(avg_check, 2) AS avg_check
FROM ranked
WHERE rn <= 3
ORDER BY type, avg_check DESC;
