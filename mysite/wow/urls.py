from django import views
from django.urls import path
from . import views
urlpatterns = [ path('', views.PageView.as_view())] 