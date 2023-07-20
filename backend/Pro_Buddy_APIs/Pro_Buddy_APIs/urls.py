"""
URL configuration for Pro_Buddy_APIs project.

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/4.2/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.contrib import admin
from django.urls import path
from rest_framework_simplejwt.views import (
    TokenRefreshView,
)
from buddies.views import *
from users.views import *

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/token/refresh', TokenRefreshView.as_view(), name='token_refresh'),
    path('api/user/login', LoginUserAPIView.as_view(), name='user_login'),
    path('api/user/signup', SignUpUserAPIView.as_view(), name="user_sign_up"),
    path('api/user/<int:id>', UserRetrieveAPIView.as_view(), name='user_view_by_id'),
    path('api/buddy/group/create', CreateBuddyGroupAPIView.as_view(), name="buddy_create_group"),
    path('api/buddy/groups/view/<int:user_id>', ViewBuddyGroupsByUserIdAPIView.as_view(), name='buddy_view_groups_by_user_id'),
    path('api/buddy/group/<int:id>', ViewBuddyGroupAPIView.as_view(), name='buddy_view_group_by_id'),
    path('api/buddy/group/event/create', CreateBuddyGroupEventAPIView.as_view(), name='buddy_create_group_event'),
]
