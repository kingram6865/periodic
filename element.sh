#!/bin/bash
echo "Please provide an element as an argument."
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
SQL=''
SQL1="select 
	types.type, 
	properties.atomic_number, 
	properties.atomic_mass, 
	properties.melting_point_celsius, 
	properties.boiling_point_celsius, 
	elements.symbol, 
	elements.name 
  from 
	properties  
  inner join types on types.type_id = properties.type_id 
  inner join elements on elements.atomic_number = properties.atomic_number"


if [[ $1 =~ ^[0-9]+$ ]]; then
  SQL2=" where properties.atomic_number = $1;"
  SQL="$SQL1 $SQL2"

#else
#  SQL="SELECT * FROM properties;"
fi

RESULT=$($PSQL "$SQL")
echo "$RESULT" | awk -F'|' '{print "The element with atomic number " $2 " is " $7 " (" $6 "). It''''s a " $1 " with a mass of " $3 " amu. " $7 " has a melting point of " $4 " celsius and a boiling point of " $5 " celsius."}'
