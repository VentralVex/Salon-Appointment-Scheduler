#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n\nWelcome to my salon, how can I help you?\n"

while true; do
  echo $($PSQL "SELECT service_id, name FROM services WHERE service_id=1" | sed 's/|/)\ /g')
  echo $($PSQL "SELECT service_id, name FROM services WHERE service_id=2" | sed 's/|/)\ /g')
  echo $($PSQL "SELECT service_id, name FROM services WHERE service_id=3" | sed 's/|/)\ /g')
  read SERVICE_ID_SELECTED
  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

  if [[ $SERVICE_ID_SELECTED =~ ^[1-3]$ ]]; then
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    #if phone number isn't stored
    if [[ -z $($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'") ]]; then
      #enter new customer phone and name
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      $PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')"
    else 
      #find customer name from phone
      CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    fi
      echo -e "\nWhat time would you like your $SERVICE, $CUSTOMER_NAME?"
      read SERVICE_TIME
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")
      $PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')"
      echo "I have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
    break
  else
    #if service not found
    echo -e "\nI could not find that service. What would you like today?"
  fi
done
