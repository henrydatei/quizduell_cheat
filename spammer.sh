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

echo "enter message"
read message

python python-scripts/games.py --username=$username --password=$password > games.txt

i=0
state=$(cat games.txt | jq ".user.games | .[$i].opponent")

while [ "$state" != "null" ]; do
	gameID=$(cat games.txt | jq ".user.games | .[$i].game_id")
  python python-scripts/send_message.py --username=$username --password=$password --gameID=$gameID --message="$message"

	i=$(echo "$i+1" | bc)
	state=$(cat games.txt | jq ".user.games | .[$i].opponent")
done

rm games.txt
