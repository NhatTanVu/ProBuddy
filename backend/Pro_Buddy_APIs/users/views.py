from rest_framework import generics, status
from rest_framework.response import Response
from rest_framework.views import APIView
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
        interests = self.request.data.get('interests', '').split(',')
        services = self.request.data.get('services', '').split(',')
        user = serializer.save()
        for interest in interests:
            if (interest != ''):
                UserInterest.objects.create(user=user, name=interest)
        for service in services:
            if (service != ''):
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
                **GetUserDetailsSerializer(user, context={'request': request}).data
            }
            return Response(response_data)
        else:
            return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)


class LogoutUserAPIView(APIView):
    permission_classes = (IsAuthenticated,)

    def post(self, request):
        refresh_token = request.data.get('refresh_token')

        if refresh_token:
            try:
                token = RefreshToken(refresh_token)
                token.blacklist()
                return Response({"detail": "Logout successful"}, status=status.HTTP_205_RESET_CONTENT)
            except Exception as e:
                return Response({"detail": "Invalid token"}, status=status.HTTP_400_BAD_REQUEST)
        else:
            return Response({"detail": "Refresh token is required"}, status=status.HTTP_400_BAD_REQUEST)
