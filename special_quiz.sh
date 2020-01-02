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

python python-scripts/games.py --username=$username --password=$password > games.txt

i=0
state=$(cat games.txt | jq ".user.quizzes | .[0].questions | .[$i]")
name=$(echo "$state" | jq -r ".category.name")
echo "\033[33m=============== $name ===============\033[0m"
while [ "$state" != "null" ]; do
	question=$(cat games.txt | jq -r ".user.quizzes | .[0].questions | .[$i].question")
  right=$(cat games.txt | jq -r ".user.quizzes | .[0].questions | .[$i].correct")
  wrong1=$(cat games.txt | jq -r ".user.quizzes | .[0].questions | .[$i].wrong1")
  wrong2=$(cat games.txt | jq -r ".user.quizzes | .[0].questions | .[$i].wrong2")
  wrong3=$(cat games.txt | jq -r ".user.quizzes | .[0].questions | .[$i].wrong3")
	echo "$question \033[32m$right\033[0m, \033[31m$wrong1\033[0m, \033[31m$wrong2\033[0m, \033[31m$wrong3\033[0m"
	i=$(echo "$i+1" | bc)
	state=$(cat games.txt | jq ".user.quizzes | .[0].questions | .[$i]")
done

rm games.txt
