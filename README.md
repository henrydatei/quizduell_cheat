# Quizduell Cheat
I wrote some small scripts that will allow you to cheat in Quizduell.

At first you should run `./list_of_games.sh` to get a list of all games with their gameID. This id is required for some of the other scripts like `./get_answers.sh <gameID>` that will print out all questions and answers for a game.

The script `./special_quiz.sh` gives you the answers for the special quizzes against your country that will last for about a week.

`./quizduell_bot.sh` scans for open games where it's your turn and will play a perfect game for you.

I've also made a legit version (`./legit-bot.sh`) of my bot that won't play perfect games but tries to be a bit better than your opponent.

With `start_games.sh` you can check how many games you have currently running and start new to have 5 games running any time.

### API mode
I've added an API mode which allows you to get the results from my scripts in a computer readable form. Just add `api` as last argument when running a script to enter the API mode.
- Example: `./list_of_games.sh` (normal output), `./list_of_games api` (API mode)
- Example `./get_answers.sh <gameID>` (normal output), `./get_answers.sh <gameID> api` (API mode)

#### Credits
I used this repo for the communication with the Quizduell api, thanks for that: [https://github.com/welljsjs/quizduellapi](https://github.com/welljsjs/quizduellapi)

#### Disclaimer
Quizduell is a registered trademark of FEO Media AB, Stockholm, SE registered in Germany and other countries. This project is an independent work and is in no way affiliated with, authorized, maintained, sponsored or endorsed by FEO Media AB.
