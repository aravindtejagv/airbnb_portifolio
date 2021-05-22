--max price of listing when available  
select distinct listing_id,available,
MAX(case when price IS NULL THEN '0'
ELSE price
end ) max_price
from protifolio_project.dbo.calendar
where available like 't'
group by listing_id,available 
order by listing_id;

-- max price of listing when available on date 
 
select distinct listing_id,available,date,
MAX(case when price IS NULL THEN '0'
ELSE price
end ) max_price
from protifolio_project.dbo.calendar
where available like 't'
group by listing_id,available,date
order by max_price desc;

--created CTE to get results 

WITH CTE_TABLE (id,host_id,host_name,host_location,
host_is_superhost,host_identity_verified,
room_type,latitude,longitude,
property_type,
date,
available,
price,
number_of_reviews,
review_scores_rating,
guests_included,
extra_people,
reviewer_id,
reviewer_name) AS(
select lst.id,lst.host_id,lst.host_name,ld.host_location,
ld.host_is_superhost,ld.host_identity_verified,
ld.room_type,ld.latitude,ld.longitude,
ld.property_type,
cal.date,
cal.available,
cal.price,
ld.number_of_reviews,
ld.review_scores_rating,
ld.guests_included,
ld.extra_people,
rd.reviewer_id,
rd.reviewer_name
from protifolio_project..listings lst 
join protifolio_project..calendar cal on lst.id=cal.listing_id
join protifolio_project..reviews_details rd on lst.id=rd.listing_id
join protifolio_project..listings_details ld on lst.id=ld.id
where cal.available in('t','T') and host_identity_verified in ('t','T') 
and host_is_superhost in ('t','T')
)

SELECT id,property_type,host_location,room_type,latitude,longitude,
min(price) min_price,max(review_scores_rating) max_rating,COUNT(number_of_reviews) no_of_revs FROM CTE_TABLE
group by id,property_type,host_location,room_type,latitude,longitude
order by max_rating desc