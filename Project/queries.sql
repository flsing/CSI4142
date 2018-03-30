DELETE FROM "date_dimension";
Delete FROM "disaster_dimension";
Delete FROM "location_dimension";
Delete FROM "disaster_fact";

COPY "placeholder"("event_category","event_group", "event_subgroup", "event_type", "place", "event_start_date", "comments", "fatalities", "injured", "evacuated", "estimated_total_cost", "normalized_total_cost", "event_date_end", "federal_dfaa_payment", "provincial_dfaa_payment", "provincial_deparment_payment", "municipal_costs", "ogd_cost", "insurance", "ngo_payment", "utility_people_affected","magnitude")
FROM '/Users/FLSingerman/Documents/Ottawa_U/Year_4_2017_18/Winter/Data_Science/Project/CanadianDisasterDatabase.xlsx' DELIMITER '\t' CSV HEADER;

Insert into "Location"(city,state,"location-key")
Select "Location", "Province", "id"
FROM placeholder;

Insert into "Shape"("shape-name",summary,"shape-key")
Select "Shape", "Description", "id" 
FROM placeholder;

Insert into "Event-Date"(date,week,month,year,weekend,"event-date-key")
Select "EventDate", EXTRACT(week FROM "EventDate") as week, EXTRACT(MONTH FROM "EventDate") as Month, EXTRACT(YEAR FROM "EventDate") as Year,
	CASE 
	WHEN to_char("EventDate", 'D') = '7' THEN 'y'
	WHEN to_char("EventDate", 'D') = '1' then 'y'
	ELSE 'n' 
	END, 
	"id"
FROM placeholder;

Insert into "Reported-Date"(date,week,month,year,weekend,"reported-date-key")
Select "DatePosted", EXTRACT(week FROM "DatePosted") as week, EXTRACT(MONTH FROM "DatePosted") as Month, EXTRACT(YEAR FROM "DatePosted") as Year,
	CASE 
	WHEN to_char("DatePosted", 'D') = '7' THEN 'y'
	WHEN to_char("DatePosted", 'D') = '1' then 'y'
	ELSE 'n' 
	END,
	"id"
FROM placeholder;

Insert into "UFO-fact"("event-day-key","location-key","shape-key","reported-date-key","duration")
Select e."event-date-key" , l."location-key", s."shape-key", r."reported-date-key", u."Duration"
FROM "Location" l, "Shape" s, "Reported-Date" r, "Event-Date" e, "ufo" u
WHERE e."event-date-key" = u."id" and u."id" = l."location-key" and u."id" = r."reported-date-key" and u."id" = s."shape-key";
