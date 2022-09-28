#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
    if [[ $1 ]]; then
        echo -e "\n$1"
    fi

    SERVICES="$($PSQL "SELECT service_id, name FROM services")"
    echo "$SERVICES" | while read SERVICE_ID BAR SERVICE_NAME; do
        echo "$SERVICE_ID) $SERVICE_NAME"
    done

    read SERVICE_ID_SELECTED

    case $SERVICE_ID_SELECTED in
    1) MAKE_APPOINTMENT ;;
    2) MAKE_APPOINTMENT ;;
    3) MAKE_APPOINTMENT ;;
    4) MAKE_APPOINTMENT ;;
    5) MAKE_APPOINTMENT ;;
    *) MAIN_MENU "I could not find that service. What would you like today?" ;;
    esac
}

MAKE_APPOINTMENT() {
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    #if there is no customer name
    if [[ -z $CUSTOMER_NAME ]]; then
        echo -e "\nI don't have a record for that phone number, what's your name?"
        read CUSTOMER_NAME
        INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(name,phone) VALUES('$CUSTOMER_NAME','$CUSTOMER_PHONE')")

    fi
    
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE'")

    SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")
    echo -e "\nWhat time would you like your$SERVICE, $CUSTOMER_NAME?"
    read SERVICE_TIME

    INSERT_APPOINTMENT_TIME=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    echo "I have put you down for a$SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
}

MAIN_MENU "Welcome to my salon, how can I help you?"
