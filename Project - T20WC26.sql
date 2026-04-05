CREATE DATABASE T20WC26;
Use T20WC26;

CREATE TABLE Teams (
    team_id INT PRIMARY KEY, 
    team_name VARCHAR(50),
    group_name VARCHAR(10)
);

CREATE TABLE Players (
    player_id INT PRIMARY KEY,
    player_name VARCHAR(100),
    team_id INT,
    role VARCHAR(20),
    FOREIGN KEY (team_id) REFERENCES Teams(team_id)
);

CREATE TABLE Matches (
    match_id INT PRIMARY KEY,
    team1_id INT,
    team2_id INT,
    match_date DATE,
    venue VARCHAR(100),
    winner_team_id INT,
    FOREIGN KEY (team1_id) REFERENCES Teams(team_id),
    FOREIGN KEY (team2_id) REFERENCES Teams(team_id),
    FOREIGN KEY (winner_team_id) REFERENCES Teams(team_id)
);
CREATE TABLE PlayerStats (
    match_id INT,
    player_id INT,
    runs INT,
    balls_faced INT,
    balls_bowled INT,
    wickets INT,
    catches INT,
    run_outs INT,
    stumpings INT,
    
    PRIMARY KEY (match_id, player_id),
    
    FOREIGN KEY (match_id) REFERENCES Matches(match_id),
    FOREIGN KEY (player_id) REFERENCES Players(player_id)
);


INSERT INTO Teams VALUES
(1, 'India', 'A'),
(2, 'Australia', 'A'),
(3, 'England', 'B'),
(4, 'Pakistan', 'B'),
(5, 'New Zealand', 'C');

INSERT INTO Players VALUES
-- India (Team 1)
(1,'Virat Kohli',1,'Batsman'),
(2,'Rohit Sharma',1,'Batsman'),
(3,'Jasprit Bumrah',1,'Bowler'),
(4,'Hardik Pandya',1,'All-rounder'),
(5,'Ravindra Jadeja',1,'All-rounder'),

-- Australia (Team 2)
(6,'David Warner',2,'Batsman'),
(7,'Steve Smith',2,'Batsman'),
(8,'Mitchell Starc',2,'Bowler'),
(9,'Glenn Maxwell',2,'All-rounder'),
(10,'Pat Cummins',2,'Bowler'),

-- England (Team 3)
(11,'Joe Root',3,'Batsman'),
(12,'Jos Buttler',3,'Batsman'),
(13,'Ben Stokes',3,'All-rounder'),
(14,'Jofra Archer',3,'Bowler'),
(15,'Moeen Ali',3,'All-rounder'),

-- Pakistan (Team 4)
(16,'Babar Azam',4,'Batsman'),
(17,'Mohammad Rizwan',4,'Batsman'),
(18,'Shaheen Afridi',4,'Bowler'),
(19,'Shadab Khan',4,'All-rounder'),
(20,'Haris Rauf',4,'Bowler'),

-- New Zealand (Team 5)
(21,'Kane Williamson',5,'Batsman'),
(22,'Devon Conway',5,'Batsman'),
(23,'Trent Boult',5,'Bowler'),
(24,'Mitchell Santner',5,'All-rounder'),
(25,'Tim Southee',5,'Bowler');

INSERT INTO Matches (match_id, team1_id, team2_id, match_date, venue, winner_team_id) VALUES
(1,1,2,'2024-06-01','Mumbai',1),  -- India vs Australia
(2,2,5,'2024-06-02','Delhi',2),    -- Australia vs New Zealand
(3,3,4,'2024-06-03','Chennai',3),  -- England vs Pakistan
(4,1,3,'2024-06-04','Ahmedabad',1),  -- India vs England
(5,2,4,'2024-06-05','Kolkata',4);   -- Australia vs Pakistan

INSERT INTO PlayerStats 
(match_id, player_id, runs, balls_faced, balls_bowled, wickets, catches, run_outs, stumpings) 
VALUES

-- MATCH 1 (India vs Australia)
(1,1,72,50,0,0,1,0,0),
(1,2,45,30,0,0,0,0,0),
(1,3,10,5,24,2,0,0,0),
(1,6,30,20,0,0,1,0,0),
(1,8,5,3,24,1,0,0,0),

-- MATCH 2 (Australia vs New Zealand)
(2,6,60,40,0,0,0,0,0),
(2,7,35,25,0,0,0,0,0),
(2,8,10,5,24,2,0,0,0),
(2,21,40,22,0,0,1,0,0),
(2,23,8,4,24,2,0,0,0),

-- MATCH 3 (England vs Pakistan)
(3,11,55,38,0,0,0,0,0),
(3,12,48,30,0,0,0,0,0),
(3,14,5,3,24,2,0,0,0),
(3,16,25,15,0,0,1,0,0),
(3,18,18,12,24,1,0,0,0),

-- MATCH 4 (India vs England)
(4,1,80,55,0,0,1,0,0),
(4,2,50,35,0,0,0,0,0),
(4,3,6,3,24,2,0,0,0),
(4,11,45,28,0,0,1,0,0),
(4,14,12,6,24,1,0,0,0),

-- MATCH 5 (Australia vs Pakistan)
(5,6,70,48,0,0,0,0,0),
(5,7,40,28,0,0,0,0,0),
(5,10,10,6,24,2,0,0,0),
(5,16,65,45,0,0,0,0,0),
(5,18,8,4,24,1,0,0,0);

-- Top runs scorer
SELECT p.player_name, SUM(ps.runs) AS total_runs
FROM PlayerStats ps
JOIN Players p ON ps.player_id = p.player_id
GROUP BY p.player_name
ORDER BY total_runs DESC
LIMIT 1;

-- Top wicket takers
SELECT p.player_name, SUM(ps.wickets) AS total_wickets
FROM PlayerStats ps
JOIN Players p ON ps.player_id = p.player_id
GROUP BY p.player_name
ORDER BY total_wickets DESC
LIMIT 1;

-- Highest strike batting
SELECT p.player_name,
(SUM(ps.runs) * 100.0 / SUM(ps.balls_faced)) AS strike_rate
FROM PlayerStats ps
JOIN Players p ON ps.player_id = p.player_id
GROUP BY p.player_name
HAVING SUM(ps.balls_faced) > 0
ORDER BY strike_rate DESC
LIMIT 1;

-- Highest strike bowling
SELECT p.player_name,
ROUND(SUM(ps.balls_bowled) * 1.0 / SUM(ps.wickets), 2) AS bowling_strike_rate
FROM PlayerStats ps
JOIN Players p ON ps.player_id = p.player_id
GROUP BY p.player_name
HAVING SUM(ps.wickets) > 0
ORDER BY bowling_strike_rate ASC
LIMIT 1;

-- TRUNCATE TABLE PlayerStats;
-- TRUNCATE TABLE Matches;
