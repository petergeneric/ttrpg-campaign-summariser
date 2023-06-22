#!/bin/bash

mkdir -p out/parts/summary

#rm out/summary.txt

for f in out/parts/*.txt
do
	echo "Summarise ${f}..." >&2
	if [ -f "$f" ] ; then
	
		FILENAME="$(readlink -f "$f")"
		BASENAME="$(basename "$f" .txt)"
		SUMMARY_FILE="out/parts/summary/${BASENAME}.txt"
		
		# Generate summary only if we do not already have one
		if [ ! -f "$SUMMARY_FILE" ] ; then
			echo "SUMMARY OF EPISODE $BASENAME:"
			bin/summarise.js "$FILENAME" | tee "$SUMMARY_FILE"
			
			echo "SUMMARY OF EPISODE $BASENAME:" >>out/summary.txt
			echo "-----------------------------------"
			echo >>out/summary.txt
			cat "$SUMMARY_FILE" >>out/summary.txt
			echo >>out/summary.txt
			echo >>out/summary.txt
		fi
	fi

done
