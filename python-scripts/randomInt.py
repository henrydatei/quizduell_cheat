import random
import argparse

parser = argparse.ArgumentParser(description='Give me a gameID!')
parser.add_argument("--min")
parser.add_argument("--max")

args = parser.parse_args()
min = int(args.min)
max = int(args.max)

print(random.randint(min,max))
