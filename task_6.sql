BEGIN;

-- Шаг 1. Блокируем строки заведений, у которых есть капучино.
SELECT restaurant_uuid
FROM cafe.restaurants
WHERE type = 'coffee_shop'
  AND menu #> '{Кофе,Капучино}' IS NOT NULL
ORDER BY restaurant_uuid
FOR UPDATE;

-- Шаг 2. Поднимаем цену капучино на 20%.
UPDATE cafe.restaurants
SET menu = jsonb_set(
        menu,
        '{Кофе,Капучино}',
        to_jsonb(ROUND((menu #>> '{Кофе,Капучино}')::numeric * 1.2, 2))
    )
WHERE type = 'coffee_shop'
  AND menu #> '{Кофе,Капучино}' IS NOT NULL;
COMMIT;
