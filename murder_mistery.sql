-- 1.Initial Clues:
-- murder that occurred sometime on Jan 15, 2018 (20180115)
-- and that it took place in SQL City

SELECT *
FROM crime_scene_report
WHERE type="murder"
AND city="SQL City"
-- AND date="Jan.15, 2018"
AND date=20180115





-- 2. Security footage shows 2 witnesses
-- 1st - lives at the last house on "Northwestern Dr"
-- 2nd - Annabel, lives somewhere on "Franklin Ave"

SELECT *
FROM person
WHERE address_street_name="Northwestern Dr"
ORDER BY address_number DESC
LIMIT 1


-- 3. 1st witness is Morty Schapiro with id 14887


SELECT *
FROM person
WHERE address_street_name="Franklin Ave"
AND name LIKE "%Annabel%"
LIMIT 10


-- 4. 2nd witness is Annabel Miller with id 16371

SELECT *
FROM person
WHERE id IN (14887, 16371)
LIMIT 10

SELECT *
FROM interview
WHERE person_id IN (14887, 16371)
LIMIT 10

-- 5. Found some transcripts:
-- Morty: "Get Fit Now Gym" bag started with "48Z" - gold member
-- car with a plate that included "H42W"
-- Annabel: recognized the killer from her gym last week on January the 9th


SELECT *
FROM drivers_license
WHERE plate_number LIKE "%H42W%"
LIMIT 10


SELECT *
FROM drivers_license AS dl
INNER JOIN person AS p on dl.id = p.license_id
WHERE plate_number LIKE "%H42W%"
LIMIT 10


SELECT p.*, gf.*
FROM drivers_license AS dl
INNER JOIN person AS p on dl.id = p.license_id
INNER JOIN get_fit_now_member as gf on p.id = gf.person_id
WHERE plate_number LIKE "%H42W%"
LIMIT 10


SELECT p.*, gf.*
FROM drivers_license AS dl
INNER JOIN person AS p on dl.id = p.license_id
INNER JOIN get_fit_now_member as gf on p.id = gf.person_id
WHERE plate_number LIKE "%H42W%"
AND membership_status = "gold"
LIMIT 10


SELECT p.*, ci.*
FROM drivers_license AS dl
INNER JOIN person AS p on dl.id = p.license_id
INNER JOIN get_fit_now_member as gf on p.id = gf.person_id
INNER JOIN get_fit_now_check_in as ci on gf.id=ci.membership_id
WHERE plate_number LIKE "%H42W%"
AND membership_status = "gold"
LIMIT 10


SELECT p.*, ci.*
FROM drivers_license AS dl
INNER JOIN person AS p on dl.id = p.license_id
INNER JOIN get_fit_now_member as gf on p.id = gf.person_id
INNER JOIN get_fit_now_check_in as ci on gf.id=ci.membership_id
WHERE plate_number LIKE "%H42W%"
AND membership_status = "gold"
AND check_in_date = 20180109
LIMIT 10

-- 6. Let's see if the killer is Jeremy Bowers

INSERT INTO solution VALUES (1, 'Jeremy Bowers');
SELECT value FROM solution;

-- 7. Yes it is! But there is a Mastermind behind all this!

SELECT *
FROM interview
WHERE person_id=67318


-- 8. The transcript of Jeremy said the following:
-- hired by a woman with a lot of money
--  5'5" (65") or 5'7" (67"), red hair, drives a Tesla Model S
--  attended the SQL Symphony Concert 3 times in December 2017

SELECT *
FROM drivers_license
WHERE hair_color = "red"
AND height >= 65
AND height <= 67
AND car_make LIKE "%tesla%"
AND car_model LIKE "Model S"
AND gender = "female"
LIMIT 100

-- 9. There are still 3 people, so let's check the concert event

SELECT p.*
FROM drivers_license as dl
INNER JOIN person as p on dl.id=p.license_id
WHERE hair_color = "red"
AND height >= 65
AND height <= 67
AND car_make LIKE "%tesla%"
AND car_model LIKE "Model S"
AND gender = "female"
LIMIT 100



SELECT p.*, fb.*
FROM drivers_license as dl
INNER JOIN person as p on dl.id=p.license_id
INNER JOIN facebook_event_checkin as fb on fb.person_id=p.id
WHERE hair_color = "red"
AND height >= 65
AND height <= 67
AND car_make LIKE "%tesla%"
AND car_model LIKE "Model S"
AND gender = "female"
LIMIT 100


SELECT person_id,
COUNT (*) as visits
FROM facebook_event_checkin
WHERE date BETWEEN 20171201 AND 20171231
AND event_name="SQL Symphony Concert"
GROUP BY person_id
HAVING COUNT (*)>=3










WITH CTE AS (
SELECT person_id,
COUNT (*) as visits
FROM facebook_event_checkin
WHERE date BETWEEN 20171201 AND 20171231
AND event_name="SQL Symphony Concert"
GROUP BY person_id
HAVING COUNT (*)>=3
)

SELECT p.*, fb.*
FROM drivers_license as dl
INNER JOIN person as p on dl.id=p.license_id
INNER JOIN CTE as fb on fb.person_id=p.id
WHERE hair_color = "red"
AND height >= 65
AND height <= 67
AND car_make LIKE "%tesla%"
AND car_model LIKE "Model S"
AND gender = "female"
LIMIT 100

-- Miranda Priestly is the Mastermind!

INSERT INTO solution VALUES (1, 'Miranda Priestly');
SELECT value FROM solution;