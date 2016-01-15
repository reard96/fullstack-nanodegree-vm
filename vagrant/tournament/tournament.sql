-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

-- Remove old tables and views
DROP TABLE IF EXISTS Players
DROP TABLE IF EXISTS Matches
DROP VIEW IF EXISTS Wins
DROP VIEW IF EXISTS Matches
DROP VIEW IF EXISTS Standings
DROP VIEW IF EXISTS OMW

-- Overview of Players in Tournament
CREATE TABLE Players(
    id SERIAL primary key,
    name varchar(255)
)

-- Matchup info
CREATE TABLE Matches(
    id SERIAL primary key,
    player1 int references Players(id),
    player2 int references Players(id),
    result int
)

-- Show number of wins for each player
CREATE VIEW Wins AS
    SELECT Players.id, COUNT(Matches.player2) AS n
    FROM Players
    LEFT JOIN(SELECT * FROM Matches WHERE result > 0) AS Matches
    ON Players.ID = Matches.player1
    GROUP BY Players.id

-- Show number of matches for each player
CREATE VIEW Count AS
    SELECT Players.id, COUNT(Matches.player2) AS n
    FROM Players
    LEFT JOIN Matches
    ON Players.id = Matches.id
    GROUP BY Players.id

-- Show standings for each player
CREATE VIEW Standings AS
    SELECT Players.id, Players.name, Wins.n AS wins, Count.n AS matches
    FROM Players, Count, Wins
    WHERE Players.id = Wins.id AND Wins.id = Count.id

-- Show Opponent Match Wins (i.e. strength of schedule) for each player
CREATE VIEW OMW AS
    SELECT Players.id, sum(Standings.wins) AS n
    FROM Players, Standings, Matches
    WHERE Players.id = Matches.player1 AND Matches.player2 = Standings.id
    GROUP BY Players.id
