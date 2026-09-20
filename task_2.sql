CREATE MATERIALIZED VIEW cafe.avg_check_yearly_change AS
WITH yearly AS (
    SELECT
        EXTRACT(YEAR FROM s.date)::int AS year,
        r.restaurant_uuid,
        r.cafe_name,
        r.type,
        AVG(s.avg_check) AS avg_check
    FROM cafe.sales s
    JOIN cafe.restaurants r USING (restaurant_uuid)
    WHERE EXTRACT(YEAR FROM s.date) <> 2023
    GROUP BY EXTRACT(YEAR FROM s.date), r.restaurant_uuid, r.cafe_name, r.type
),
with_prev AS (
    SELECT
        year,
        cafe_name,
        type,
        avg_check,
        LAG(avg_check) OVER (PARTITION BY restaurant_uuid ORDER BY year) AS prev_avg_check
    FROM yearly
)
SELECT
    year,
    cafe_name,
    type,
    ROUND(avg_check, 2)      AS avg_check_current_year,
    ROUND(prev_avg_check, 2) AS avg_check_previous_year,
    ROUND((avg_check - prev_avg_check) / prev_avg_check * 100, 2) AS change_percent
FROM with_prev
ORDER BY cafe_name, year;
