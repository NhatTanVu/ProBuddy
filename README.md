# ProBuddy
A cross-platform mobile app for connecting individuals for fun and professional opportunities
# Setup frontend (Flutter + Android Studio)
1. Install [Flutter](https://docs.flutter.dev/get-started/install/windows)
2. Open "**frontend**" folder on Android Studio and run the mobile app
# Setup backend (Django REST Framework + VS Code)
1. Install Python
2. Open command line, and run:
```
  1. cd backend\Pro_Buddy_APIs
  2. py -m venv env
  3. env\Scripts\activate
  4. pip install -r requirements.txt
```
3. Open MySQL and create DB named "**pro_buddy**"
4. Go back to command line, and run:
```
  manage.py migrate
```
5. Go back to command line, and run:
```   
  manage.py runserver
```
