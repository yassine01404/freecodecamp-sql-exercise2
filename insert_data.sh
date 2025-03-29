#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read year round winner opponent winner_goals opponent_goals
do
  if [[ $year != 'year' ]]
  then
    team=$($PSQL "select name from teams where name='$winner'")
    if [[ -z $team ]]
    then
      echo $($PSQL "insert into teams (name) values ('$winner')")
    fi
    team=$($PSQL "select name from teams where name='$opponent'")
    if [[ -z $team ]]
    then
      echo $($PSQL "insert into teams (name) values ('$opponent')")
    fi
    w_id=$($PSQL "select team_id from teams where name='$winner'")
    o_id=$($PSQL "select team_id from teams where name='$opponent'")
    echo $($PSQL "insert into games (year,round,winner_id,opponent_id,winner_goals,opponent_goals) values ($year,'$round',$w_id,$o_id,$winner_goals,$opponent_goals)")
  fi
done