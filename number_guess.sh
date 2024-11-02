#!/bin/bash


echo "Enter your username:"
read username

if [[ ! "$username" =~ ^[a-zA-Z0-9]{1,22}$ ]]; then
    echo "Not a good username"
    exit
fi
PSQL="psql --username=freecodecamp --dbname=guessgame -t --no-align -c"

user_exists=$($PSQL "SELECT username FROM players WHERE username = '$username';")

if [[ -n "$user_exists" ]]; then
    games_played=$($PSQL "SELECT playtimes FROM players WHERE username = '$username';")
    best_game=$($PSQL "SELECT bestscore FROM players WHERE username = '$username';")
    echo "Welcome back, $username! You have played $games_played games, and your best game took $best_game guesses."
else
    echo "Welcome, $username! It looks like this is your first time here."
    $PSQL "INSERT INTO players (username, playtimes, bestscore) VALUES ('$username', 0, 0);" 1> /dev/null 2> /dev/null
fi

NUM=$(( RANDOM % 1000 + 1 ))
echo "Guess the secret number between 1 and 1000: "
read guess
if [[ $NUM -eq $guess ]];
then
	echo "You are guess"
else
	echo "You don't guess"
fi
