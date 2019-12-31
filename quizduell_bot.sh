#!/bin/sh

python games.py > games.txt

i=0
state=$(cat games.txt | jq ".user.games | .[$i].opponent")
turn=$(cat games.txt | jq -r ".user.games | .[$i].your_turn")

while [ "$state" != "null" ] && [ "$turn" = "true" ]; do
  name=$(echo "$state" | jq -r ".name")
  gameID=$(cat games.txt | jq ".user.games | .[$i].game_id")
  currentRound=$(cat games.txt | jq ".user.games | .[$i].cat_choices | length")
	yourPoints=$(cat games.txt | jq ".user.games | .[$i].your_answers" | grep "0" | wc -l | bc)
	opponentPoints=$(cat games.txt | jq ".user.games | .[$i].opponent_answers" | grep "0" | wc -l | bc)

  if [ $(echo "$currentRound % 2" | bc) -eq 0 ]; then
    first="ich"
    case "$currentRound" in
      0) numberOfZeros=3;;
      2) numberOfZeros=9;;
      4) numberOfZeros=15;;
      6) numberOfZeros=18;;
    esac
  else
    first="er"
    numberOfZeros=$(echo "($currentRound + 1) * 6" | bc)
  fi

  echo "Spiel gegen \033[32m$name\033[0m mit der game_id \033[32m$gameID\033[0m ($yourPoints:$opponentPoints [Runde $currentRound])"
  echo "Erster Spieler: $first, Anzahl Nullen: $numberOfZeros"
  python auto-answer.py --gameID=$gameID --numberOfZeros=$numberOfZeros > /dev/null
	i=$(echo "$i+1" | bc)
	state=$(cat games.txt | jq ".user.games | .[$i].opponent")
  turn=$(cat games.txt | jq -r ".user.games | .[$i].your_turn")
done

rm games.txt
