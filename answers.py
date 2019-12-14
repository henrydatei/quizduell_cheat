import quizduell
import cookielib
import json
import os
import argparse

parser = argparse.ArgumentParser(description='Give me a gameID!')
parser.add_argument("--gameID")

args = parser.parse_args()
gameID = args.gameID

# Load authenticated session from file to prevent unnecessary logins:
cookie_jar = cookielib.MozillaCookieJar('cookie_file')
api = quizduell.QuizduellApi(cookie_jar)

if os.access(cookie_jar.filename, os.F_OK):
    cookie_jar.load()
else:
    api.login_user('henrydatei', 'henrydatei')

api = quizduell.QuizduellApi(cookie_jar)
result = api.get_game(gameID)

if 'access' in result:
    # Session invalid, re-login:
    api.login_user('henrydatei', 'henrydatei')
    result = api.top_list_rating()

# Store authenticated session in file:
cookie_jar.save()

print json.dumps(result, sort_keys=True, indent=4)
