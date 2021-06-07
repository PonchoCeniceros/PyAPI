#!/bin/bash

GN="\e[94m"
migrate=false
superuser=false

make_migrations() {
  python manage.py makemigrations
  python manage.py migrate
}

create_superuser() {
  python manage.py createsuperuser
}

while (( $# > 1 )); do case $1 in
    --migrate) migrate="$2";;
    --superuser) superuser="$2";;
    *) break;
  esac; shift 2
done

# Run virtualenv
source .venv/bin/activate

# setting rules
$migrate && make_migrations
$superuser && create_superuser

# Run server
echo -e "${GN}" 
python manage.py runserver
