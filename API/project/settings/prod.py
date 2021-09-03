from .base import *

#
# DEBUG FLAG
#
DEBUG = False

#
# ALLOWED HOSTS
#
ALLOWED_HOSTS = []

#
# DATABASE
#
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.mysql',
        'NAME': config('DB_NAME'),
        'USER': config('DB_USERNAME'),
        'PASSWORD': config('DB_PASSWORD'),
    }
}

#
# STATIC FILES
#
STATIC_URL = '/static/'
