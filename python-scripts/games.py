import quizduell
import cookielib
import json
import os
import argparse

parser = argparse.ArgumentParser(description='Give me a gameID!')
parser.add_argument("--username")
parser.add_argument("--password")

args = parser.parse_args()
username = args.username
password = args.password

# Load authenticated session from file to prevent unnecessary logins:
cookie_jar = cookielib.MozillaCookieJar('cookie_file')
api = quizduell.QuizduellApi(cookie_jar)

if os.access(cookie_jar.filename, os.F_OK):
    cookie_jar.load()
else:
    api.login_user(username, password)

api = quizduell.QuizduellApi(cookie_jar)
result = api.current_user_games()

if 'access' in result:
    # Session invalid, re-login:
    api.login_user(username, password)
    result = api.top_list_rating()

# Store authenticated session in file:
cookie_jar.save()

print json.dumps(result, sort_keys=True, indent=4)
