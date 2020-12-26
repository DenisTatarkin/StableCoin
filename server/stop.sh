#!/bin/sh
sudo kill -9 $(lsof -nP -iTCP -sTCP:LISTEN | grep 8000 | grep -o 'node    \d\d\d\d\d' | grep -o '\d\d\d\d\d')