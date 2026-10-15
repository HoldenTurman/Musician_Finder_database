
USE musician_finder;

-- Clear out old data rows and reset primary key counters
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE review;
TRUNCATE TABLE musician_genre;
TRUNCATE TABLE genre;
TRUNCATE TABLE gig_lineup;
TRUNCATE TABLE gig_listing;
TRUNCATE TABLE vendor;
TRUNCATE TABLE musician_instrument;
TRUNCATE TABLE instrument;
TRUNCATE TABLE skill_level;
TRUNCATE TABLE application_status;
TRUNCATE TABLE musician;
SET FOREIGN_KEY_CHECKS = 1;


-- =====================================================
-- 1. POPULATE LOOKUP: musician
-- =====================================================
INSERT INTO musician (musician_id, f_name, l_name, contact_email) VALUES
(1, "Holden", "Turman", "holdenguitar@email"),
(2, "Dave", "Hunter", "bandman1@email.com"),
(3, "Emily", "Stevens", "em2002@email.com"),
(4, "Shane", "Arnold", "shane34@hotmail.com"),
(5, "Mac", "Hummiston", "macattack@gmail.com"),
(6, 'John', 'Doe', 'johndoe@email.com');

-- =====================================================
-- 2. POPULATE LOOKUP: skill_level
-- =====================================================
INSERT INTO skill_level (skill_level_id, skill_name, skill_description) VALUES
(1, 'Beginner', 'Learning basic chords, rhythms, and core instrument mechanics.'),
(2, 'Novice', 'Can play basic melodies and match simple rhythms with others.'),
(3, 'Intermed.', 'Comfortable with standard cover songs and club gigs.'),
(4, 'Advanced', 'Highly fluent in improvisation, complex theory, and tight timing.'),
(5, 'Expert', 'Professional session quality or touring veteran capabilities.');

-- =====================================================
-- 3. POPULATE LOOKUP: application_status
-- =====================================================
INSERT INTO application_status (application_status_id, status_name, application_result_description) VALUES
(1, 'Applied', 'The musician profile has been submitted for review.'),
(2, 'Shortlisted', 'The vendor is actively reviewing this applicant for the slot.'),
(3, 'Hired', 'The lineup spot is officially confirmed for this musician.'),
(4, 'Declined', 'The slot was filled by another applicant.'),
(5, 'Canceled', 'The gig itself was called off by the venue or management.');

-- =====================================================
-- 4. POPULATE LOOKUP: instrument
-- =====================================================
INSERT INTO instrument (instrument_id, instrument_name) VALUES
(1, 'Electric Guitar'),
(2, 'Bass Guitar'),
(3, 'Drums'),
(4, 'Keyboard'),
(5, 'Lead Vocals'),
(6, 'Theremin');

-- =====================================================
-- 5. POPULATE PARENT: vendor
-- =====================================================
INSERT INTO vendor (vendor_id, vendor_name, contact_email, zip_code) VALUES
(1, 'The Bluebird Cafe', 'booking@bluebird.com', '37215'),
(2, 'Rhythm & Brews Bar', 'gigs@rhythmbrews.net', '37402'),
(3, 'Downtown Wedding Hall', 'events@downtownhall.com', '37201'),
(4, 'Starlight Lounge', 'lounge@starlight.com', '90210'),
(5, 'Backyard Brewery', 'music@backyardbrew.com', '83440');

-- =====================================================
-- 6. POPULATE LINKING: musician_instrument
-- =====================================================
INSERT INTO musician_instrument (musician_instrament_id, years_experience, demo_video_url, musician_id, instrument_id, skill_level_id) VALUES
(1, 8, 'https://youtube.com/watch?v=holdenshreds', 1, 1, 4), 
(2, 12, 'https://youtube.com/watch?v=davebassline', 2, 2, 5),   
(3, 4, NULL, 3, 4, 3),                                       
(4, 1, 'https://youtube.com/watch?v=shanedrumkit', 4, 3, 1),  
(5, 15, 'https://youtube.com/watch?v=macvocals', 5, 5, 5);   


INSERT INTO musician_instrument (musician_id, instrument_id, years_experience, skill_level_id) 
VALUES (1, 2, 3, 1);

-- =====================================================
-- 7. POPULATE PARENT: gig_listing
-- =====================================================
INSERT INTO gig_listing (gig_listing_id, gig_title, gig_date, pay_amount, demo_video_required, vendor_id) VALUES
(1, 'Acoustic Guitar Friday Night', '2026-06-12 19:00:00', 250.00, 0, 1),
(2, 'Rock Cover Band Bassist Needed', '2026-06-20 21:00:00', 400.00, 1, 2),
(3, 'Jazz Keyboardist for Wedding Reception', '2026-07-04 16:30:00', 600.00, 1, 3),
(4, 'Pop Duo Open Mic Night Co-Host', '2026-06-15 20:00:00', 150.00, 0, 4),
(5, 'Summer Festival Headline Drummer', '2026-07-18 14:00:00', 1000.00, 1, 5),
(6, 'Polka Accordion Afternoon Matinee', '2026-08-01 13:00:00', 175.00, 0, 1);

-- =====================================================
-- 8. POPULATE LINKING: gig_lineup
-- =====================================================
INSERT INTO gig_lineup (gig_lineup_id, applied_at, notes, musician_id, gig_listing_id, application_status_id) VALUES
(1, '2026-05-10 10:15:00', 'Would love to play this acoustic slot!', 1, 1, 2), 
(2, '2026-05-11 14:30:00', '12 years experience playing local blues clubs.', 2, 2, 3), 
(3, '2026-05-12 09:00:00', 'Available with my own high-end stage keyboard.', 3, 3, 1), 
(4, '2026-05-14 18:45:00', 'Still a beginner but I have great energy.', 4, 5, 4),    
(5, '2026-05-15 11:20:00', 'Can perform standard pop and rock classics.', 5, 4, 3);

-- =====================================================
-- POPULATE LOOKUP: genre
-- =====================================================
INSERT INTO genre (genre_name) VALUES 
('Rock'),
('Blues'),
('Jazz'),
('Country'),
('Pop');

-- =====================================================
-- POPULATE LINKING: musician_genre
-- =====================================================
INSERT INTO musician_genre (musician_id, genre_id) VALUES 
(1, 1), 
(1, 2),
(2, 3),
(2, 2);

-- =====================================================
-- POPULATE PARENT: review
-- =====================================================
-- =====================================================
-- POPULATE PARENT: review
-- =====================================================

-- Added gig_listing_id to fulfill the database constraint
INSERT INTO review (rating, comments, created_at, musician_id, vendor_id, gig_listing_id) VALUES 
(5, 'Incredible outdoor stage setup, great acoustics, and they treat the talent right with free meals!', '2026-06-15', 1, 1, 1),
(4, 'Intimate lounge vibe with an awesome soundboard operator. Parking for gear unloading is a bit tight though.', '2026-07-02', 1, 2, 2),
(5, 'Very professional staff and beautiful acoustics in the main hall. Perfect spot for corporate or wedding gigs.', '2026-05-20', 1, 3, 3),
(4, 'High energy rock crowd! The stage monitor mix was a little muddy, but the staff was super helpful.', '2026-06-28', 1, 4, 4),
(5, 'An absolute legendary staple for acoustic singer-songwriters. Respectful, quiet listening room atmosphere.', '2026-07-10', 1, 5, 5);
