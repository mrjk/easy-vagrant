#!/bin/bash

source_tables=tables.csv
separator=,


# Transform source to CSV (and replace ` to ,), and replace CRLF as well
table_csv=$(cat $source_tables | tr -d '\r' | sed 's/,/;/g' | sed 's/`/,/g'| sed 's/;*$/;/g')

# Get table names summary (Debug)
#echo "$table_csv" | sed "s/${separator}/;/g" | awk -F';' '{print $1}' | sort | grep -v '^$' | uniq -c |awk '{print $2 " " $1 }' | sort

# Get tables names
tables_id=$(echo "$table_csv" | awk -F ";" '{print $1}' | grep -v '^$' | uniq )


# Define header
echo "# Easy-vagrant object definitions"
echo ""
echo "## Table of content"
echo "[TOC]"
echo ""

registered_cat=""

for table in $tables_id ; do

  # Retrieve tables
  table_data=$(echo "${table_csv}" | grep "^${table};" | cut -d';' -f 3- )

  # Retrive category
  table_cat=$(echo "${table_csv}" | grep "^${table};" | cut -d';' -f 2 | head -n 1)

  # Check if the category has already been generated
  if echo "$registered_cat" | grep -q -v "$table_cat" ; then
    echo ""
    echo "## $table_cat"
    echo ""
    registered_cat="$table_cat $registered_cat"
  fi


  # Set section title
  echo ""
  echo "### ${table}"

  # Replace ; per |
  md_all=$(echo "$table_data" | sed 's/;/ | /g' | awk '{ print "|", $0}' )

  # Extract table title line
  md_title=$(echo "$md_all" | head -n 1 )

  # Display table title
  echo $md_title
  echo $md_title | sed 's/[^|]/-/g'

  # Display table content, excluding title
  echo "$md_all" | tail -n +2

done