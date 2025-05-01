#!/bin/bash

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
elif [[ -n "$1" ]] && [[ $1 =~ ^[a-zA-Z]{1,2}$ ]]; then
  SQL2=" where elements.symbol = '$1';"
  SQL="$SQL1 $SQL2"
elif [[ -n "$1" ]] && [[ ${#1} -gt "2" ]]; then
  SQL2=" where elements.name = '$1';"
  SQL="$SQL1 $SQL2"
elif [[ -z "$1" ]]; then
  SQL=""
fi

if [[ -z "$SQL" ]]; then
  RESULT="None"
else
  RESULT=$($PSQL "$SQL")
fi

if [[ "$RESULT" == 'None' ]]; then
  echo "Please provide an element as an argument."
elif [[ -z "$RESULT" ]]; then
  echo "I could not find that element in the database."
else
  echo "$RESULT" | awk -F'|' '{print "The element with atomic number " $2 " is " $7 " (" $6 "). It\047s a " $1 ", with a mass of " $3 " amu. " $7 " has a melting point of " $4 " celsius and a boiling point of " $5 " celsius."}'
fi