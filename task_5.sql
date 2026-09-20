WITH pizzas AS (
    SELECT
        restaurant_uuid,
        cafe_name,
        menu -> 'Пицца' AS pizza_menu,
        jsonb_object_keys(menu -> 'Пицца') AS pizza_name
    FROM cafe.restaurants
    WHERE type = 'pizzeria'
),
priced AS (
    SELECT
        restaurant_uuid,
        cafe_name,
        pizza_name,
        (pizza_menu ->> pizza_name)::numeric AS price
    FROM pizzas
),
ranked AS (
    SELECT
        cafe_name,
        pizza_name,
        price,
        RANK() OVER (PARTITION BY restaurant_uuid ORDER BY price DESC) AS rnk
    FROM priced
)
SELECT
    cafe_name,
    'Пицца' AS dish_type,
    pizza_name,
    price
FROM ranked
WHERE rnk = 1
ORDER BY cafe_name;
