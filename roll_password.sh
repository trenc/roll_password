#!/bin/bash
#
# Name: roll_password.sh
# Description: This script rolls a random passphrase based of a wordlist (Diceware).
# Author: Tommy Schmucker
# Created: 2012-06-08
# Modified: 2012-09-25
# Version: 0.2
#

usage()
{
	cat << EOF

This script rolls a random pass phrase based of a wordlist (Diceware).

usage: $0 [-h] [-c number] [-l number] [-w file]

-h Show this message
-c Count of words in the pass phrase
-l Minimun length of the pass phrase
-w Wordlist file

EOF
}

count=5
wordlist=diceware_wordlist_en
min_length=14
phrase=

while getopts "hc:l:w:" option; do
	case $option in
		h)
			usage
			exit 1
			;;
		c)
			count="$OPTARG"
			;;
		l)
			min_length="$OPTARG"
			;;
		w)
			wordlist="$OPTARG"
			;;
		?)
			usage
			exit
			;;
	esac
done

[ -e "$wordlist" ] || { echo "$wordlist does not exists, exiting"; exit 1; }

roll_number()
{
	number=
	for i in `seq 5`; do
		roll=`expr $RANDOM % 6`
		digit[i]=`expr $roll + 1`
		number=$number${digit[i]}
	done
}

get_word()
{
	word=
	roll_number
	word=`cat $wordlist | grep $number | awk '{print $2}'`
}

get_phrase()
{
	for j in `seq $count`; do
		get_word
		if [ $j == 1 ]; then
			phrase="$word"
		else
			phrase="$phrase $word"
		fi
	done
}

get_phrase
length=`echo -e "$phrase\c" | wc -m`

if [ $length -lt $min_length ]; then
	echo $'\n'"Phrase \"$phrase\" is too short ($length chars)."$'\n'"You should run the command again!"$'\n'
else
	echo $'\n'"$phrase"$'\n'
fi
