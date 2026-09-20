WITH pizza_counts AS (
    SELECT
        cafe_name,
        (SELECT COUNT(*) FROM jsonb_object_keys(menu -> 'Пицца')) AS pizza_count
    FROM cafe.restaurants
    WHERE type = 'pizzeria'
)
SELECT cafe_name, pizza_count
FROM pizza_counts
WHERE pizza_count = (SELECT MAX(pizza_count) FROM pizza_counts)
ORDER BY cafe_name;
