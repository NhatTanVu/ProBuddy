from rest_framework import generics
from buddies.models import BuddyGroup
from buddies.serializers import CreateBuddyGroupSerializer
from rest_framework_simplejwt.authentication import JWTAuthentication
from rest_framework.permissions import IsAuthenticated

class CreateBuddyGroupAPIView(generics.CreateAPIView):
    queryset = BuddyGroup.objects.all()
    serializer_class = CreateBuddyGroupSerializer
    authentication_classes = [JWTAuthentication]
    permission_classes = [IsAuthenticated]