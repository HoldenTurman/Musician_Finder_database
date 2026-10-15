USE musician_finder;


-- To show every table has data input inside it.
SELECT 
    table_name AS `Table Name`, 
    table_rows AS `Total Records`
FROM information_schema.tables
WHERE table_schema = 'musician_finder'
ORDER BY table_rows DESC;

-- ============================================================================
-- CATEGORY 1: Basic Select Queries
-- ============================================================================

-- 1. Query Musician table ordered alphabetically by Last Name
SELECT f_name, l_name, contact_email 
FROM musician 
ORDER BY l_name ASC;

-- 2. Query Instrument table ordered alphabetically by name
SELECT instrument_name 
FROM instrument 
ORDER BY instrument_name ASC;

-- 3. Query Skill Level table ordered by progression of difficulty
SELECT skill_name, skill_description 
FROM skill_level 
ORDER BY skill_level_id ASC;

-- 4. Query Application Status table sorted alphabetically
SELECT status_name, application_result_description 
FROM application_status 
ORDER BY status_name ASC;

-- 5. Query Vendor profiles ordered by geographic Zip Code
SELECT vendor_name, zip_code 
FROM vendor 
ORDER BY zip_code DESC;

-- 6. Query Musician Experience records sorted from most experienced down to least
SELECT musician_id, instrument_id, years_experience 
FROM musician_instrument 
ORDER BY years_experience DESC;

-- 7. Query Gig Listings sorted by the highest paying budget first
SELECT gig_title, gig_date, pay_amount 
FROM gig_listing 
ORDER BY pay_amount DESC;



-- ============================================================================
-- CATEGORY 2: AGGREGATE QUERIES / JOINS (DATEDIFF, COUNT, AVG, GROUPBY)
-- ============================================================================

-- 8. Count how many musician applications are currently sitting in each status category
SELECT application_status_id, COUNT(gig_lineup_id) AS total_applications
FROM gig_lineup
GROUP BY application_status_id
ORDER BY total_applications DESC;



-- W06
-- Formatting Profiles String Functions

SELECT
	UPPER(CONCAT(l_name, ', ', f_name)) AS professional_name,
    LOWER(contact_email) AS clean_email,
    GROUP_CONCAT(CONCAT(instrument_name, ' (', years_experience, ' yrs)') SEPARATOR ', ') AS skill_list
FROM musician
INNER JOIN musician_instrument
	ON musician.musician_id = musician_instrument.musician_id
INNER JOIN instrument
	ON musician_instrument.instrument_id = instrument.instrument_id
GROUP BY musician.musician_id;
    




-- Date and Time Function Queries

SELECT
	vendor_name,
    gig_title,
    DAYNAME(gig_date) AS day_of_the_week,
    gig_date AS scheduled_date,
    DATEDIFF(gig_date, CURDATE()) AS days_until_gig,
    UPPER(CONCAT(l_name, ', ', f_name)) AS applicant_name
FROM vendor
INNER JOIN gig_listing
	ON vendor.vendor_id = gig_listing.vendor_id
INNER JOIN gig_lineup
	ON gig_listing.gig_listing_id = gig_lineup.gig_listing_id
INNER JOIN musician
	ON gig_lineup.musician_id = musician.musician_id
WHERE gig_date >= CURDATE()
ORDER BY gig_date ASC;




-- Case statements with inner joins

# QUERY 1 Conditinal Logic
-- W08

SELECT CONCAT(m.f_name, ' ', m.l_name) AS musician_name, mi.years_experience,
CASE
	WHEN mi.years_experience <= 3 THEN 'Beginner'
    WHEN mi.years_experience BETWEEN 4 AND 7 THEN 'Intermediate'
    WHEN mi.years_experience BETWEEN 8 AND 12 THEN 'Advanced'
    ELSE 'Expert'
END AS experience_classification
FROM musician m
INNER JOIN musician_instrument mi
ON m.musician_id = mi.musician_id
ORDER BY mi.years_experience DESC;


# Query 2. Case Statement
-- W08

SELECT gig_title, gig_date, pay_amount,
CASE
	WHEN pay_amount < 200.00 THEN 'Low Budget Promo'
    WHEN pay_amount BETWEEN 200.00 AND 500.00 THEN 'Standard Mid-Tier Gig'
    ELSE 'Premium Headline Slot'
END AS budget_tier
FROM gig_listing
ORDER BY pay_amount DESC;


-- =====================================================
-- QUERY 1: COMPLETE MUSICIAN ROSTER & SKILL MAPPING
-- Tables: musician + musician_instrument + skill_level
-- =====================================================
-- W07
SELECT 
    CONCAT(m.f_name, ' ', m.l_name) AS musician_name,
    mi.years_experience,
    s.skill_name AS proficiency_tier,
    IFNULL(mi.demo_video_url, 'No video provided') AS portfolio_link
FROM musician m
INNER JOIN musician_instrument mi ON m.musician_id = mi.musician_id
INNER JOIN skill_level s ON mi.skill_level_id = s.skill_level_id
ORDER BY s.skill_level_id ASC;


-- =====================================================
-- QUERY 2: BOOKING MANAGEMENT WORKLIST
-- Tables: gig_listing + gig_lineup + application_status
-- =====================================================
SELECT 
    gl.gig_title,
    gln.applied_at,
    gln.notes AS applicant_notes,
    ast.status_name AS review_stage
FROM gig_listing gl
INNER JOIN gig_lineup gln ON gl.gig_listing_id = gln.gig_listing_id
INNER JOIN application_status ast ON gln.application_status_id = ast.application_status_id
ORDER BY gln.applied_at ASC;


-- =====================================================
-- QUERY 3: INSTRUMENT DEMAND ANALYSIS
-- Tables: instrument + musician_instrument + gig_lineup
-- =====================================================
SELECT 
    i.instrument_name,
    COUNT(gln.gig_lineup_id) AS total_applications_submitted
FROM instrument i
INNER JOIN musician_instrument mi ON i.instrument_id = mi.instrument_id
INNER JOIN gig_lineup gln ON mi.musician_id = gln.musician_id
GROUP BY i.instrument_id, i.instrument_name
ORDER BY total_applications_submitted DESC;


-- =====================================================
-- QUERY 4: VENUE PAYOUT LEADERBOARD
-- Tables: vendor + gig_listing
-- =====================================================
-- W10
SELECT 
    v.vendor_name,
    v.zip_code,
    COUNT(gl.gig_listing_id) AS total_gigs_posted,
    MAX(gl.pay_amount) AS highest_single_payout,
    SUM(gl.pay_amount) AS total_platform_spend
FROM vendor v
INNER JOIN gig_listing gl ON v.vendor_id = gl.vendor_id
GROUP BY v.vendor_id, v.vendor_name, v.zip_code
ORDER BY total_platform_spend DESC;





-- Step 2: Look for musicians without instruments

SELECT 
    CONCAT(m.f_name, ' ', m.l_name) AS musician_name,
    m.contact_email,
    mi.years_experience
FROM musician m
LEFT JOIN musician_instrument mi 
    ON m.musician_id = mi.musician_id;
    
    
    -- Step 2 for Query 2: Look for instruments with no players
SELECT 
    i.instrument_name,
    mi.musician_id,
    mi.years_experience
FROM instrument i
LEFT JOIN musician_instrument mi 
    ON i.instrument_id = mi.instrument_id;
    
    -- W09
-- Step 2 for Query 3: Look for gigs with no applicants
SELECT 
    gl.gig_title,
    gl.pay_amount,
    gln.applied_at,
    gln.musician_id
FROM gig_listing gl
LEFT JOIN gig_lineup gln 
    ON gl.gig_listing_id = gln.gig_listing_id;
    
    
    
-- Query 4: Look for unused application statuses
SELECT 
    ast.status_name,
    ast.application_result_description,
    gln.gig_lineup_id,
    gln.musician_id
FROM application_status ast
LEFT JOIN gig_lineup gln 
    ON ast.application_status_id = gln.application_status_id;
    
    
-- ===================================================== 
-- Subqueries ----
-- =====================================================
-- W11
-- Query 1
SELECT
v.vendor_name,
gl.gig_title,
gl.pay_amount
FROM gig_listing gl
INNER JOIN vendor v
ON gl.vendor_id = v.vendor_id
WHERE gl.pay_amount > (
SELECT AVG(pay_amount)
FROM gig_listing
);


-- Query 2
SELECT
gig_title,
pay_amount,
(SELECT MAX(pay_amount) FROM gig_listing) AS max_platform_pay
FROM gig_listing;



-- CTE QUERY 1.
-- What this query does: This query uses a CTE to isolate only the applications submitted after a specific baseline date 
-- Then links them back to find the names of the active musicians.
WITH recent_applications AS (
    SELECT musician_id, applied_at 
    FROM gig_lineup
    WHERE applied_at >= '2025-01-01'
)
SELECT 
    m.f_name, 
    m.l_name, 
    ra.applied_at
FROM musician m
INNER JOIN recent_applications ra 
    ON m.musician_id = ra.musician_id
ORDER BY ra.applied_at DESC; 


-- CTE QUERY 2.
-- What this query does: This query that maps a musician's full name to the specific instruments they play and their years of experience.
-- This avoids payouts completely and targets the social profile feature!

CREATE OR REPLACE VIEW vw_musician_experience AS
SELECT 
    CONCAT(m.f_name, ' ', m.l_name) AS full_name,
    i.instrument_name,
    mi.years_experience
FROM musician m
INNER JOIN musician_instrument mi 
    ON m.musician_id = mi.musician_id
INNER JOIN instrument i 
    ON mi.instrument_id = i.instrument_id;

SELECT * FROM vw_musician_experience;
    
-- =====================================================
-- Window Functions
-- =====================================================

-- ============================================================================
-- What it does: Ranks gigs from highest to lowest paying for each specific venue.
-- Why it helps: Lets managers and musicians see which gigs pay the most at a single venue, 
-- without mixing up different businesses or hiding individual gig lines.
-- ============================================================================
-- W12
SELECT 
    v.vendor_name,
    gl.gig_title,
    gl.pay_amount,
    DENSE_RANK() OVER (
        ORDER BY gl.pay_amount DESC
    ) AS gig_payment_rank
FROM gig_listing gl
INNER JOIN vendor v ON gl.vendor_id = v.vendor_id;


    
-- ==================================================
-- Transactions
-- ==================================================

-- Query 1 --

START TRANSACTION;

UPDATE gig_lineup
SET application_status_id = 3,
	notes = CONCAT(IFNULL(notes, ''), ' [Confirmed via Transaction]')
WHERE gig_listing_id = 1
	And musician_id = 1;
    
    
UPDATE gig_lineup
SET application_status_id = 4
WHERE gig_listing_id = 1
	AND musician_id != 1;

SELECT gig_listing_id, musician_id, application_status_id
FROM gig_lineup
WHERE gig_listing_id = 1;

SELECT *
FROM gig_lineup;

COMMIT;



-- Query 2.

START TRANSACTION;

INSERT INTO musician (f_name, l_name, contact_email)
VALUES('Sarah', 'Conner', 'scooner.drums@email.com');


INSERT INTO musician_instrument (years_experience, demo_video_url, musician_id, instrument_id, skill_level_id)
VALUES(6, 'http//youtube.com/sarahdrums', LAST_INSERT_ID(), 3, 4);


SELECT m.f_name, m.l_name, mi.years_experience, mi.instrument_id
FROM musician m
JOIN musician_instrument mi
ON m.musician_id = mi.musician_id
WHERE m.contact_email = 'scooner.drums@email.com';


COMMIT;



