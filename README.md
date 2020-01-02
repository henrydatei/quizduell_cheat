# Quizduell Cheat
I wrote some small scripts that will allow you to cheat in Quizduell.

At first you should run `./list_of_games.sh` to get a list of all games with their gameID. This id is required for some of the other scripts like `./get_answers.sh <gameID>` that will print out all questions and answers for a game.

The script `./special_quiz.sh` gives you the answers for the special quizzes against your country that wil last for about a week.

`./quizduell_bot.sh` scans for open games where it's your turn and will play a perfect game for you.

I've also made a legit version (`./legit-bot.sh`) of my bot that won't play perfect games but tries to be a bit better than your opponent.

#### Credits
I used this repo for the communication with the quizduell api, thanks for that:[https://github.com/welljsjs/quizduellapi](https://github.com/welljsjs/quizduellapi)

#### Disclaimer
Quizduell is a registered trademark of FEO Media AB, Stockholm, SE registered in Germany and other countries. This project is an independent work and is in no way affiliated with, authorized, maintained, sponsored or endorsed by FEO Media AB.
