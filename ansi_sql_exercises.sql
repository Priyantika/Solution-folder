
-- Exercise 1: User Upcoming Events
SELECT 
    u.user_id,
    u.full_name,
    e.event_id,
    e.title AS event_title,
    e.city,
    e.start_date,
    e.end_date
FROM Users u
JOIN Registrations r ON u.user_id = r.user_id
JOIN Events e ON r.event_id = e.event_id
WHERE e.status = 'upcoming'
  AND u.city = e.city
ORDER BY e.start_date;

-- Exercise 2: Top Rated Events
SELECT 
    e.event_id,
    e.title,
    AVG(f.rating) AS average_rating,
    COUNT(f.feedback_id) AS feedback_count
FROM Events e
JOIN Feedback f ON e.event_id = f.event_id
GROUP BY e.event_id, e.title
HAVING COUNT(f.feedback_id) >= 10
ORDER BY average_rating DESC;

-- Exercise 3: Inactive Users
SELECT 
    u.user_id,
    u.full_name
FROM Users u
LEFT JOIN Registrations r 
  ON u.user_id = r.user_id AND r.registration_date >= CURDATE() - INTERVAL 90 DAY
WHERE r.registration_id IS NULL;

-- Exercise 4: Peak Session Hours
SELECT 
    event_id,
    COUNT(*) AS session_count
FROM Sessions
WHERE TIME(start_time) BETWEEN '10:00:00' AND '12:00:00'
GROUP BY event_id;

-- Exercise 5: Most Active Cities
SELECT 
    city,
    COUNT(DISTINCT user_id) AS user_count
FROM Users u
JOIN Registrations r ON u.user_id = r.user_id
GROUP BY city
ORDER BY user_count DESC
LIMIT 5;

-- Exercise 6: Event Resource Summary
SELECT 
    event_id,
    SUM(resource_type = 'pdf') AS pdf_count,
    SUM(resource_type = 'image') AS image_count,
    SUM(resource_type = 'link') AS link_count
FROM Resources
GROUP BY event_id;

-- Exercise 7: Low Feedback Alerts
SELECT 
    u.user_id,
    u.full_name,
    e.title AS event_title,
    f.rating,
    f.comments
FROM Feedback f
JOIN Users u ON f.user_id = u.user_id
JOIN Events e ON f.event_id = e.event_id
WHERE f.rating < 3;

-- Exercise 8: Sessions per Upcoming Event
SELECT 
    e.event_id,
    e.title,
    COUNT(s.session_id) AS session_count
FROM Events e
LEFT JOIN Sessions s ON e.event_id = s.event_id
WHERE e.status = 'upcoming'
GROUP BY e.event_id, e.title;

-- Exercise 9: Organizer Event Summary
SELECT 
    u.user_id AS organizer_id,
    u.full_name,
    e.status,
    COUNT(e.event_id) AS event_count
FROM Users u
JOIN Events e ON u.user_id = e.organizer_id
GROUP BY u.user_id, u.full_name, e.status;

-- Exercise 10: Feedback Gap
SELECT 
    e.event_id,
    e.title
FROM Events e
JOIN Registrations r ON e.event_id = r.event_id
LEFT JOIN Feedback f ON e.event_id = f.event_id
WHERE f.feedback_id IS NULL
GROUP BY e.event_id, e.title;

-- Exercise 11: Daily New User Count
SELECT 
    registration_date,
    COUNT(*) AS user_count
FROM Users
WHERE registration_date >= CURDATE() - INTERVAL 7 DAY
GROUP BY registration_date;

-- Exercise 12: Event with Maximum Sessions
SELECT 
    e.event_id,
    e.title,
    COUNT(s.session_id) AS session_count
FROM Events e
JOIN Sessions s ON e.event_id = s.event_id
GROUP BY e.event_id, e.title
ORDER BY session_count DESC
LIMIT 1;

-- Exercise 13: Average Rating per City
SELECT 
    e.city,
    AVG(f.rating) AS avg_rating
FROM Events e
JOIN Feedback f ON e.event_id = f.event_id
GROUP BY e.city;

-- Exercise 14: Most Registered Events
SELECT 
    e.event_id,
    e.title,
    COUNT(r.registration_id) AS total_registrations
FROM Events e
JOIN Registrations r ON e.event_id = r.event_id
GROUP BY e.event_id, e.title
ORDER BY total_registrations DESC
LIMIT 3;

-- Exercise 15: Event Session Time Conflict
SELECT 
    s1.event_id,
    s1.session_id AS session_1,
    s2.session_id AS session_2
FROM Sessions s1
JOIN Sessions s2 
  ON s1.event_id = s2.event_id 
  AND s1.session_id < s2.session_id
  AND s1.start_time < s2.end_time 
  AND s2.start_time < s1.end_time;

-- Exercise 16: Unregistered Active Users
SELECT 
    user_id,
    full_name
FROM Users
WHERE registration_date >= CURDATE() - INTERVAL 30 DAY
  AND user_id NOT IN (
    SELECT user_id FROM Registrations
);

-- Exercise 17: Multi-Session Speakers
SELECT 
    speaker_name,
    COUNT(*) AS session_count
FROM Sessions
GROUP BY speaker_name
HAVING COUNT(*) > 1;

-- Exercise 18: Resource Availability Check
SELECT 
    e.event_id,
    e.title
FROM Events e
LEFT JOIN Resources r ON e.event_id = r.event_id
WHERE r.resource_id IS NULL;

-- Exercise 19: Completed Events with Feedback Summary
SELECT 
    e.event_id,
    e.title,
    COUNT(DISTINCT r.registration_id) AS total_registrations,
    AVG(f.rating) AS avg_rating
FROM Events e
LEFT JOIN Registrations r ON e.event_id = r.event_id
LEFT JOIN Feedback f ON e.event_id = f.event_id
WHERE e.status = 'completed'
GROUP BY e.event_id, e.title;

-- Exercise 20: User Engagement Index
SELECT 
    u.user_id,
    u.full_name,
    COUNT(DISTINCT r.event_id) AS events_attended,
    COUNT(DISTINCT f.feedback_id) AS feedback_given
FROM Users u
LEFT JOIN Registrations r ON u.user_id = r.user_id
LEFT JOIN Feedback f ON u.user_id = f.user_id
GROUP BY u.user_id, u.full_name;

-- Exercise 21: Top Feedback Providers
SELECT 
    u.user_id,
    u.full_name,
    COUNT(f.feedback_id) AS feedback_count
FROM Users u
JOIN Feedback f ON u.user_id = f.user_id
GROUP BY u.user_id, u.full_name
ORDER BY feedback_count DESC
LIMIT 5;

-- Exercise 22: Duplicate Registrations Check
SELECT 
    user_id,
    event_id,
    COUNT(*) AS reg_count
FROM Registrations
GROUP BY user_id, event_id
HAVING COUNT(*) > 1;

-- Exercise 23: Registration Trends
SELECT 
    DATE_FORMAT(registration_date, '%Y-%m') AS month,
    COUNT(*) AS registrations
FROM Registrations
WHERE registration_date >= CURDATE() - INTERVAL 12 MONTH
GROUP BY month
ORDER BY month;

-- Exercise 24: Average Session Duration per Event
SELECT 
    event_id,
    AVG(TIMESTAMPDIFF(MINUTE, start_time, end_time)) AS avg_duration_minutes
FROM Sessions
GROUP BY event_id;

-- Exercise 25: Events Without Sessions
SELECT 
    e.event_id,
    e.title
FROM Events e
LEFT JOIN Sessions s ON e.event_id = s.event_id
WHERE s.session_id IS NULL;
