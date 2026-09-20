SELECT
    r.cafe_name,
    COUNT(*) AS manager_changes
FROM cafe.restaurant_manager_work_dates w
JOIN cafe.restaurants r USING (restaurant_uuid)
GROUP BY r.restaurant_uuid, r.cafe_name
ORDER BY manager_changes DESC
LIMIT 3;
