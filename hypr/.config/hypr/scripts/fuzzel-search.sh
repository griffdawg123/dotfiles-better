#!/bin/bash
fuzzel_search=$(fuzzel -d -l 0 --placeholder "Search") 
fuzzle_status=$?
if [ $fuzzle_status -ne 0 ]; then
    exit $fuzzle_status
fi
echo $fuzzel_search | sed 's/^/\"/g;s/$/\"/g' |  xargs zen-browser --search 
