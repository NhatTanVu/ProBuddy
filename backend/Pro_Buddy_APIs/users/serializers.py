from rest_framework import serializers
from django.contrib.auth.hashers import make_password
from .models import User, UserInterest, UserService


class UserInterestSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserInterest
        fields = ('name',)


class UserServiceSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserService
        fields = ('name',)


class CreateUserSerializer(serializers.ModelSerializer):
    interests = UserInterestSerializer(many=True, read_only=True)
    services = UserServiceSerializer(many=True, read_only=True)

    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'first_name',
                  'last_name', 'interests', 'services',
                  'gender', 'date_of_birth', 'address', 'password')
        extra_kwargs = {'password': {'write_only': True},
                        'is_superuser': {'read_only': True},
                        'is_staff': {'read_only': True},
                        'is_active': {'read_only': True},
                        'groups': {'read_only': True},
                        'user_permissions': {'read_only': True},
                        'date_joined': {'read_only': True}}

    def create(self, validated_data):
        validated_data['password'] = make_password(validated_data['password'])
        return super(CreateUserSerializer, self).create(validated_data)


class GetUserDetailsSerializer(serializers.ModelSerializer):
    interests = UserInterestSerializer(many=True, read_only=True)
    services = UserServiceSerializer(many=True, read_only=True)

    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'first_name',
                  'last_name', 'interests', 'services',
                  'gender', 'date_of_birth', 'address')
