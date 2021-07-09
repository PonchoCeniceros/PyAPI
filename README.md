# My REST template
This repository contains the structure of a REST architecture project implemented with the django framework. 


## Structure 🗂
```Bash
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
```Bash
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
```Bash
git clone https://github.com/PonchoCeniceros/My-REST-Template.git
```

Creating a virtual environment:
```Bash
virtualenv .venv
source .venv/bin/activate
pip install -r requirements/local.txt
```

Running local server
```Bash
python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser
python manage.py runserver
```

### Using __CLI__ (command-line interface)
you can use the CLI script to run the development server as well as perform other operations:

```Bash
./.CLI.sh --run true
	  --tree true  
	  --migrate true
	  --superuser true
	  --app myapp
	  --install pipPackage
```

## Creating applications 📱

We can see an example creating a ```myapp``` application:
```Bash
wizard.sh --app myapp
```
Using this script, you can see the next folder structure:
```Bash
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
    ├── bussinesLogic
        └── __init__.py
    └── __init__.py

```
The CLI automatically complete the app configuration as you can see next:
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
