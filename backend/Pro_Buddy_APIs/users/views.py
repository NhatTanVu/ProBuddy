from rest_framework import generics, status
from rest_framework.response import Response
from .models import User, UserInterest, UserService
from .serializers import CreateUserSerializer, GetUserDetailsSerializer
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import authenticate
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework.permissions import IsAuthenticated


class SignUpUserAPIView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = CreateUserSerializer

    def perform_create(self, serializer):
        # Save user interests
        interests = self.request.data.get('interests', [])
        services = self.request.data.get('services', [])
        user = serializer.save()
        for interest in interests:
            UserInterest.objects.create(user=user, name=interest)
        for service in services:
            UserService.objects.create(user=user, name=service)


class UserRetrieveAPIView(generics.RetrieveAPIView):
    queryset = User.objects.all()
    serializer_class = GetUserDetailsSerializer
    lookup_field = 'id'
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]


class LoginUserAPIView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = GetUserDetailsSerializer
    lookup_field = 'username'

    def create(self, request, *args, **kwargs):
        username = request.data.get('username')
        password = request.data.get('password')

        # Authenticate user
        user = authenticate(request, username=username, password=password)

        if user is not None:
            refresh = RefreshToken.for_user(user)

            response_data = {
                'access': str(refresh.access_token),
                'refresh': str(refresh),
                **GetUserDetailsSerializer(user).data
            }
            return Response(response_data)
        else:
            return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)
