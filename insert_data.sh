#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WIN OPP WIN_GOAL OPP_GOAL
do
  if [[ $WIN != 'winner' ]] 
  then
    #get winner team_id
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'");
    #if not found
    if [[ -z $WIN_ID ]]
    then
      INSERT_WIN_RESULT="$($PSQL "INSERT INTO teams(name) VALUES('$WIN')")"
      if [[ $INSERT_WIN_RESULT = 'INSERT 0 1' ]]
      then
        echo Inserted team, $WIN
      fi
    fi
  fi
  
  if [[ $OPP != 'opponent' ]] 
  then
    #get opponent team_id
    LOSE_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'");
    #if not found
    if [[ -z $LOSE_ID ]]
    then
      INSERT_OPP_RESULT="$($PSQL "INSERT INTO teams(name) VALUES('$OPP')")"
      if [[ $INSERT_OPP_RESULT = 'INSERT 0 1' ]]
      then
        echo Inserted team, $OPP
      fi
    fi
  fi

  if [[ $YEAR != 'year' ]]
  then
    WIN_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WIN'");
    LOSE_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPP'");
    INSERT_GAME_RESULT="$($PSQL "INSERT INTO games(year, winner_id, opponent_id, winner_goals, opponent_goals, round) VALUES($YEAR, $WIN_ID, $LOSE_ID, $WIN_GOAL, $OPP_GOAL, '$ROUND')")"
  fi
done