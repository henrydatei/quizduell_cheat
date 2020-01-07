#!/bin/sh

if [ -f account.txt ]; then
  username=$(cat account.txt | cut -d "|" -f1)
  password=$(cat account.txt | cut -d "|" -f2)
else
  echo "No login information found. Creating file \033[32maccount.txt\033[0m."
  read -p "Username: " username
  read -p "Password: " password
  echo "$username|$password" >> account.txt
fi

i=1

python python-scripts/games.py --username=$username --password=$password > games.txt

allGames=$(cat games.txt | jq '.user.games | .[].state' | wc -l | bc)
activeGames=$(cat games.txt | jq '.user.games | .[].state' | grep '0\|1' |wc -l | bc)
gamesToStart=$(echo "5 - $activeGames" | bc)

if [ "$1" != "api" ]; then
  echo "Es wurden $allGames Spiele gefunden, davon sind noch $activeGames aktiv. Es werden noch $gamesToStart Spiele gestartet"
fi

while [ "$i" -le "$gamesToStart" ]; do
  python python-scripts/start-game.py --username=$username --password=$password
  i=$(echo "$i + 1" | bc)
done

rm games.txt
