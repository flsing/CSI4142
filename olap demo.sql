-- 1
select count(*), name, state, year
from ufo_facts f inner join shapes s on s.id = f.shape_id inner join locations l on l.id = f.location_id inner join reported_dates d on d.id = f.reported_date_id
where name like 'circle' and state like 'ON' and year = 2013
group by name, state, year;

-- 2
select count(*), state
from ufo_facts f inner join shapes s on s.id = f.shape_id inner join locations l on l.id = f.location_id inner join reported_dates d on d.id = f.reported_date_id
where ((name = 'circle' and state = 'ON') or (name = 'sphere' and state = 'QC')) and year = 2014
group by state;

-- 3
SELECT city
from ufo_facts f inner join shapes s on s.id = f.shape_id inner join locations l on l.id = f.location_id inner join reported_dates d on d.id = f.reported_date_id
where country = 'USA' and name = 'sphere' and date_part('dow', d.reported_date) in (0, 5, 6)
group by city
order by count(*) desc
limit 5;

-- 4
select count(*), year, country
from ufo_facts f inner join shapes s on s.id = f.shape_id inner join reported_dates d on d.id = f.reported_date_id  inner join locations l on l.id = f.location_id
where name = 'light' and year > 2010 and region like 'North America'
group by grouping sets ((year, country), (country), (year))
order by country, year, 1;

-- 5
select count(*), year
from ufo_facts f inner join shapes s on s.id = f.shape_id inner join reported_dates d on d.id = f.reported_date_id  inner join locations l on l.id = f.location_id
group by year
order by year;