#! /bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

MAIN_MENU(){
  echo -e "\nWelcome to My Salon, how can I help you?"

  RESULT_SERVICES=$($PSQL "SELECT * FROM services")
  echo "$RESULT_SERVICES" | while read ID BAR NAME 
  do 
    echo "$ID) $NAME"
  done
  read SERVICE_ID_SELECTED

  SERVICE_ID_SELECTED_RESULT=$($PSQL "SELECT * FROM services WHERE service_id = $SERVICE_ID_SELECTED")
  
  if [[ -z $SERVICE_ID_SELECTED_RESULT ]]
  then
    MAIN_MENU
  else
    echo "What's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    if [[ -z $CUSTOMER_ID ]]
    then
      echo "I don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      RESULT_INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
      CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")
    fi
    echo "What time would you like your cut, $CUSTOMER_NAME?"
    read SERVICE_TIME

    RESULT_INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(service_id,customer_id,time) VALUES($SERVICE_ID_SELECTED, $CUSTOMER_ID,'$SERVICE_TIME')")
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  fi



  
}





MAIN_MENU