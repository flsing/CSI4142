DELETE FROM "ufo";
Delete FROM "Location";
Delete FROM "Shape";
Delete FROM "Event-Date";
Delete FROM "Reported-Date";
Delete FROM "UFO-fact";

COPY "ufo"("EventDate","Location", "Province", "Shape", "Duration", "Description", "DatePosted")
FROM '/Users/FLSingerman/Documents/Ottawa_U/Year_4_2017_18/Winter/Data_Science/Assignments/FINN.csv' DELIMITER ',' CSV HEADER;

Insert into "Location"(city,state,"location-key")
Select "Location", "Province", "id"
FROM UFO;

Insert into "Shape"("shape-name",summary,"shape-key")
Select "Shape", "Description", "id" 
FROM UFO;

Insert into "Event-Date"(date,week,month,year,weekend,"event-date-key")
Select "EventDate", EXTRACT(week FROM "EventDate") as week, EXTRACT(MONTH FROM "EventDate") as Month, EXTRACT(YEAR FROM "EventDate") as Year,
	CASE 
	WHEN to_char("EventDate", 'D') = '7' THEN 'y'
	WHEN to_char("EventDate", 'D') = '1' then 'y'
	ELSE 'n' 
	END, 
	"id"
FROM UFO;

Insert into "Reported-Date"(date,week,month,year,weekend,"reported-date-key")
Select "DatePosted", EXTRACT(week FROM "DatePosted") as week, EXTRACT(MONTH FROM "DatePosted") as Month, EXTRACT(YEAR FROM "DatePosted") as Year,
	CASE 
	WHEN to_char("DatePosted", 'D') = '7' THEN 'y'
	WHEN to_char("DatePosted", 'D') = '1' then 'y'
	ELSE 'n' 
	END,
	"id"
FROM UFO;

Insert into "UFO-fact"("event-day-key","location-key","shape-key","reported-date-key","duration")
Select e."event-date-key" , l."location-key", s."shape-key", r."reported-date-key", u."Duration"
FROM "Location" l, "Shape" s, "Reported-Date" r, "Event-Date" e, "ufo" u
WHERE e."event-date-key" = u."id" and u."id" = l."location-key" and u."id" = r."reported-date-key" and u."id" = s."shape-key";

--Q11
Select month, count("month") 
FROM "Event-Date"
GROUP BY Month Order BY Month;

--Q12

SELECT e.month,  l.state, count(e.month)
FROM "Event-Date" e, "Location" l, "UFO-fact" u
WHERE (e."event-date-key" = u."event-day-key") AND  (l."location-key" = u."location-key" )
GROUP BY e.month, l.state Order BY e.month, l.state;

--Q13 

Select  s."shape-name", AVG(u."duration") as avg_score
FROM "Shape" s, "UFO-fact" u
WHERE s."shape-key" = u."shape-key"
GROUP BY s."shape-name"  ORDER BY avg_score desc
LIMIT 5 ;

--Q14

SELECT s."shape-name", AVG(u."duration") as avg_duration, l."state", MAX(u."duration") as max_duration
FROM "Shape" s, "UFO-fact" u, "Location" l
WHERE s."shape-key" = u."shape-key" AND l."location-key" = u."location-key"
GROUP BY l."state", s."shape-name"  ORDER BY max_duration desc;

--Q15 

SELECT l."state", s."shape-name", COUNT(s."shape-name")
FROM "Location" l, "Event-Date" e, "Shape" s, "UFO-fact" u
WHERE (l."state" = 'CA' OR l."state" = 'FL') AND s."shape-key" = u."shape-key" AND l."location-key" = u."location-key" AND e."event-date-key" = u."event-day-key" AND e."weekend" = 'y'
GROUP BY s."shape-name", l."state" ORDER BY s."shape-name", l."state";