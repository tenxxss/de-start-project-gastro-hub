BEGIN;

-- Шаг 1. Блокируем таблицу на время изменений.
LOCK TABLE cafe.managers IN SHARE ROW EXCLUSIVE MODE;

-- Шаг 2. Превращаем столбец с телефоном в массив.
ALTER TABLE cafe.managers
    ALTER COLUMN manager_phone TYPE varchar[]
    USING ARRAY[manager_phone];

-- Шаг 3. Добавляем новый номер первым элементом массива.
-- Порядковый номер менеджера определяется по алфавиту (ORDER BY manager)
-- и начинается со 100: ROW_NUMBER() начинается с 1, поэтому прибавляем 99.
WITH numbered AS (
    SELECT
        manager_uuid,
        ROW_NUMBER() OVER (ORDER BY manager) + 99 AS n
    FROM cafe.managers
)
UPDATE cafe.managers m
SET manager_phone = ARRAY['8-800-2500-' || numbered.n::text] || m.manager_phone
FROM numbered
WHERE m.manager_uuid = numbered.manager_uuid;

COMMIT;
