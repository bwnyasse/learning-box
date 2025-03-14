#!/bin/bash

echo "["

year=2025
month=1
day=1
day_count=1

# Function to determine days in month (2025 is not a leap year)
days_in_month() {
  case $1 in
    1|3|5|7|8|10|12) echo 31 ;;
    4|6|9|11) echo 30 ;;
    2) echo 28 ;;
  esac
}

for day_count in $(seq 1 365); do
  # Format date with leading zeros
  formatted_month=$(printf "%02d" $month)
  formatted_day=$(printf "%02d" $day)
  date_str="$year-$formatted_month-$formatted_day"
  
  # Print JSON object
  if [ $day_count -lt 365 ]; then
    echo "    { \"day\": $day_count, \"date\": \"$date_str\", \"type\": \"none\" },"
  else
    echo "    { \"day\": $day_count, \"date\": \"$date_str\", \"type\": \"none\" }"
  fi
  
  # Increment day and handle month/year rollovers
  day=$((day + 1))
  month_days=$(days_in_month $month)
  
  if [ $day -gt $month_days ]; then
    day=1
    month=$((month + 1))
    if [ $month -gt 12 ]; then
      month=1
      year=$((year + 1))
    fi
  fi
done

echo "]"
