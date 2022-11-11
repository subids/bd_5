select genre_name, count(id_artist) from Genres 
join Artists_Genres on Genres.id_genre = Artists_Genres.id_genre
group by genre_name

--Количество треков, вошедших в альбомы 2019-2020 годов
select count(album_name) from Tracks
join albums on Tracks.id_album = Albums.id_album
where album_release_year >= '20190101' and album_release_year <= '20201231'

--Средняя продолжительность треков по каждому альбому
select album_name, avg(track_duration) from Tracks
join Albums on Tracks.id_album = Albums.id_album
group by album_name

--Все исполнители, которые не выпустили альбомы в 2020 году
select artist_name from Artists 
where artist_name not in (
            select artist_name from Artists
join Artists_Album on Artists.id_artist = Artists_Album.id_artist 
join Albums on Albums.id_album = Artists_Album.id_album 
where album_release_year >= '20200101' and album_release_year <= '20201231'
);

--Названия сборников, в которых присутствует конкретный исполнитель 
select collection_title from Collections
join Collection_Tracks on Collection_Tracks.id_collection = Collections.id_collection
join Tracks on Collection_Tracks.id_track = Tracks.id_track
join Albums on Tracks.id_album = Albums.id_album
join Artists_Album on Artists_Album.id_album = Albums.id_album
join Artists on Artists_Album.id_artist = Artists.id_artist
where artist_name iLIKE '%%Michael%%';


--Название альбомов, в которых присутствуют исполнители более 1 жанра
select album_name, count(genre_name) from Albums 
join Artists_Album on Albums.id_album = Artists_Album.id_album 
join Artists on Artists_Album.id_artist = Artists.id_artist 
join Artists_Genres on Artists.id_artist = Artists_Genres.id_artist 
join Genres on Genres.id_genre = Artists_Genres.id_genre 
group by album_name 
having count(genre_name) > 1

--Наименование треков, которые не входят в сборники
select track_name from Tracks
left join Collection_Tracks on Tracks.id_track = Collection_Tracks.id_track
where id_collection is null

--Исполнителя(-ей), написавшего самый короткий по продолжительности трек (теоретически таких треков может быть несколько)
select artist_name, track_duration from Tracks
join Albums on Tracks.id_album = Albums.id_album
join Artists_Album on Artists_Album.id_album = Albums.id_album
join Artists on Artists_Album.id_artist = Artists.id_artist 
where track_duration = (select min(track_duration) from tracks)


select album_name, count(track_name) from Tracks
join Albums on Tracks.id_album = Albums.id_album
group by album_name

--Название альбомов, содержащих наименьшее количество треков
select distinct album_name from Albums
left join Tracks on Tracks.id_album = Albums.id_album
where Tracks.id_album in (
    select id_album from Tracks
    group by id_album
    having count(id_album) = (
         select count(id_track)
         from Tracks
         group by id_album
         order by count
         limit 1
)
)


SELECT Albums.Title Albums, COUNT(Track.Title) Track_count FROM Albums "не понимаю вот эту констуркцию"
left join Tracks on Tracks.id_album = Albums.id_album
GROUP BY Album.Title
HAVING COUNT(Tracks.Title) = (  
	SELECT COUNT(Tracks.Title) FROM Albums
	JOIN Track ON Albums.Id = Track.AlbumId
	GROUP BY Album.Title
	ORDER BY COUNT(Tracks.Title)
	LIMIT 1);