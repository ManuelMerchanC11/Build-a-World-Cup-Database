#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
# Adding teams into team's table
echo $($PSQL 'TRUNCATE teams,games')
cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNERGOALS OPPONENTGOALS
do
  if [[ $WINNER != winner ]]
  then
  # Proof that team doesnt exist
  W_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  if [[ -z $W_ID ]]
  then
  # Insert team
  TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
  fi
  W_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
  fi
  if [[ $OPPONENT != opponent ]]
  then
  #Proof that team doesnt exist
  O_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  if [[ -z $O_ID ]]
  then
  # Insert team
  TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
  fi
  O_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
  fi

# Adding games into game's table
  if [[ $WINNERGOALS != winner_goals ]]
  then
  if [[ $OPPONENTGOALS != opponent_goals ]]
  then
  GAMES_INSERTED=$($PSQL"INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR,'$ROUND',$W_ID,$O_ID,$WINNERGOALS,$OPPONENTGOALS)")
  fi
  fi
done