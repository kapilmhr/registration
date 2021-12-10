# Registration app

A new Flutter app for registraion.

## Getting Started

1.HomeScreen
  List all users who are already registered.
 
2.Registration
 Navigates from Home screen (app bar action + button ).Registers a new user

3.Save
Saves a user to database

# Libraries used

### 1. floor 
Floor provides a neat SQLite abstraction for your Flutter applications inspired by the Room persistence library

### 2. image_picker
A Flutter plugin for iOS and Android for picking images from the image library, and taking new pictures with the camera

Permission:
Android:
```
<uses-permission android:name="android.permission.CAMERA"/>
```

ios
```
<key>NSCameraUsageDescription</key>
<string>To capture image using camera</string>
```

### 3. Geolocator
A Flutter geolocation plugin which provides easy access to platform specific location services (FusedLocationProviderClient or if not available the LocationManager on Android and CLLocationManager on iOS).
 Permission:
 
 Android
```
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```
ios
```
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs access to location when open.</string>
<key>NSLocationAlwaysUsageDescription</key>
<string>This app needs access to location when in the background.</string>
```


### 4. device_information
A flutter plugin to get device information such as device IMEI number.
#### Only works with Android
Permission:
Need a permission to read phone state.
Android:
```
<uses-permission android:name="android.permission.READ_PHONE_STATE"/>
```


## Define UserData Model
```
@entity
class UserData{
  @PrimaryKey(autoGenerate: true)
  int? id;

  String firstName = "";
  String lastName = "";
  String imei = "";
  String date = "";
  String email = "";
  String passportNo = "";
  String image = "";
  String platform = "";
  double latitude = 0.0;
  double longitude = 0.0;

  UserData(this.id,this.firstName, this.lastName, this.imei, this.date, this.email,
      this.passportNo, this.image,this.platform,this.latitude,this.longitude);
}
```

## Setup Database
Define database
```
@Database(version: 1, entities: [UserData])
abstract class UserDatabase extends FloorDatabase{
  UserDao get userDao;
}
```
create DAO (data abstract providing list of all actions to be done in database)
```
@dao
abstract class UserDao{
  @Query('SELECT * FROM userdata')
  Future<List<UserData>> getAllUsers();

  @insert
  Future<void> insertPerson(UserData userData);
}
```

## Get IMEI number
This implies only to Android platform.

```
if (Platform.isAndroid) {
      await Permission.phone.request();
      var status = await Permission.phone.status;
      if (status.isGranted) {
        try {
          imeiNumber = await DeviceInformation.deviceIMEINumber;
        } catch (e) {
          print(e);
        }
        print(imeiNumber);
        imeiController.text = imeiNumber;
        setState(() {});
      }
    }
```

## Get user's location
This is a optional field, so when user denies to grant permission of location , default value 0.0 is stored in both latitude and longitude

```
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {

      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
 ```
 
 ## Insert data in database
 
 ```
  var user = UserData(
        null,
        fName,
        lName,
        imei,
        dob,
        "$email",
        "$passport",
        imageFile.path,
        Platform.operatingSystem,
        latitude,
        longitude);

    //insert in db
    db.insertPerson(user);
 ```

## Fetch all users from database
This is done in home screen

```
var db = await Database.getDatabase();
    List<UserData> users = await db.getAllUsers();
```

## Screenshots
<img src="https://github.com/kapilmhr/registration/blob/main/screenshots/Screenshot_1639112634.png" style="height:500px;"><img src="https://github.com/kapilmhr/registration/blob/main/screenshots/Screenshot_1639112722.png" style="height:500px;"><img src="https://github.com/kapilmhr/registration/blob/main/screenshots/Screenshot_1639112651.png" style="height:500px;"><img src="https://github.com/kapilmhr/registration/blob/main/screenshots/Screenshot_1639112672.png" style="height:500px;"><img src="https://github.com/kapilmhr/registration/blob/main/screenshots/Simulator%20Screen%20Shot%20-%20iPhone%2013%20Pro%20-%202021-12-10%20at%2011.17.10.png" style="height:500px;"><img src="https://github.com/kapilmhr/registration/blob/main/screenshots/Screenshot_1639112680.png" style="height:500px;"><img src="https://github.com/kapilmhr/registration/blob/main/screenshots/Screenshot_1639112750.png" style="height:500px;">




