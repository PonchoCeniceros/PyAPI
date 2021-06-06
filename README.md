# My REST template
This repository contains the structure of a REST architecture project implemented with the django framework. 


## Structure 🗂
```
.
├── manage.py
│
├── project
│   ├── __init__.py
│   ├── asgi.py
│   ├── settings
│   │   ├── __init__.py
│   │   ├── base.py
│   │   ├── local.py
│   │   └── prod.py
│   ├── urls.py
│   └── wsgi.py
│
├── applications
│   └── __init__.py
│
└── requirements
    ├── local.txt
    └── (prod.txt)    
```


## Requirements 📋
```
asgiref==3.3.4
Django==3.2.3
pytz==2021.1
sqlparse==0.4.1
Unipath==1.1
mysqlclient==2.0.3
PyMySQL==1.0.2
python-decouple==3.4
```

## Instalation 🔧

Cloning repository: (you can use this project as template too)
```
git clone https://github.com/PonchoCeniceros/My-REST-Template.git
```

### 1. Standalone

Creating a virtual environment:
```
virtualenv .venv
source .venv/bin/activate
pip install -r requirements/local.txt
```

Running local server
```
python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

### 2. Using bash scripts
Creating a virtual environment: (remmenber use ```sudo chmod +x``` to grant access to scripts)
```
.scripts/build-venv.sh
```

Just running local server:
```
.scripts/run-server.sh
```
If you want to make migrations and running local server, use ```-migrate``` param. If you want to create a super user and running local server, use ```-superuser``` param.

## Creating applications 📱

You can create an application using the ```build-app.sh```. We can see an example creating a ```myapp``` application:
```
.scripts/build-app.sh myapp
```
Using this script, you can see the next folder structure:
```
.
├── __init__.py
├── admin.py
├── apps.py
├── tests.py
|
├── migrations
│   └── __init__.py
|
├── models
│   └── __init__.py
|
└── views
    └── __init__.py

```
Also, you need to complete the app configuration as you can see next:

1. in ```myapp/apps.py```:
```Python
from django.apps import AppConfig


class MyappConfig(AppConfig):
    name = 'applications.myapp'
```

2. in ```project/settings/base.py```:
```Python
LOCAL_APPS = (
    'applications.myapp',
)
```