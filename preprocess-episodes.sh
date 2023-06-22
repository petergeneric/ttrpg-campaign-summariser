#!/bin/bash

rm -rf out/

mkdir -p out/parts/full


getMidEpisodeBreakText() {
	EPISODE="$1"
	
	# By default, use "word from our sponsor" as break text
	echo -n "word from our sponsor"
}

for f in subtitle-src/*.txt
do
	if [ ! -f "$f" ] ; then
		echo "Could not find subtitle source: $f" >&2
		exit 1
	fi
	echo "Process $f" >&2
	EPISODE="$(basename "$f" .txt)"
	
	FULL_EPISODE="out/parts/full/${EPISODE}.txt"
	PART1="out/parts/${EPISODE}-a.txt"
	PART2="out/parts/${EPISODE}-b.txt"
	
	# Double-process since some cleanup helps unblock further cleanups
	./filter.sh < "$f" | filter.sh > "$FULL_EPISODE"
	
	EPISODE_MIDDLE_TEXT="$(getMidEpisodeBreakText "$EPISODE")"
	
	grep "$EPISODE_MIDDLE_TEXT" "$FULL_EPISODE" 2>/dev/null >/dev/null </dev/null
	
	if [ "$?" = "0" ] ; then
		# We have a break point for the middle of the episode
		perl -pe "s/$EPISODE_MIDDLE_TEXT.*$//mi" <"$FULL_EPISODE" | filter.sh >"$PART1"
		perl -pe "s/^.*$EPISODE_MIDDLE_TEXT//mi" <"$FULL_EPISODE" | filter.sh >"$PART2"
	else
		cp "$f" out/parts/
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
	
		if [ $NUM_TOKENS -gt 15500 ] ; then
			echo "$(basename "$f"): $NUM_TOKENS tokens (will likely need to be reduced so that text and prompt combined are below 16K tokens)"
		else
			echo "$(basename $"f"): OK"
		fi
	fi
done