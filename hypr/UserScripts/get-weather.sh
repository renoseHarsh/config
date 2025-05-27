#!/bin/bash

# Pull only the needed values
data=$(curl -s "https://wttr.in/19.246308,72.978429?format=%t|%C|%c|%m|%S|%s|%T")

# Parse into variables
IFS='|' read -r temp condition icon moon sunrise sunset now <<<"$data"

# now_cleaned="${now_cleaned#0}"

# Convert times to HHMM for comparison
now_num=$(date -d "${now%%+*}" +%H%M)
sunrise_num=$(date -d "$sunrise" +%H%M)
sunset_num=$(date -d "$sunset" +%H%M)
if ((${now_num#0} < ${sunrise_num#0} || ${now_num#0} > ${sunset_num#0})); then
	if [[ "$condition" == *Clear* ]]; then
		icon="$moon" # Use moon emoji for clear night
	fi
fi

# Output for Waybar
output="$(printf "%s %s" "$icon" "${temp#+}" | xargs)"
echo "$output"
