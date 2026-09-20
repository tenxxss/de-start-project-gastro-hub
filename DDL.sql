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
