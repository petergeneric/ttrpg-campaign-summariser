#!/bin/bash


tr -s '\n ' ' ' |
perl -pe 's/&amp;/&/gi' |
perl -pe 's/&nbsp;/ /gi' |
perl -pe 's/ (ok |okay )?u[mh] / /gi' |
perl -pe 's/okay/ok/g' |
perl -pe "s/yeah /yes /gi" |
perl -pe 's/ \[.*?\] / /gi' |
perl -pe 's/(knighted chris|k?night icarus|knight across|knight acres|k?night (of|at) chris|niacris|k?night-of-chris|knightochris|(nida|k?night of|knight|knight a|knight to) (chris|christ|christmas))/Nidocris/gi' |
perl -pe "s/(kyra|kara|car|Clara|they|cars|our|car is|car ah|ah|cora|cara) ?siri /Karasiri /gi" |
perl -pe "s/siricari/Karasiri/gi" |
perl -pe "s/the knight/the night/gi" |
perl -pe 's/professor/Professor/gi' |
tr -s ' ' |
# General noise words
perl -pe 's/i (would|will|can) say (that |this )?//g' |
perl -pe 's/ ((all right|and|ok|so|yeah|yes|u[hm]+|right|well|hmm*|mm-hmm*|let.s see here|let.s see|like you know|like|i think|i would be like|i want to say like|oh man|oh boy|you know|well) ){2,}/ /gi' |
perl -pe "s/ and all th(at|is) stuff / /gi" |
perl -pe 's/ u?[hm\-]+ / /gi' |
perl -pe 's/ ok / /g' |
# Repeated Words (2+ times)
perl -pe "s/ ([\w']+ )\1(\1)*/ \$1 /gi" |
perl -pe "s/ ((so )?it(isn'?t|'?s not) ){2,}/ it's not'/gi" |
perl -pe "s/(it'?s? '\w+ ){2,}'/\$1/gi" |
perl -pe "s/pal roll/pow roll/gi" |
perl -pe "s/birds? of paradise (dice )?/dice /gi" |
perl -pe "s/birds-of-paradise /dice /gi" |
perl -pe "s/(ho|her |w?ho(le)? )fang/Hofang/gi" |
perl -pe "s/make me a (power|pow|con|constitition) roll/make a roll/gi" |
perl -pe "s/so you like/you/gi" |
perl -pe "s/essentially //gi" |
perl -pe "s/ good stuff / good /gi" |
perl -pe "s/ (my favorite|our favorite)? twitch user / fan /gi" |
perl -pe "s/ (my (first|second|third|fourth|fifth)? favorite|our favorite)? fan / fan /gi" |
perl -pe "s/ is like / is /gi" |
perl -pe "s/ (so )?it's like / it's /gi" |
perl -pe "s/ (am|is|was )?like i/ i/gi" |
perl -pe "s/ (and like|it's like) (yeah )?/ and /gi" |
perl -pe "s/ (and )?so you / you /gi" |
perl -pe "s/ alexandria / Alexandria /gi" |
# "Donald" has fewer tokens than Donal, so just fix up the resulting summary and save the tokens
perl -pe "s/ Donald? / Donald /gi" |
perl -pe "s/ (Sylvano|sylvia)s? / sylvano /gi" |
perl -pe "s/ oh (my god|god|no) / /gi" |
perl -pe "s/ Great Dane Society / Great Dane Society /gi" |

tr -s ' '