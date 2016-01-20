-- Table definitions for the tournament project.
--
-- Put your SQL 'create table' statements in this file; also 'create view'
-- statements if you choose to use it.
--
-- You can write comments in this file by starting them with two dashes, like
-- these lines here.

-- Remove old database
DROP DATABASE IF EXISTS tournament;
CREATE DATABASE tournament;
\c tournament

-- Overview of Players in Tournament
CREATE TABLE players(
    id SERIAL primary key,
    name varchar(255)
);

-- Matchup info
CREATE TABLE matches(
    id SERIAL primary key,
    player1 int references players(id),
    player2 int references players(id),
    result int
);

-- Show number of wins for each player
CREATE VIEW wins AS
    SELECT players.id, COUNT(matches.player2) AS n
    FROM players
    LEFT JOIN(SELECT * FROM matches WHERE result > 0) AS matches
    ON players.id = matches.player1
    GROUP BY players.id;

-- Show number of matches for each player
CREATE VIEW count AS
    SELECT players.id, COUNT(matches.player2) AS n
    FROM players
    LEFT JOIN(SELECT * FROM matches) AS matches
    ON players.id = matches.player1
    GROUP BY players.id;

-- Show standings for each player
CREATE VIEW standings AS
    SELECT players.id, players.name, Wins.n AS wins, Count.n AS matches
    FROM players, count, wins
    WHERE players.id = Wins.id AND Wins.id = Count.id
    ORDER BY wins DESC;

-- Show Opponent Match Wins (i.e. strength of schedule) for each player
CREATE VIEW omw AS
    SELECT players.id, sum(standings.wins) AS n
    FROM standings, players, matches
    WHERE players.id = matches.player1 AND matches.player2 = Standings.id
    GROUP BY players.id;
