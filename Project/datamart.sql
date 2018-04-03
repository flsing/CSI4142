Alter table cost_dimension
alter column normalized_total_cost type text,
alter column federal_payments type text,
alter column provincial_payments type text,
alter column  insurance_payments type text,
alter column  ngo_payments type text,
alter column  ogd_cost type text,
alter column  municipal_cost type text,
alter column  estimated_total_cost type text;

-- Deletion queried to restart db
DELETE FROM "cost_dimension";
Delete FROM "date_dimension";
Delete FROM "disaster_dimension";
Delete FROM "location_dimension";
Delete FROM "population_dimension";
Delete FROM "summary_dimension";
Delete FROM "disaster_fact";
Delete FROM "placeholder";

-- Insert into dimensions
Insert into cost_dimension(normalized_total_cost,federal_dfaa_payment,provincial_dfaa_payment,
provincial_department_payment,insurance_payments,ngo_payments, ogd_cost, municipal_cost, estimated_total_cost ) 
Select "normalized_total_cost", "federal_dfaa_payment", "provincial_dfaa_payment","provincial_department_payment",
"insurance", "ngo_payment", "ogd_cost", "municipal_costs","estimated_total_cost"
FROM placeholder;


Insert into date_dimension(day,month,year,weekend, season_canada)
Select EXTRACT(DAY FROM event_start_date) as day, EXTRACT(MONTH FROM event_start_date) as Month, EXTRACT(YEAR FROM event_start_date) as Year,
	CASE 
	WHEN to_char(event_start_date, 'D') = '7' THEN 'y'
	WHEN to_char(event_start_date, 'D') = '1' then 'y'
	ELSE 'n' 
	END,
	CASE
	WHEN to_char(event_start_date, 'MM') >= '01' AND to_char(event_start_date, 'MM') <= '03'  THEN 'Winter'
	WHEN to_char(event_start_date, 'MM') >= '04' AND to_char(event_start_date, 'MM') <= '06' THEN 'Spring'
	WHEN to_char(event_start_date, 'MM') >= '07' AND to_char(event_start_date, 'MM') <= '09' THEN 'Summer'
	WHEN to_char(event_start_date, 'MM') >= '10' AND to_char(event_start_date, 'MM') <= '12' THEN 'Fall'
	END
FROM placeholder;

Insert into disaster_dimension(disaster_type, disaster_group, disaster_subgroup, disaster_category,
 magnitude, utility_people_affected) 
Select event_type, event_group, event_subgroup, event_category,
 magnitude, utility_people_affected
FROM placeholder;

Insert into location_dimension(city, province, country, canada) 
Select city, province, country,
	CASE 
	WHEN country = 'CA' then 'y'
	ELSE 'n'
	END
FROM placeholder;

INSERT INTO summary_dimension(summary)
SELECT comments
FROM placeholder;


Insert into disaster_fact()
Select e."event-date-key" , l."location-key", s."shape-key", r."reported-date-key", u."Duration"
FROM "Location" l, "Shape" s, "Reported-Date" r, "Event-Date" e, "ufo" u
WHERE e."event-date-key" = u."id" and u."id" = l."location-key" and u."id" = r."reported-date-key" and u."id" = s."shape-key";
