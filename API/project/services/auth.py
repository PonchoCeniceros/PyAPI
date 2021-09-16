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
