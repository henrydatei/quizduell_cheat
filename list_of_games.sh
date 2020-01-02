#!/bin/sh

python python-scripts/games.py > games.txt

i=0
state=$(cat games.txt | jq ".user.games | .[$i].opponent")

while [ "$state" != "null" ]; do
	name=$(echo "$state" | jq -r ".name")
	gameID=$(cat games.txt | jq ".user.games | .[$i].game_id")
	currentRound=$(cat games.txt | jq ".user.games | .[$i].cat_choices | length")
	yourPoints=$(cat games.txt | jq ".user.games | .[$i].your_answers" | grep "0" | wc -l | bc)
	opponentPoints=$(cat games.txt | jq ".user.games | .[$i].opponent_answers" | grep "0" | wc -l | bc)
	echo "Spiel gegen \033[32m$name\033[0m mit der game_id \033[32m$gameID\033[0m ($yourPoints:$opponentPoints [Runde $currentRound])"
	i=$(echo "$i+1" | bc)
	state=$(cat games.txt | jq ".user.games | .[$i].opponent")
done

rm games.txt
