#!/bin/bash
echo "Please provide an element as an argument."
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
SQL=''

if [[ $1 =~ ^[0-9]+$ ]]; then
  SQL="select 
	types.type, 
	properties.atomic_number, 
	properties.atomic_mass, 
	properties.melting_point_celsius, 
	properties.boiling_point_celsius, 
	elements.symbol, 
	elements.name 
  from 
	properties  
  inner join types on types.type_id = properties.type_id \
  inner join elements on elements.atomic_number = properties.atomic_number where properties.atomic_number = $1;"
#elif [[ $1 =~ ^$ ]]; then
#  SQL="SELECT * FROM properties;"
#elif [[  ]]; then
#  SQL="SELECT * FROM properties;"
#else
#  SQL="SELECT * FROM properties;"
fi

RESULT=$($PSQL "$SQL")
echo "$RESULT" | awk -F'|' '{print "The element with atomic number " $2 " is " $7 " (" $6 "). It''''s a " $1 " with a mass of " $3 " amu. " $7 " has a melting point of " $4 " celsius and a boiling point of " $5 " celsius."}'
