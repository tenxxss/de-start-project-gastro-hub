CREATE SCHEMA cafe;
CREATE TYPE cafe.restaurant_type AS ENUM ('coffee_shop', 'restaurant', 'bar', 'pizzeria');

CREATE TABLE cafe.restaurants (
    restaurant_uuid uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    cafe_name varchar NOT NULL,
    type cafe.restaurant_type NOT NULL,
    menu jsonb
);

CREATE TABLE cafe.managers (
    manager_uuid uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    manager varchar NOT NULL,
    manager_phone varchar
);

CREATE TABLE cafe.restaurant_manager_work_dates (
    restaurant_uuid uuid NOT NULL REFERENCES cafe.restaurants (restaurant_uuid),
    manager_uuid uuid NOT NULL REFERENCES cafe.managers (manager_uuid),
    start_date date NOT NULL,
    end_date date NOT NULL,
    PRIMARY KEY (restaurant_uuid, manager_uuid)
);

CREATE TABLE cafe.sales (
    date date NOT NULL,
    restaurant_uuid uuid NOT NULL REFERENCES cafe.restaurants (restaurant_uuid),
    avg_check numeric(6, 2),
    PRIMARY KEY (date, restaurant_uuid)
);

-- 1. Рестораны
INSERT INTO cafe.restaurants (cafe_name, type, menu)
SELECT s.cafe_name, s.type::cafe.restaurant_type, m.menu
FROM (SELECT DISTINCT cafe_name, type FROM raw_data.sales) s
LEFT JOIN raw_data.menu m USING (cafe_name);

-- 2. Менеджеры
INSERT INTO cafe.managers (manager, manager_phone)
SELECT DISTINCT manager, manager_phone
FROM raw_data.sales;

-- 3. Периоды работы менеджеров в ресторанах
INSERT INTO cafe.restaurant_manager_work_dates (restaurant_uuid, manager_uuid, start_date, end_date)
SELECT r.restaurant_uuid, m.manager_uuid, MIN(s.report_date), MAX(s.report_date)
FROM raw_data.sales s
JOIN cafe.restaurants r ON r.cafe_name = s.cafe_name
JOIN cafe.managers m ON m.manager = s.manager
GROUP BY r.restaurant_uuid, m.manager_uuid;

-- 4. Продажи
INSERT INTO cafe.sales (date, restaurant_uuid, avg_check)
SELECT s.report_date, r.restaurant_uuid, s.avg_check
FROM raw_data.sales s
JOIN cafe.restaurants r ON r.cafe_name = s.cafe_name;

