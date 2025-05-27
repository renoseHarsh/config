weather_info=$(curl -s "wttr.in/19.24607000448604,72.98000169293205?format=%c+%C+%t" 2>/dev/null)
if [[ -n "$weather_info" ]]; then
	echo "IN, Thane: $weather_info"
else
	echo "Weather info unavailable for IN, Thane"
fi
