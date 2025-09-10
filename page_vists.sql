-- 1. Count how many unique marketing campaigns CoolTShirts runs
SELECT COUNT(DISTINCT utm_campaign)
FROM page_visits;

-- 2. Count how many unique traffic sources are used (e.g., google, facebook, email, etc.)
SELECT COUNT(DISTINCT utm_source)
FROM page_visits;

-- 3. Show the relationship between campaigns and their traffic sources
-- (which campaigns run on which platforms/sources)
SELECT DISTINCT utm_campaign, utm_source
FROM page_visits;

-- 4. List all distinct pages on the CoolTShirts website
-- (helps us understand the funnel: landing_page → shopping_cart → checkout → purchase)
SELECT DISTINCT page_name 
FROM page_visits;

-- 5. Attribute FIRST TOUCH (initial campaign that brought a user to the site)
WITH first_touch AS (
    SELECT user_id,
           MIN(timestamp) AS first_touch_at   
    FROM page_visits
    GROUP BY user_id
)
SELECT ft.user_id,
       ft.first_touch_at,
       pv.utm_source,
       pv.utm_campaign,
       COUNT(utm_campaign)                   
FROM first_touch ft
JOIN page_visits pv
     ON ft.user_id = pv.user_id
    AND ft.first_touch_at = pv.timestamp
GROUP BY utm_campaign
ORDER BY 5 DESC;         


-- 6. Attribute LAST TOUCH (the campaign that led to the user’s final recorded visit)
WITH last_touch AS (
    SELECT user_id,
           MAX(timestamp) AS last_touch_at    
    FROM page_visits
    GROUP BY user_id
)
SELECT lt.user_id,
       lt.last_touch_at,
       pv.utm_source,
       pv.utm_campaign,
       COUNT(utm_campaign)                   
FROM last_touch lt
JOIN page_visits pv
     ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY utm_campaign
ORDER BY 5 DESC;                


-- 7. Count how many unique visitors actually completed a purchase
SELECT COUNT(DISTINCT user_id)
FROM page_visits
WHERE page_name = '4 - purchase';


-- 8. Attribute LAST TOUCH on the PURCHASE page
-- (which campaigns were responsible for conversions)
WITH last_touch AS (
    SELECT user_id,
           MAX(timestamp) AS last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'         
    GROUP BY user_id
)
SELECT lt.user_id,
       lt.last_touch_at,
       pv.utm_source,
       pv.utm_campaign,
       COUNT(utm_campaign)                   
FROM last_touch lt
JOIN page_visits pv
     ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
GROUP BY utm_campaign
ORDER BY 5 DESC;                   
