#!/bin/sh

python games.py > games.txt

i=0
state=$(cat games.txt | jq ".user.games | .[$i].opponent")

while [ "$state" != "null" ]; do
	name=$(echo "$state" | jq -r ".name")
	gameID=$(cat games.txt | jq ".user.games | .[$i].game_id")
	echo "Spiel gegen \033[32m$name\033[0m mit der game_id \033[32m$gameID\033[0m"
	i=$(echo "$i+1" | bc)
	state=$(cat games.txt | jq ".user.games | .[$i].opponent")
done

rm games.txt
