import quizduell
import cookielib
import json
import os
import argparse

parser = argparse.ArgumentParser(description='Give me a gameID!')
parser.add_argument("--lastAnswers", required=False)
parser.add_argument("--gameID")
parser.add_argument("--nextAnswers")
parser.add_argument("--category")

args = parser.parse_args()
gameID = args.gameID
lastAnswers = args.lastAnswers
nextAnswers = args.nextAnswers
category = args.category

# Load authenticated session from file to prevent unnecessary logins:
cookie_jar = cookielib.MozillaCookieJar('cookie_file')
api = quizduell.QuizduellApi(cookie_jar)

if os.access(cookie_jar.filename, os.F_OK):
    cookie_jar.load()
else:
    api.login_user('henrydatei', 'henrydatei')

api = quizduell.QuizduellApi(cookie_jar)

if lastAnswers is not None:
    answerArray = lastAnswers.split(",") + nextAnswers.split(",")
else:
    answerArray = nextAnswers.split(",")

answerArray = map(int, answerArray)
print answerArray

result = api.upload_round_answers(gameID, answerArray, category)

# Store authenticated session in file:
cookie_jar.save()

print json.dumps(result, sort_keys=True, indent=4)
