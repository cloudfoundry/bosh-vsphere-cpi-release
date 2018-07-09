#!/usr/bin/env bash

SCRIPT_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


jq --slurpfile del_object $SCRIPT_FOLDER/nsx_api_delete_router_ports.json \
    '."paths"."/logical-router-ports"."delete"? += $del_object[0]' \
     $SCRIPT_FOLDER/nsx_api_main.json > $SCRIPT_FOLDER/nsx_api.json