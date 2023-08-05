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
from django.conf.urls.static import static
from django.conf import settings

urlpatterns = [
    path('admin/', admin.site.urls),
    path('api/token/refresh', TokenRefreshView.as_view(), name='token_refresh'),
    path('api/user/login', LoginUserAPIView.as_view(), name='user_login'),
    path('api/user/logout', LogoutUserAPIView.as_view(), name='user_logout'),
    path('api/user/signup', SignUpUserAPIView.as_view(), name="user_sign_up"),
    path('api/user/<int:id>', UserRetrieveAPIView.as_view(), name='user_view_by_id'),
    path('api/buddy/group/create', CreateBuddyGroupAPIView.as_view(), name="buddy_create_group"),
    path('api/buddy/groups', ViewAllBuddyGroupsAPIView.as_view(), name='buddy_view_all_groups'),
    path('api/buddy/groups/view/created/<int:user_id>', ViewBuddyGroupsCreatedByUserIdAPIView.as_view(), name='buddy_view_groups_created_by_user_id'),
    path('api/buddy/groups/view/joined/<int:user_id>', ViewBuddyGroupsJoinedByUserIdAPIView.as_view(), name='buddy_view_groups_joined_by_user_id'),
    path('api/buddy/group/<int:id>', ViewBuddyGroupAPIView.as_view(), name='buddy_view_group_by_id'),
    path('api/buddy/group/join', JoinBuddyGroupAPIView.as_view(), name='buddy_join_group_by_user_id'),
    path('api/buddy/group/leave', LeaveBuddyGroupAPIView.as_view(), name='buddy_leave_group_by_user_id'),
    path('api/buddy/group/event/create', CreateBuddyGroupEventAPIView.as_view(), name='buddy_create_group_event'),
    path('api/buddy/group/event/register', RegisterBuddyGroupEventAPIView.as_view(), name='buddy_register_group_event'),
    path('api/buddy/group/event/unregister', UnregisterBuddyGroupEventAPIView.as_view(), name='buddy_unregister_group_event'),
    path('api/buddy/group/event/<int:event_id>/members', ViewBuddyGroupEventMembersByEventIdAPIView.as_view(), name='buddy_view_group_event_members_by_event_id'),
    path('api/buddy/group/events/view/joined/<int:user_id>', ViewBuddyGroupEventsJoinedByUserIdAPIView.as_view(), name='buddy_view_group_events_joined_by_user_id'),
]

urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
