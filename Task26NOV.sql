CREATE DATABASE Spotify
USE Spotify

CREATE TABLE Music(
Id INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(255) NOT NULL,
TotalSecond INT NOT NULL,
TotalListeners INT
)

DROP TABLE Musics 
DROP TABLE Artist
DROP TABLE Albums 


CREATE TABLE Artists(
    Id INT PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(255) NOT NULL,
    ArtistPlaylists NVARCHAR(255) UNIQUE,
    Bio NVARCHAR(255) UNIQUE,
    TotalMonthlyListeners INT
)

CREATE TABLE Albums(
    Id INT PRIMARY KEY IDENTITY,
    [Name] NVARCHAR(255) NOT NULL,
    NumberOfSongs INT NOT NULL,
    [Date] DATE NOT NULL,
    MusicId INT FOREIGN KEY REFERENCES Music(Id)
)

CREATE TABLE MusicArtists(
Id INT PRIMARY KEY IDENTITY,
MusicId INT FOREIGN KEY REFERENCES Music(Id),
ArtistsId INT FOREIGN KEY REFERENCES Artists(Id)
)


INSERT INTO Music ([Name], TotalSecond, TotalListeners)
VALUES
('Shape of You', 233, 1500000000),
('Blinding Lights', 200, 1200000000),
('Bohemian Rhapsody', 355, 1000000000),
('Stairway to Heaven', 482, 800000000),
('Imagine', 183, 500000000);


INSERT INTO Artists ([Name], ArtistPlaylists, Bio, TotalMonthlyListeners)
VALUES
('Ed Sheeran', 'Ed Sheeran Hits', 'A British singer-songwriter known for hits like Shape of You.', 50000000),
('The Weeknd', 'The Weeknd Essentials', 'A Canadian artist known for his hit songs like Blinding Lights.', 60000000),
('Queen', 'Queen Greatest Hits', 'A legendary British rock band, known for Bohemian Rhapsody.', 25000000),
('Led Zeppelin', 'Led Zeppelin Classics', 'A British rock band, known for Stairway to Heaven and their influence on rock music.', 15000000),
('John Lennon', 'John Lennon Solo', 'A British musician, co-founder of The Beatles, and the writer of Imagine.', 10000000);

INSERT INTO Albums ([Name], NumberOfSongs, [Date], MusicId)
VALUES
('Divide', 12, '2017-03-03', 1),
('After Hours', 14, '2020-03-20', 2),
('A Night at the Opera', 12, '1975-11-21', 3),
('Led Zeppelin IV', 8, '1971-11-08', 4),
('Imagine', 10, '1971-10-11', 5);


INSERT INTO MusicArtists (MusicId, ArtistsId)
VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);


CREATE VIEW MusicArtistAlbumInfo AS
SELECT Music.[Name] AS MusicName, Music.TotalSecond AS TotalSeconds, Artists.[Name] as ArtistName, Albums.[Name] AS AlbumName FROM music
JOIN MusicArtists ON Music.Id=MusicArtists.MusicId 
JOIN Artists ON MusicArtists.ArtistsId = Artists.Id
JOIN Albums ON Music.Id = Albums.MusicId;

SELECT * FROM MusicArtistAlbumInfo;


CREATE VIEW AlbumSongCount AS
SELECT Albums.[Name] AS AlbumName, COUNT(Music.Id) AS SongCount FROM Albums
JOIN Music ON Albums.MusicId = Music.Id
GROUP BY Albums.[Name];

SELECT * FROM AlbumSongCount;


CREATE PROCEDURE GetSongsByListenerCountAndAlbum @ListenerCount INT, @Album NVARCHAR(255) 
AS
BEGIN
SELECT Music.[Name] AS MusicName, Music.TotalListeners AS ListenerCount, Albums.[Name] AS AlbumName FROM Music 
JOIN Albums ON Music.Id=Albums.MusicId
WHERE Music.TotalListeners>@ListenerCount;
END;