#!/usr/bin/env python
#
# tournament.py -- implementation of a Swiss-system tournament
#

import psycopg2


def connect():
    """Connect to the PostgreSQL database.  Returns a database connection."""
    return psycopg2.connect("dbname=tournament")


def deleteMatches():
    """Remove all the match records from the database."""
    conn = connect()
    c = conn.cursor()
    c.execute("DELETE FROM Matches;")
    conn.commit()
    conn.close()


def deletePlayers():
    """Remove all the player records from the database."""
    conn = connect()
    c = conn.cursor()
    c.execute("DELETE FROM Players;")
    conn.commit()
    conn.close()


def countPlayers():
    """Returns the number of players currently registered."""
    conn = connect()
    c = conn.cursor()
    c.execute("SELECT COUNT(id) FROM Players;")
    results = c.fetchall()
    conn.close()
    return results[0][0]


def registerPlayer(name):
    """Adds a player to the tournament database.
  
    The database assigns a unique serial id number for the player.  (This
    should be handled by your SQL database schema, not in your Python code.)
  
    Args:
      name: the player's full name (need not be unique).
    """
    conn = connect()
    c = conn.cursor()
    c.execute("INSERT INTO Players (name) VALUES (%s)", (name,))
    conn.commit()
    conn.close()


def playerStandings():
    """Returns a list of the players and their win records, sorted by wins.

    The first entry in the list should be the player in first place, or a player
    tied for first place if there is currently a tie.

    Returns:
      A list of tuples, each of which contains (id, name, wins, matches):
        id: the player's unique id (assigned by the database)
        name: the player's full name (as registered)
        wins: the number of matches the player has won
        matches: the number of matches the player has played
    """
    conn = connect()
    c = conn.cursor()
    c.execute("SELECT id, name, wins, matches FROM Standings ORDER BY wins DESC;")
    results = c.fetchall()
    conn.close()
    return results


def reportMatch(winner, loser, tie):
    """Records the outcome of a single match between two players.

    Args:
      winner:  the id number of the player who won
      loser:  the id number of the player who lost
    """
    conn = connect()
    c = conn.cursor()
    if tie:
        c.execute("INSERT INTO Matches (player1, player2, result) VALUES (%s, %s, 1)", (winner, loser))
        c.execute("INSERT INTO Matches (player1, player2, result) VALUES (%s, %s, 1)", (loser, winner))
    else:
        c.execute("INSERT INTO Matches (player1, player2, result) VALUES (%s, %s, 1)", (winner, loser))
        c.execute("INSERT INTO Matches (player1, player2, result) VALUES (%s, %s, 0)", (loser, winner))
    conn.commit()
    conn.close()


def swissPairings():
    """Returns a list of pairs of players for the next round of a match.
  
    Assuming that there are an even number of players registered, each player
    appears exactly once in the pairings.  Each player is paired with another
    player with an equal or nearly-equal win record, that is, a player adjacent
    to him or her in the standings.
  
    Returns:
      A list of tuples, each of which contains (id1, name1, id2, name2)
        id1: the first player's unique id
        name1: the first player's name
        id2: the second player's unique id
        name2: the second player's name
    """
    conn = connect()
    c = conn.cursor()
    c.execute("SELECT id, name, wins FROM Standings ORDER BY wins DESC;")
    results = c.fetchall()
    conn.close()
    i = 0
    pairings = []
    while i < len(results):
        player1_id = results[i][0]
        player1_name = results[i][1]
        player2_id = results[i+1][0]
        player2_name = results[i+1][1]
        pairings.append((player1_id, player1_name, player2_id, player2_name))
        i = i + 2
    return pairings
