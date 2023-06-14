#!/bin/bash

getMiddle() {
	# TODO this is the output of find-breaks.sh with some manual changes as needed so that every episode has a break (N.B. except final episode currently)
cat <<EOF
Middle of 01.txt: we're gonna go to break
Middle of 02.txt: we're gonna go to break
Middle of 03.txt: we're gonna go to break
Middle of 04.txt: we're gonna go to break
Middle of 05.txt: we're gonna take a break
Middle of 06.txt: we're gonna take a break
Middle of 07.txt: we're gonna go to break
Middle of 08.txt: we're gonna go to break
Middle of 09.txt: we're gonna go to break
Middle of 10.txt: we're gonna take a break
Middle of 11.txt: we're gonna take a break
Middle of 12.txt: we're gonna go to break
Middle of 13.txt: MANUAL-BREAK-POINT
Middle of 14.txt: we're gonna take a ten minute break
Middle of 15.txt: we're gonna go to break
Middle of 16.txt: we're gonna take a brief break
Middle of 17.txt: we're gonna take a short a break
Middle of 18.txt: be back as soon as
Middle of 19.txt: be back as quickly as
Middle of 20.txt: be back as soon as
Middle of 21.txt: be back just as soon as
Middle of 22.txt: be back just as soon as
Middle of 23.txt: be back as soon as
Middle of 24.txt: be back just as soon as
Middle of 25.txt: be back as soon as
Middle of 26.txt: be back just as soon as
Middle of 27.txt: to use one bathroom
Middle of 28.txt: be back just as soon as
Middle of 29.txt: be back as soon as
Middle of 30.txt: be back as soon as
Middle of 31.txt: we're gonna take a break
Middle of 32.txt: be back just as soon as
Middle of 33.txt: welcome back Internet friends
Middle of 34.txt: be back as quickly as
Middle of 35.txt: be back just as soon as
Middle of 36.txt: as soon as six people can use six bathroom
Middle of 37.txt: welcome back Internet friends
Middle of 38.txt: be back as soon as
Middle of 40.txt: be back just as soon as
Middle of 41.txt: be back just as soon as
Middle of 42.txt: be back just as soon as
Middle of 43.txt: be back just as soon as
Middle of 44.txt: be back just as soon as
Middle of 45.txt: be back just as soon as
Middle of 46.txt: welcome back Internet friends
Middle of 47.txt: be back just as soon as
Middle of 48.txt: welcome back Internet friends
Middle of 49.txt: welcome back internet friends
Middle of 50.txt: be back as soon as
Middle of 51.txt: be back just as soon as
Middle of 52.txt: be back just as soon as
Middle of 53.txt: be back as soon as
Middle of 54.txt: be back just as soon as
Middle of 55.txt: be back just as soon as
Middle of 56.txt: see you as soon as
Middle of 57.txt: be back just as soon as
Middle of 58.txt: see you when as soon as
Middle of 59.txt: be back just as soon as
Middle of 60.txt: be back just as soon as
Middle of 61.txt: be back just as soon as
Middle of 62.txt: be back just as soon as
Middle of 63.txt: be back just as soon as
Middle of 64.txt: as soon as six people can use six bathroom
Middle of 65.txt: be back just as soon as
Middle of 66.txt: be back just as soon as
Middle of 67.txt: be back just as soon as
Middle of 68.txt: welcome back internet friends
Middle of 69.txt:
EOF
}



mkdir -p out/parts/full

for f in subtitle-src/??.txt
do
	echo "Process $f" >&2
	EPISODE="$(basename "$f" .txt)"
	
	FULL_EPISODE="out/parts/full/${EPISODE}.txt"
	PART1="out/parts/${EPISODE}-a.txt"
	PART2="out/parts/${EPISODE}-b.txt"
	
	# Double-process since some cleanup helps unblock further cleanups
	./filter.sh < "$f" | filter.sh > "$FULL_EPISODE"
	
	EPISODE_MIDDLE_TEXT=$(getMiddle | grep "${EPISODE}.txt" | cut -d':' -f2-)
	
	if [ ! -z "$EPISODE_MIDDLE_TEXT" ] ; then
		# We have a break point for the middle of the episode
		perl -pe "s/$EPISODE_MIDDLE_TEXT.*$//i" <"$FULL_EPISODE" >"$PART1"
		perl -pe "s/^.*$EPISODE_MIDDLE_TEXT//i" <"$FULL_EPISODE" >"$PART2"
	else
		cp "$f" "$FULL_EPISODE"
	fi
done

echo
echo "Counting part tokens" >&2
echo "====================" >&2


for f in out/parts/*.txt
do
	if [ -f "$f" ] ; then
		FILENAME="$(readlink -f "$f")"
		# Count the number of tokens in each part
		NUM_TOKENS=$(bin/count-tokens.js "$FILENAME")
	
		echo "$(basename "$f"): $NUM_TOKENS tokens"
	fi
done
