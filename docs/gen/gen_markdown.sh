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
echo '# Easy-vagrant object definitions'
echo ''
echo '* [Legend](#legend)'
echo '* [Settings](#settings)'
echo '  + [root_data](#root-data)'
echo '  + [settings_data](#settings-data)'
echo '  + [default_data](#default-data)'
echo '* [Objects](#objects)'
echo '  + [provisionners_id](#provisionners-id)'
echo '  + [provisionner_data](#provisionner-data)'
echo '  + [box_id](#box-id)'
echo '  + [flavor_id](#flavor-id)'
echo '  + [flavor_data](#flavor-data)'
echo '  + [instance_id](#instance-id)'
echo '  + [instance_data](#instance-data)'
echo '  + [port_data](#port-data)'
echo '  + [provider_id](#provider-id)'
echo '  + [provider_data](#provider-data)'
echo '* [Merge strategy](#merge-strategy)'
echo '  + [merge_strategy](#merge-strategy)'
echo '  + [merge_data](#merge-data)'
echo '* [Default](#default)'
echo '  + [default_flavors](#default-flavors)'
echo '  + [default_boxes](#default-boxes)'
echo '  + [default_provisionners](#default-provisionners)'
echo ''
echo '## Legend'
echo ''
echo 'Some definitions may seems a bit cryptic in thses tables, so there is the definition below:'
echo ''
echo '- ``$id``: Define a key you can attribute a name.'
echo '- ``{flavor_data}``: Reference to a key, a ``flavor_data`` key in this example.'
echo '- ``{instance_id}*``: Reference one or more key, a ``instance_id`` key in this example, the list usually takes form of Hash.'
echo ''

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
