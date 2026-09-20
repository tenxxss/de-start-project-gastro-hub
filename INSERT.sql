INSERT INTO cafe.restaurants (cafe_name, type, menu)
SELECT s.cafe_name, s.type::cafe.restaurant_type, m.menu
FROM (SELECT DISTINCT cafe_name, type FROM raw_data.sales) s
LEFT JOIN raw_data.menu m USING (cafe_name);

INSERT INTO cafe.managers (manager, manager_phone)
SELECT DISTINCT manager, manager_phone
FROM raw_data.sales;

INSERT INTO cafe.restaurant_manager_work_dates (restaurant_uuid, manager_uuid, start_date, end_date)
SELECT r.restaurant_uuid, m.manager_uuid, MIN(s.report_date), MAX(s.report_date)
FROM raw_data.sales s
JOIN cafe.restaurants r ON r.cafe_name = s.cafe_name
JOIN cafe.managers m ON m.manager = s.manager
GROUP BY r.restaurant_uuid, m.manager_uuid;

INSERT INTO cafe.sales (date, restaurant_uuid, avg_check)
SELECT s.report_date, r.restaurant_uuid, s.avg_check
FROM raw_data.sales s
JOIN cafe.restaurants r ON r.cafe_name = s.cafe_name;
