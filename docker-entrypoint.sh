#!/bin/sh

BIN="./prod/rel/$(cat ./app_name.txt)/bin/$(cat ./app_name.txt)"

$BIN $*

