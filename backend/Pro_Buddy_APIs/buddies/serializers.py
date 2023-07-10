from rest_framework import serializers
from django.contrib.auth.hashers import make_password
from users.models import User
from .models import BuddyGroup


class CreateBuddyGroupSerializer(serializers.ModelSerializer):

    class Meta:
        model = BuddyGroup
        fields = ('id', 'name', 'description', 'user', 'created_date')
        extra_kwargs = {'user': {'required': True}}
