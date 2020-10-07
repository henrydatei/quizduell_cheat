#!/bin/sh

# successrates
sportUndFreizeit=0.95				# cat_id = 11
essenUndTrinken=0.95				# cat_id = 3
glaubeUndReligion=0.95				# cat_id = 4
kinofilme=0.95					# cat_id = 16
wunderDerTechnik=0.95				# cat_id = 1
draussenImGruenen=0.95				# cat_id = 9
computerspiele=0.95				# cat_id = 14
zeugenDerZeit=0.95				# cat_id = 6
buecherUndWoerter=0.95				# cat_id = 2
koerperUndGeist=0.95				# cat_id = 10
rundUmDieWelt=0.95				# cat_id = 5
machtUndGeld=0.95				# cat_id = 13
medienUndUnterhaltung=0.95			# cat_id = 19
kunstUndKultur=0.95				# cat_id = 20
tvSerien=0.95					# cat_id = 17
imLabor=0.95					# cat_id = 7
comics=0.95					# cat_id = 8
die2000er=0.95					# cat_id = 15
defaultrate=0.95

if [ -f account.txt ]; then
  username=$(cat account.txt | cut -d "|" -f1)
  password=$(cat account.txt | cut -d "|" -f2)
else
  echo "No login information found. Creating file \033[32maccount.txt\033[0m."
  read -p "Username: " username
  read -p "Password: " password
  echo "$username|$password" >> account.txt
fi

createAnswer() {
	randomNumber=$(python python-scripts/randomInt.py --min=1 --max=1000)
	grenzeFuerRichtig=$(echo "(1000 * $1)/1" | bc)
	if [ "$randomNumber" -le "$grenzeFuerRichtig" ]; then
		# right answer
		answer=0
	else
		# wrong answer, choose answer from range 1 to 3
		answer=$(python python-scripts/randomInt.py --min=1 --max=3)
	fi
	echo "$answer"
}

python python-scripts/games.py --username=$username --password=$password > games.txt

i=0
state=$(cat games.txt | jq ".user.games | .[$i].opponent")
turn=$(cat games.txt | jq -r ".user.games | .[$i].your_turn")

while [ "$state" != "null" ]; do
  if [ "$turn" = "true" ]; then
	name=$(echo "$state" | jq -r ".name")
	gameID=$(cat games.txt | jq ".user.games | .[$i].game_id")
	currentRound=$(cat games.txt | jq ".user.games | .[$i].cat_choices | length")
	yourPoints=$(cat games.txt | jq ".user.games | .[$i].your_answers" | grep "0" | wc -l | bc)
	opponentPoints=$(cat games.txt | jq ".user.games | .[$i].opponent_answers" | grep "0" | wc -l | bc)
	yourAnswers=$(cat games.txt | jq -c ".user.games | .[$i].your_answers" | cut -c 2- | rev | cut -c 2- | rev)

	python python-scripts/answers.py --gameID=$gameID --username=$username --password=$password > answers.txt
	cat answers.txt | jq ".game.questions | .[] | .cat_id" | uniq -d > category_list.txt

	if [ $(echo "$currentRound % 2" | bc) -eq 0 ]; then
    first="ich"
    case "$currentRound" in
      0) categorysToChooseFrom=$(cat category_list.txt | head -n 3 | tr '\n' ' ');NumberOfAnswers=3;;
      2) categorysToChooseFrom=$(cat category_list.txt | tail -n 12 | head -n 3 | tr '\n' ' ');NumberOfAnswers=6;;
      4) categorysToChooseFrom=$(cat category_list.txt | tail -n 6 | head -n 3 | tr '\n' ' ');NumberOfAnswers=6;;
			6) NumberOfAnswers=3;;
    esac
  else
    first="er"
		case "$currentRound" in
      1) categorysToChooseFrom=$(cat category_list.txt | tail -n 15 | head -n 3 | tr '\n' ' ');NumberOfAnswers=6;;
      3) categorysToChooseFrom=$(cat category_list.txt | tail -n 9 | head -n 3 | tr '\n' ' ');NumberOfAnswers=6;;
      5) categorysToChooseFrom=$(cat category_list.txt | tail -n 3 | tr '\n' ' ');NumberOfAnswers=6;;
    esac
  fi

	zufallszahl=$(python python-scripts/randomInt.py --min=1 --max=3)
	categoryNumber=$(echo "$zufallszahl - 1" | bc)
	chosenCategory=$(echo "$categorysToChooseFrom" | cut -d " " -f$zufallszahl)
	case "$chosenCategory" in
		 1) successrate=$wunderDerTechnik;;
		 2) successrate=$buecherUndWoerter;;
		 3) successrate=$essenUndTrinken;;
		 4) successrate=$glaubeUndReligion;;
		 5) successrate=$rundUmDieWelt;;
		 6) successrate=$zeugenDerZeit;;
		 7) successrate=$imLabor;;
		 8) successrate=$comics;;
		 9) successrate=$draussenImGruenen;;
		 10) successrate=$koerperUndGeist;;
		 11) successrate=$sportUndFreizeit;;
		 13) successrate=$machtUndGeld;;
		 14) successrate=$computerspiele;;
		 15) successrate=$die2000er;;
		 16) successrate=$kinofilme;;
		 17) successrate=$tvSerien;;
		 19) successrate=$medienUndUnterhaltung;;
		 20) successrate=$kunstUndKultur;;
		 *)  successrate=$defaultrate;;
	esac

	differenceInPoints=$(echo "$yourPoints - $opponentPoints" | bc)
	if [ "$differenceInPoints" -ge 5 ]; then
		correctedSuccessrate=$(echo "$successrate - (($differenceInPoints - 4) * 0.05)" | bc)
	fi
	if [ "$differenceInPoints" -le 4 ] && [ "$differenceInPoints" -gt 0 ]; then
		correctedSuccessrate=$(echo "$successrate + ((3 - $differenceInPoints) * 0.1)" | bc)
	fi
	if [ "$differenceInPoints" -le 0 ]; then
		correctedSuccessrate=$(echo "$successrate + ((-1) * $differenceInPoints * 0.15)" | bc)
	fi

	answerlist=$(createAnswer $correctedSuccessrate)
	j=2
	while [ "$j" -le "$NumberOfAnswers" ]; do
		newAnswer=$(createAnswer $correctedSuccessrate)
		answerlist=$(echo "$answerlist,$newAnswer")
		j=$(echo "($j + 1)/1" | bc)
	done

  if [ "$1" != "api" ]; then
    echo "Spiel gegen \033[32m$name\033[0m mit der game_id \033[32m$gameID\033[0m ($yourPoints:$opponentPoints [Runde $currentRound])"
  	echo " - Meine letzten Antworten: $yourAnswers"
  	echo " - Punktedifferenz: $differenceInPoints"
  	echo " - Erster Spieler: $first"
  	echo " - Auswahlmöglichkeiten der Kategorie: $categorysToChooseFrom=> $chosenCategory ($successrate -> $correctedSuccessrate)"
  	echo " - gesendete Antworten ($NumberOfAnswers müssen gesendet werden): $answerlist"
  fi

	if [ "$currentRound" -le 1 ]; then
		python python-scripts/legit-bot.py --gameID=$gameID --category=$categoryNumber --nextAnswers=$answerlist --username=$username --password=$password
	else
		python python-scripts/legit-bot.py --gameID=$gameID --category=$categoryNumber --nextAnswers=$answerlist --username=$username --password=$password --lastAnswers=$yourAnswers
	fi

	i=$(echo "$i+1" | bc)
	state=$(cat games.txt | jq ".user.games | .[$i].opponent")
	turn=$(cat games.txt | jq -r ".user.games | .[$i].your_turn")

	rm answers.txt
	rm category_list.txt
  fi
  i=$(echo "$i+1" | bc)
  state=$(cat games.txt | jq ".user.games | .[$i].opponent")
  turn=$(cat games.txt | jq -r ".user.games | .[$i].your_turn")
done

rm games.txt
