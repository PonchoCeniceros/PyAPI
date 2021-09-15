[](https://github.com/PonchoCeniceros/PyAPI/blob/master/pyapi-logo.png)

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
./.CLI.sh --run on
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

## Creating applications 📱

We can see an example creating a ```myapp``` application:
```Bash
./.CLI.sh --app myapp
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

3. in ```project/urls.py```:
```Python
urlpatterns = [
    path('myapp/', include('applications.myapp.urls')),
]
```

## Service structure  🤲

The API provides a global service structure, where main files are located in ```project``` folder. The services are declared inside the ```services``` folder. We provide a email service as example.
1. in ```project/services/emails.py```:
```Python
from typing import List, Dict
from django.conf import settings
from django.core.mail import send_mail


class EmailService:
    """EmailService."""

    def sendPlainText(self, message: str, toEmails: List[str]) -> Dict:
        """sendPlainText.
        Args:
            message (str): message
            toEmails (List[str]): toEmails
        Returns:
            Dict:
        """
        try:
            subject = "Hello world"
            send_mail(
                subject=subject,
                message=message,
                from_email=settings.EMAIL_HOST_USER,
                recipient_list=toEmails,
                fail_silently=False,
            )
            return { "message": "Correo enviado correctamente" }
        
	except Exception as error:
            return { "message": "A ocurrido un error" }
```

2. in ```project/containers.py```:
```Python
from dependency_injector import containers, providers
from . import services


class Container(containers.DeclarativeContainer):
    # providing email service
    emailService = providers.Singleton(services.EmailService)
```

### Injecting services in your application 💉
We can inject a custom service adding the next code in our ```myapp/apps.py```: 
```Python
from django.apps import AppConfig


class MyappConfig(AppConfig):
    name = 'applications.myapp'

    def ready(ready): # <-- Here
        from project import container
        from . import views

        container.wire(modules=[views])
```

and we can inject the service directly on our view:
```Python
# django utils
from django.http import HttpResponse, JsonResponse
# dependency injection utils
from project import Container # <-- Here
from project.services import EmailService # <-- Here
from dependency_injector.wiring import inject, Provide # <-- Here


@inject # <-- Here
def index(
    request: HttpResponse,
    emailService: EmailService = Provide[Container.emailService],  # <-- Here
) -> JsonResponse:
    """index.
    Args:
        request (HttpResponse): request
        emailService (EmailService): emailService
    Returns:
        JsonResponse:
    """
    resp = emailService.sendPlainText(
        message="Hello world",
        toEmails=["poncho.ceniceros@gmail.com"],
    )
    return JsonResponse(resp, safe=False)
```
