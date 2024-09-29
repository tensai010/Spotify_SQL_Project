-- EDA
-- total no of columns
SELECT count (*) from spotify;

-- total no of artists
SELECT count (DISTINCT artist)from spotify;

-- total no of alnums
SELECT count (DISTINCT album)from spotify;

-- total no of album_type
SELECT DISTINCT album_type from spotify;

--exploring min duration
SELECT DISTINCT duration_min
FROM spotify;

-- checking for null values
SELECT * from spotify
WHERE duration_min = 0

-- deleting those rows
DELETE FROM spotify
where duration_min = 0;

select DISTINCT channel from spotify;

select DISTINCT most_played_on from spotify;



