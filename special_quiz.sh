#!/bin/sh

python games.py > games.txt

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
