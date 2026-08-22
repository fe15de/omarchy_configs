#!/bin/bash
read -r total used <<< "$(free -b | awk '/^Mem:/ {print $2, $3}')"
used_gb=$(awk -v u="$used" 'BEGIN { printf "%.2f", u / 1073741824 }')
pct=$(awk -v u="$used" -v t="$total" 'BEGIN { printf "%.0f", (u/t)*100 }')
class="normal"
[ "$pct" -ge 70 ] && class="warning"
[ "$pct" -ge 90 ] && class="critical"
echo "{\"text\":\"󰍛 ${used_gb}GB\",\"tooltip\":\"RAM: ${pct}% used\",\"class\":\"${class}\"}"
EOF
