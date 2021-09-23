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