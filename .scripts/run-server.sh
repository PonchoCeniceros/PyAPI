#!/bin/bash

GN="\e[94m"
CMD=$1

# Run virtualenv
source .venv/bin/activate

# Setting rule
if [ ${CMD} = "-migrate" ]; then
	python manage.py makemigrations
	python manage.py migrate
elif [ ${CMD} = "-superuser" ]; then
	python manage.py createsuperuser
fi

# Run server
echo -e "${GN}" 
python manage.py runserver
