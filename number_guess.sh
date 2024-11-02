#!/bin/bash

echo "Enter your username:"
read username

if [[ ! "$username" =~ ^[a-zA-Z0-9_]{1,23}$ ]]; then
    echo "Not a good username"
    exit
fi

PSQL="psql --username=freecodecamp --dbname=guessgame -t --no-align -c"

user_exists=$($PSQL "SELECT username FROM players WHERE username = '$username';")

NUM=$(( RANDOM % 1000 + 1 ))

if [[ -n "$user_exists" ]]; then
    games_played=$($PSQL "SELECT playtimes FROM players WHERE username = '$username';")
    best_game=$($PSQL "SELECT bestscore FROM players WHERE username = '$username';")
    echo "Welcome back, $username! You have played $games_played games, and your best game took $best_game guesses."
else
    echo "Welcome, $username! It looks like this is your first time here."
    insert=$($PSQL "INSERT INTO players (username, playtimes, bestscore) VALUES ('$username', 1, 0);")
    games_played=1
    best_game=0
fi

number_of_guesses=0
guess=-1

echo "Guess the secret number between 1 and 1000: "

while [[ $guess -ne $NUM ]]; do
    read guess_input

    if ! [[ $guess_input =~ ^[0-9]+$ ]]; then
        echo "That is not an integer, guess again:"
        continue
    fi

    guess=$guess_input
    number_of_guesses=$(( number_of_guesses + 1 ))

    if [[ $guess -lt $NUM ]]; then
        echo "It's higher than that, guess again:"
    elif [[ $guess -gt $NUM ]]; then
        echo "It's lower than that, guess again:"
    fi
done

if [[ $best_game -eq 0 || $number_of_guesses -lt $best_game ]]; then
    $PSQL "UPDATE players SET playtimes=$(( games_played )), bestscore=$number_of_guesses WHERE username='$username';" 1>/dev/null
else
    $PSQL "UPDATE players SET playtimes=$(( games_played )) WHERE username='$username';" 1>/dev/null
fi

echo "You guessed it in $number_of_guesses tries. The secret number was $NUM. Nice job!"

