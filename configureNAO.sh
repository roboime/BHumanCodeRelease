#! /bin/bash

# @author: Fabricio Asfora (AlphaTuring01)

# This script is used to configure the NAO robots to be seen by BHuman's network software deploy.
# It is necessary to run this script in the NAO robot before deploying the software.
# How to use: ./configureNAO.sh <path_to_network_cfg_file> 
# NOTE: if Windows user, execute with WSL 

function usage(){
    echo "Usage: $0 <path_to_network_cfg_file> [-l|--login]" 
    exit 1
}

function configure_nao(){
    NETWORK_CFG_FILE=$1

    # Check if the network configuration file exists
    if [ ! -f $NETWORK_CFG_FILE ]; then
        echo "Network configuration file not found: $NETWORK_CFG_FILE"
        exit 1
    fi

    # Check if the network configuration file is empty
    if [ ! -s $NETWORK_CFG_FILE ]; then
        echo "Network configuration file is empty: $NETWORK_CFG_FILE"
        exit 1
    fi

    # Retrieve the values of wlan and name from the network configuration file

    WLAN=$(grep -oP 'wlan = \K[^ ]+' $NETWORK_CFG_FILE)
    NAME=$(grep -oP 'name = \K[^ ]+' $NETWORK_CFG_FILE)

    # Check if the wlan and name values are empty
    if [ -z $WLAN ]; then
        echo "WLAN value is empty in the network configuration file: $NETWORK_CFG_FILE"
        exit 1
    fi

    if [ -z $NAME ]; then
        echo "Name value is empty in the network configuration file: $NETWORK_CFG_FILE"
        exit 1
    fi

    # Get the team number from the WLAN value (third quarter of the IP address)
    TEAM_NUMBER=$(echo $WLAN | cut -d'.' -f3)

    # Get the robot number from the WLAN value (fourth quarter of the IP address)
    ROBOT_NUMBER=$(echo $WLAN | cut -d'.' -f4)

    # Execute BHuman's configuration scripts

    ./Install/createRobot -D $NAME
    ./Install/createRobot -i $WLAN -r $ROBOT_NUMBER $NAME
    return $WLAN
}

function login(){
    ./Make/Common/login $1
}

function main(){
    # Check if the number of arguments is valid
    if [ $# -lt 1 ]; then
        usage
    fi

    # Check if the -l or --login flags are present
    if [ "$1" = "-l" ] || [ "$1" = "--login" ] || [ "$2" = "-l" ] || [ "$2" = "--login" ]; then
        if [ "$1" = "-l" ] || [ "$1" = "--login" ]; then
            IP_ADDRESS=$(configure_nao $2)
        else
            IP_ADDRESS=$(configure_nao $1)
        fi
        login "$IP_ADDRESS"
    fi


}
