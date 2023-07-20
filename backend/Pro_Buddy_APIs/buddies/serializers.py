from rest_framework import serializers
from .models import *


class CreateBuddyGroupSerializer(serializers.ModelSerializer):
    class Meta:
        model = BuddyGroup
        fields = ('id', 'name', 'description', 'user', 'created_date')
        extra_kwargs = {'user': {'required': True}}


class ViewBuddyGroupSerializer(serializers.ModelSerializer):
    class Meta:
        model = BuddyGroup
        fields = ('id', 'name', 'description')


class CreateBuddyGroupEventSerializer(serializers.ModelSerializer):
    class Meta:
        model = BuddyGroupEvent
        fields = ('id', 'name', 'description', 'start_date',
                  'location', 'created_by', 'buddy_group')
        extra_kwargs = {'buddy_group': {'required': True},
                        'created_by': {'required': True}}
