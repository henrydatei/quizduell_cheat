#!/bin/sh

if [ -f account.txt ]; then
  echo "Login information found in \033[32maccount.txt\033[0m."
  username=$(cat account.txt | cut -d "|" -f1)
  password=$(cat account.txt | cut -d "|" -f2)
else
  echo "No login information found. Creating file \033[32maccount.txt\033[0m."
  read -p "Username: " username
  read -p "Password: " password
  echo "$username|$password" >> account.txt
fi

python python-scripts/answers.py --gameID=$1 --username=$username --password=$password > answers.txt

category=0
for category in 0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17; do
	questionCounter=$(echo "$category * 3" | bc)
	catName=$(cat answers.txt | jq -r ".game.questions | .[$questionCounter].cat_name")
	echo "\033[33m=============== $catName ===============\033[0m"

	for subcounter in 0 1 2; do
	questioncounter=$(echo "$questionCounter + $subcounter")
	question=$(cat answers.txt | jq -r ".game.questions | .[$questioncounter].question")
	right=$(cat answers.txt | jq -r ".game.questions | .[$questioncounter].correct")
	wrong1=$(cat answers.txt | jq -r ".game.questions | .[$questioncounter].wrong1")
	wrong2=$(cat answers.txt | jq -r ".game.questions | .[$questioncounter].wrong2")
	wrong3=$(cat answers.txt | jq -r ".game.questions | .[$questioncounter].wrong3")

	echo "$question \033[32m$right\033[0m, \033[31m$wrong1\033[0m, \033[31m$wrong2\033[0m, \033[31m$wrong3\033[0m"
	done
	echo ""
done

rm answers.txt
