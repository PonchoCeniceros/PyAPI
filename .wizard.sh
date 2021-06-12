#!/bin/bash

# colors
GN="\e[94m"
# routes
VENV='.venv/'
# rules
migrate=false
runserver=false
superuser=false
showtree=false
appname=""

build_venv() {
  echo -e "${GN}"
  virtualenv ${VENV}
  source .venv/bin/activate
  pip install -r requirements/local.txt
}

make_migrations() {
  echo -e "${GN}"
  python manage.py makemigrations
  python manage.py migrate
}

create_superuser() {
  echo -e "${GN}"
  python manage.py createsuperuser
}

rebuild_venv() {
  echo -e "${GN}"
  rm -d -r .venv/
  virtualenv .venv
  source .venv/bin/activate
  pip install -r requirements/local.txt
}

show_tree() {
  echo -e "${GN}"
  tree
}

build_app() {
  echo -e "${GN}"
  cd applications/
  django-admin startapp ${appname}
  cd ${appname}
  mkdir models/
  touch models/__init__.py
  rm -f models.py
  mkdir views/
  touch views/__init__.py
  rm -f views.py
}

run_server() {
  echo -e "${GN}"
  python manage.py runserver
}

if [ -d $VENV ]; then
  echo -e "${GN}"
  source .venv/bin/activate

  while (( $# > 1 )); do case $1 in
      --run) runserver="$2";;
      --tree) showtree="$2";;      
      --migrate) migrate="$2";;
      --superuser) superuser="$2";;
      --app) appname="$2";;
      *) break;
    esac; shift 2
  done
# setting rules and presendence
  if [ "$appname" != "" ]; then
    build_app
  fi
  $migrate   && make_migrations
  $superuser && create_superuser
  $showtree  && show_tree
  $runserver && run_server
# venv does not exists
else
echo -e "${GN}"
  echo "Virtual environment does not exists. Creating one..."
  build_venv
fi
