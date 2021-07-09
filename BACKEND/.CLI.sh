#!/bin/bash
#  _____ ______        ___    ___      ________   _______    ________   _________                                 
# |\   _ \  _   \     |\  \  /  /|    |\   __  \ |\  ___ \  |\   ____\ |\___   ___\                               
# \ \  \\\__\ \  \    \ \  \/  / /    \ \  \|\  \\ \   __/| \ \  \___|_\|___ \  \_|                               
#  \ \  \\|__| \  \    \ \    / /      \ \   _  _\\ \  \_|/__\ \_____  \    \ \  \                                
#   \ \  \    \ \  \    \/  /  /        \ \  \\  \|\ \  \_|\ \\|____|\  \    \ \  \                               
#    \ \__\    \ \__\ __/  / /           \ \__\\ _\ \ \_______\ ____\_\  \    \ \__\                              
#     \|__|     \|__||\___/ /             \|__|\|__| \|_______||\_________\    \|__|                              
#  ________  ________\|_________   _____ ______    _______    ____________|   ________   ________   ___  __       
# |\  _____\|\   __  \ |\   __  \ |\   _ \  _   \ |\  ___ \  |\  \     |\  \ |\   __  \ |\   __  \ |\  \|\  \     
# \ \  \__/ \ \  \|\  \\ \  \|\  \\ \  \\\__\ \  \\ \   __/| \ \  \    \ \  \\ \  \|\  \\ \  \|\  \\ \  \/  /|_   
#  \ \   __\ \ \   _  _\\ \   __  \\ \  \\|__| \  \\ \  \_|/__\ \  \  __\ \  \\ \  \\\  \\ \   _  _\\ \   ___  \  
#   \ \  \_|  \ \  \\  \|\ \  \ \  \\ \  \    \ \  \\ \  \_|\ \\ \  \|\__\_\  \\ \  \\\  \\ \  \\  \|\ \  \\ \  \ 
#    \ \__\    \ \__\\ _\ \ \__\ \__\\ \__\    \ \__\\ \_______\\ \____________\\ \_______\\ \__\\ _\ \ \__\\ \__\
#     \|__|     \|__|\|__| \|__|\|__| \|__|     \|__| \|_______| \|____________| \|_______| \|__|\|__| \|__| \|__|
#
# CLI SCRIPT (@PonchoCeniceros)
#

#
# VARIABLES
#
# COLORS FOR DISPLAY
VNV="\e[93m"
DNR="\e[1;101m"
GN="\e[94m"
#
# VENV VALID ROUTE
VENV='.venv/'
#
# RULE VARIABLES
migrate=false
runserver=false
superuser=false
showtree=false
appname=""
package=""

#
# BUILD VIRTUAL ENVIRONMENT
#
build_venv() {
  echo -e "${DFLT}"
  virtualenv ${VENV}
  source .venv/bin/activate
  pip install -r requirements/local.txt
  echo -e "${VNV}"
  pip freeze > requirements/local.txt
  cat requirements/local.txt
}

#
# INSTALL A SPECIFIC PACKAGE
#
install_package() {
  echo -e "${DFLT}"
  pip install --upgrade ${package}
  echo -e "${VNV}"
  pip freeze > requirements/local.txt
  cat requirements/local.txt
}

#
# DO MIGRATIONS
#
make_migrations() {
  echo -e "${GN}"
  python manage.py makemigrations
  python manage.py migrate
}

#
# CREATE SUPER USER
#
create_superuser() {
  echo -e "${GN}"
  python manage.py createsuperuser
}

#
# RUN VIRTUAL ENVIRONMENT
#
rebuild_venv() {
  echo -e "${GN}"
  rm -d -r .venv/
  virtualenv .venv
  source .venv/bin/activate
  pip install -r requirements/local.txt
}

#
# SHOW FOLDER STRUCTURE
#
show_tree() {
  echo -e "${GN}"
  tree
}

#
# CREATE AN APP
#
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
    # REPLACE VIEWS FILE BY VIEW FOLDER
    mkdir views/
    touch views/__init__.py
    rm -f views.py
    # CREATE BUSSINES LOGIC (DOMAIN) FOLDER
    mkdir views/bussinesLogic/
    touch views/bussinesLogic/__init__.py
    # CONFIGURATION TO APP INTO PROJECT
    sed -i "s/$appname/application.$appname/" apps.py
    sed -i "s/LOCAL_APPS = (/LOCAL_APPS = (\n\t'application.$appname',/" ../../project/settings/base.py
  fi
}

#
# RUN SERVER
#
run_server() {
  echo -e "${GN}"
  python manage.py runserver
}

###################################
#                                 #
#           MAIN SCRIPT           #
#                                 #
###################################

# BUILDING/CREATING VIRTUAL ENVIRONMENT
if [ -d $VENV ]; then
  echo -e "${GN}"
  source .venv/bin/activate
else
  echo -e "${DNR}"
  echo "Virtual environment does not exists. Creating one..."
  build_venv
fi

# CATCH RULES
while (( $# > 1 )); do case $1 in
    --run) runserver="$2";;
    --tree) showtree="$2";;
    --migrate) migrate="$2";;
    --superuser) superuser="$2";;
    --app) appname="$2";;
    --install) package="$2";;
    *) break;
  esac; shift 2
done
# SETTING PRECEDENCE OF RULES (HIGH TO LOW):
# (1) INSTALL A PACKAGE
if [ "$package" != "" ]; then
  install_package
fi
# (2) CREATE AN APP
if [ "$appname" != "" ]; then
  build_app
fi
# (3) DO MIGRATIONS
$migrate   && make_migrations
# (4) CREATE SUPER USER
$superuser && create_superuser
# (5) SHOW FOLDER STRUCTURE
$showtree  && show_tree
# (6) RUN SERVER
$runserver && run_server

exit 1
#
# EOF
