<p align="center">
  <img width="460" height="300" src="https://github.com/PonchoCeniceros/PyAPI/blob/master/.imgs/pyapi-logo.png">
</p>

This repository contains the structure of a REST architecture project implemented with the django framework. 


## Structure 🗂
```Bash
.
├── manage.py
│
├── project
│   ├── __init__.py
│   │
│   ├── containers.py
│   ├── services
│   │   └── __init__.py
│   │
│   ├── settings
│   │   ├── __init__.py
│   │   ├── base.py
│   │   ├── local.py
│   │   └── prod.py
│   │
│   ├── asgi.py
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
djangorestframework==3.12.4
mysqlclient==2.0.3
PyMySQL==1.0.2
python-decouple==3.4
pytz==2021.1
sqlparse==0.4.1
Unipath==1.1
dependency-injector==4.35.2
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
./pyapi-CLI.sh --run on
	       --tree on  
	       --migrate on
	       --superuser on
	       --app myapp
	       --install pipPackage
```

## Creating _.env_ file
you must create a .env file in order to run the server:

```Bash
# General configurations
SECRET_KEY=your_django_secret_key
DJANGO_SETTINGS_MODULE=project.settings.local
TIME_ZONE=your_time_zone

# aditional configurations
...
```

## Other features

* [Creating applications 📱](https://github.com/PonchoCeniceros/PyAPI/blob/master/API/applications)
* [service structure 🤲](https://github.com/PonchoCeniceros/PyAPI/tree/master/API/project/services)
