-- DATA ANALYSIS

-- Retrieve the names of all tracks that have more than 1 billion streams.
SELECT * FROM spotify
WHERE stream > 1000000000;

-- List all albums along with their respective artists.
SELECT DISTINCT album , artist
	FROM spotify
order by album;

-- Get the total number of comments for tracks where licensed = TRUE.
select track ,sum(comments) as total_no_comments
FROM spotify
where licensed = 'True'
GROUP by track;

-- Find all tracks that belong to the album type single.
select  track
FROM spotify
WHERE album_type = 'single';

-- Count the total no of tracks by each artists
select artist , count(*) as tracks_by_artists
from spotify
group by artist
ORDER by 2 desc;

-- Calculate the average danceability of tracks in each album.
SELECT 
	album , 
	avg(danceability) as avg_danceability
FROM spotify
GROUP BY album
ORDER BY 2 desc;

-- Find the top 5 tracks with the highest energy values.
SELECT 
	DISTINCT track , 
	MAX	(energy) as energy
FROM spotify
GROUP BY 1
ORDER BY energy desc
LIMIT 5;

-- List all tracks along with their views and likes where official_video = TRUE.
SELECT
	track , 
	sum(views) as views,
	sum(likes) as likes,
	sum(COMMENTS) as comments
FROM spotify
WHERE official_video = 'true'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- For each album, calculate the total views of all associated tracks.

SELECT 
	album , 
	track,
	sum(views) as total_views
	FROM spotify
GROUP BY 1,2
ORDER BY 3 DESC;


-- Retrieve the track names that have been streamed on Spotify more than YouTube.

SELECT * FROM

(SELECT 
	track,
	COALESCE(sum(case when most_played_on = 'Youtube' then stream end),0) as streamed_on_youtube,
	COALESCE(sum(case when most_played_on = 'Spotify' then stream end),0) as streamed_on_spotify
	FROM spotify
GROUP BY 1) 
as t1
 WHERE 
	streamed_on_spotify > streamed_on_youtube
AND
	streamed_on_youtube <> 0;

-- Find the top 3 most-viewed tracks for each artist using window functions.
-- each artists and total views for each track
-- track with highest view for each track (top3)
-- dense rank

with track_rankings 
	AS
(SELECT 
	artist,
	track,
	sum(views) as total_views,
	DENSE_RANK () OVER(PARTITION BY artist ORDER BY sum(views)DESC) AS ranks
	FROM spotify
GROUP BY 
	artist,
	track
ORDER BY 1,3 DESC
)
SELECT * FROM
track_rankings
WHERE ranks <= 3;

-- Write a query to find tracks where the liveness score is above the average.
SELECT
	artist,
	track,
	liveness
	FROM spotify
WHERE liveness > (SELECT
	avg(liveness) as avg_liveness -- 0.19
	FROM spotify);

-- Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
with energy_diff
	AS
(SELECT 
	album,
	min (energy) as min_energy,
	max (energy) as max_energy
FROM spotify
GROUP BY 1)
SELECT 
	album ,
	max_energy - min_energy as energy_difference
FROM energy_diff
ORDER BY 2 DESC