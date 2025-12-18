#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

if [[ -z "$1" ]]; then
  echo "Please provide an element as an argument."
  exit
fi

# Check if input is an atomic number, symbol, or name
ELEMENT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number::text = '$1' OR LOWER(symbol) = LOWER('$1') OR LOWER(name) = LOWER('$1')")

if [[ -z "$ELEMENT" ]]; then
  echo "I could not find that element in the database."
  exit
fi

# Parse the result
IFS='|' read -r ATOMIC_NUMBER SYMBOL NAME <<< "$ELEMENT"

# Get properties
PROPERTIES=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius, type FROM properties p JOIN types t ON p.type_id = t.type_id WHERE p.atomic_number::text = '$ATOMIC_NUMBER'")

IFS='|' read -r MASS MELTING BOILING TYPE <<< "$PROPERTIES"

echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
