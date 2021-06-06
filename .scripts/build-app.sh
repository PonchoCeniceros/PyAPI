#!/bin/bash

APP_NAME=$1

# Build new app
cd applications/
django-admin startapp ${APP_NAME}
cd ${APP_NAME}

# make model folder
mkdir models/
touch models/__init__.py
rm -f models.py

# make views folder
mkdir views/
touch views/__init__.py
rm -f views.py
