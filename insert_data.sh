#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "truncate games, teams")

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do

  if [[ $year != "year" ]]
    then

insert_results=$($PSQL "INSERT INTO teams(name) VALUES ('$winner'),('$opponent') ON CONFLICT DO NOTHING;
  INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($year, '$round', (SELECT team_id FROM teams WHERE name = '$winner'), (SELECT team_id FROM teams WHERE name = '$opponent'), $winner_goals, $opponent_goals)")
    if [[ $insert_results == "INSERT 0 1" ]]
      then
        echo "Inserted into teams, $winner, $opponent"
        echo "Inserted into games, $year, $round, $winner_id, $opponent_id, $winner_goals, $opponent_goals"
    fi
  fi
done
