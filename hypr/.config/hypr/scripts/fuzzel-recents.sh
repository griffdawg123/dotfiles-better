#!/usr/bin/env bash

# Path to your Zen profile (adjust this to match your system)
PROFILE_DIR="$HOME/.zen"
# PROFILE="o5qtgwfr.Default\ \(alpha\)"
PROFILE_PATH=$(find "$PROFILE_DIR" -maxdepth 1 -type d -name "*.Default\ \(alpha\)" | head -n 1)
# PROFILE_PATH="$PROFILE_DIR/$PROFILE"
DB="$PROFILE_PATH/places.sqlite"

# Check DB exists
if [ ! -f "$DB" ]; then
    echo "Could not find places.sqlite in $PROFILE_PATH" >&2
    exit 1
fi

# Copy DB to avoid lock issues if Zen is running
TMP_DB=$(mktemp)
cp "$DB" "$TMP_DB"

# Query recent searches (adjust '%q=%' if your search engine differs)
search=$(sqlite3 "$TMP_DB" "
SELECT DISTINCT query FROM ( SELECT substr(
           substr(url, instr(url, 'q=')+2),
           0,
           instr(substr(url, instr(url, 'q=')+2), '&')
       ) AS query
FROM moz_places
JOIN moz_historyvisits ON moz_places.id = moz_historyvisits.place_id
WHERE url LIKE '%q=%'
ORDER BY visit_date DESC
) 
WHERE query IS NOT NULL;
" | sed -E 's/(^|[^\\])\+/\1 /g' | fuzzel -d -l 10)

rm "$TMP_DB"

# Exit if nothing selected
[ -z "$search" ] && exit 0

values=$(echo "$search" | sed 's/^/"/;s/$/"/;s/ /\\ /g')

# For now, just echo it (testing mode)
echo "Selected search: $values"

