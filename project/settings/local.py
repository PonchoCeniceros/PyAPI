from .base import *

#
# DEBUG FLAG
#
DEBUG = True

#
# ALLOWED HOSTS
#
ALLOWED_HOSTS = []

#
# DATABASE
#
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.sqlite3',
        'NAME': BASE_DIR.child('db.sqlite3'),
    }
}

#
# STATIC FILES
#
STATIC_URL = '/static/'
