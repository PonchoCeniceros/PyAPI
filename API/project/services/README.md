## Service structure  🤲

The API provides a global service structure, where main files are located in ```project``` folder. The services are declared inside the ```services``` folder (we provide a simple auth service in ```project/services/auth.py``` as example):
```Python
from typing import Dict

# auth
from django.contrib.auth import authenticate
from rest_framework.authtoken.models import Token


class AuthService:
    def login(self, username: str, password: str) -> Dict:
        try:
            user = authenticate(
                username="username",
                password="password",
            )
            token, _ = Token.objects.get_or_create(user=user)
            return {
                "error": False,
                "message": "Usuario autenticado",
                "data": {"token": token.key},
            }
        except Exception as error:
            return {
                "error": True,
                "message": "A ocurrido un error",
                data: error,
            }
```

### Injecting services in your application 💉
We can inject a custom service adding the next code in our ```project/containers.py```:

```Python
from dependency_injector import containers, providers
from . import services


class Container(containers.DeclarativeContainer):
    # providing services
    # (you need to instance a app first)
    authService = providers.Singleton(services.AuthService)
```

and in our ```myapp/apps.py```: 

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
from project.services import AuthService # <-- Here
from dependency_injector.wiring import inject, Provide # <-- Here


@inject # <-- Here
def index(
    request: HttpResponse,
    authService: AuthService = Provide[Container.authService],  # <-- Here
) -> JsonResponse:
    # resp <= using auth service
    return JsonResponse(resp, safe=False)
```

[**back**](https://github.com/PonchoCeniceros/PyAPI)
