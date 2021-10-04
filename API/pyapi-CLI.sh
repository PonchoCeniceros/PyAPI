#!/bin/bash
#
# COLORS FOR DISPLAY
VNV="\e[93m"
DNR="\e[1;101m"
GN="\e[94m"
# VENV VALID ROUTE
VENV='.venv/'
# RULE VARIABLES
migrate=false
runserver=false
superuser=false
showtree=false
rebuild=false
appname=""
package=""
#
# BUILD VIRTUAL ENVIRONMENT
build_venv() {
  echo -e "${GN}"
  virtualenv ${VENV}
  source .venv/bin/activate
  pip install -r requirements/local.txt
  echo -e "${VNV}"
  pip freeze > requirements/local.txt
  cat requirements/local.txt
}
#
# INSTALL A SPECIFIC PACKAGE
install_package() {
  echo -e "${GN}"
  pip install --upgrade ${package}
  echo -e "${VNV}"
  pip freeze > requirements/local.txt
  cat requirements/local.txt
}
#
# DO MIGRATIONS
make_migrations() {
  echo -e "${GN}"
  python manage.py makemigrations
  python manage.py migrate
}
#
# CREATE SUPER USER
create_superuser() {
  echo -e "${GN}"
  python manage.py createsuperuser
}
#
# RUN VIRTUAL ENVIRONMENT
rebuild_venv() {
  echo -e "${GN}"
  rm -d -r .venv/
  virtualenv .venv
  source .venv/bin/activate
  pip install -r requirements/local.txt
}
#
# SHOW FOLDER STRUCTURE
show_tree() {
  echo -e "${GN}"
  tree -L 2
}
#
#
create_env_file() {
  secret_key=$(cat /dev/urandom | tr -dc '[:alpha:]' | fold -w ${1:-20} | head -n 1)
  date_info=$(timedatectl | grep "Time zone") 
  read -ra timezone_info <<< "$date_info"
  timezone="${timezone_info[2]}"
  touch .env
  echo "# General configurations" > .env
  echo "SECRET_KEY=${secret_key}" >> .env
  echo "DJANGO_SETTINGS_MODULE=project.settings.local" >> .env
  echo "TIME_ZONE=${timezone}" >> .env
  echo "" >> .env
  echo "# aditional configurations" >> .env
}
#
# CREATE AN APP
build_app() {
  echo -e "${GN}"
  cd applications/
  # CHECK IF APP ALREADY EXISTS
  if [ -d "${appname}" ] 
  then
      echo "app already exists." 
  else
    django-admin startapp ${appname}
    cd ${appname}
    # CREATE A URLS FILE AND SETTING IT
    touch urls.py
    echo 'from django.urls import path, include' > urls.py
    echo 'from . import views' >> urls.py
    echo '' >> urls.py
    echo 'urlpatterns = []' >> urls.py
    # REPLACE MODELS FILE BY VIEW FOLDER
    mkdir models/
    touch models/__init__.py
    rm -f models.py
    # REPLACE TESTS FILE BY VIEW FOLDER
    mkdir tests/
    touch tests/__init__.py
    rm -f tests.py
    # REPLACE VIEWS FILE BY VIEW FOLDER
    mkdir views/
    touch views/__init__.py
    rm -f views.py
    # CREATE SERVICES FOLDER
    mkdir views/services/
    touch views/services/__init__.py
    # CONFIGURATION TO APP INTO PROJECT
    sed -i "s/$appname/applications.$appname/" apps.py
    sed -i "s/LOCAL_APPS = (/LOCAL_APPS = (\n\t'applications.$appname',/" ../../project/settings/base.py
    # ADDING APP URL TO PROJECT URLS
    sed -i "s/urlpatterns = \[/urlpatterns = [\n\tpath('$appname\/',include('applications.$appname.urls')),/" ../../project/urls.py
    cd ../../
  fi
  cd ../
}
#
# RUN SERVER
run_server() {
  echo -e "${GN}"
  python manage.py runserver
}

#
# ███████████               █████████   ███████████  █████
# ░░███░░░░░███             ███░░░░░███ ░░███░░░░░███░░███ 
#  ░███    ░███ █████ ████ ░███    ░███  ░███    ░███ ░███ 
#  ░██████████ ░░███ ░███  ░███████████  ░██████████  ░███ 
#  ░███░░░░░░   ░███ ░███  ░███░░░░░███  ░███░░░░░░   ░███ 
#  ░███         ░███ ░███  ░███    ░███  ░███         ░███ 
#  █████        ░░███████  █████   █████ █████        █████
# ░░░░░          ░░░░░███ ░░░░░   ░░░░░ ░░░░░        ░░░░░ 
#                ███ ░███                                  
#              ░░██████                                   
#               ░░░░░░
#
# CLI SCRIPT (@PonchoCeniceros)

#
# BUILDING/CREATING VIRTUAL ENVIRONMENT
if [ -d $VENV ]; then
  echo -e "${GN}"
  source .venv/bin/activate
else
  echo -e "${DNR}"
  echo "Virtual environment does not exists. Creating one..."
  build_venv
fi
# BUILDING/CREATING VIRTUAL ENVIRONMENT
if ! [ -a .env ]; then
  echo -e "${DNR}"
  echo ".env file does not exists. Creating one..."
  create_env_file
fi

while (( $# > 1 )); do case $1 in  # CATCH RULES
    --run) runserver=true;;
    --tree) showtree=true;;
    --migrate) migrate=true;;
    --superuser) superuser=true;;
    --app) appname="$2";;
    --install) package="$2";;
    --rebuild) rebuild=true;;
    *) break;
  esac; shift 2
done
# SETTING PRECEDENCE OF RULES (HIGH TO LOW):
if [ "$package" != "" ]; then   # (1) INSTALL A PACKAGE
  install_package
fi
$rebuild   && rebuild_venv      # (2) REBUILD
if [ "$appname" != "" ]; then   # (3) CREATE AN APP
  build_app
fi
$migrate   && make_migrations   # (4) DO MIGRATIONS
$superuser && create_superuser  # (5) CREATE SUPER USER
$showtree  && show_tree         # (6) SHOW FOLDER STRUCTURE
$runserver && run_server        # (7) RUN SERVER

exit 1
#
# EOF
