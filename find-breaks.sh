#!/bin/bash

# N.B. relies on uuidgen and ag (the-silver-searcher)

TMP_FILE="/tmp/$(uuidgen).process.tmp"



# Look for episode breaks... very inefficiently!
for f in subtitle-src/??.txt
do
	echo -n "Middle of $(basename "$f"): "
	
	# Double-filter input files
	cat "$f" | filter.sh | filter.sh >"$TMP_FILE"
	
	ag -io '(see you|be back) (when |once |just )*as (quickly|fast|soon) as' "$TMP_FILE"
	
	if [ $? != 0 ] ; then
			ag -io '(to use one bathroom?|as soon as \w+ people can use \w+ bathroom)' "$TMP_FILE"
		
		if [ $? != 0 ] ; then
			ag -io 'welcome back internet friends?' "$TMP_FILE"
			
			if [ $? != 0 ] ; then
				ag -io "we're (going to|gonna) (go for|go to|take a).{0,30}?break" "$TMP_FILE"
				
				if [ $? != 0 ] ; then
					ag -io "let's (just )?go to break (now )?" "$TMP_FILE"
					
					if [ $? != 0 ] ; then
						ag -io "we'll be back shortly" "$TMP_FILE"

						if [ $? != 0 ] ; then
							echo
						fi
					fi
				fi
			fi
		fi
	fi
	
	rm -f "$TMP_FILE" 2>/dev/null
done

