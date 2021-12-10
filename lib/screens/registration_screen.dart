import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:register_app/model/userdata.dart';
import 'package:register_app/utils/utils.dart';

import '../global/DeviceInformation.dart';
import '../global/database.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  String imeiNumber = "";
  int age = 0;
  File imageFile = File("");
  TextEditingController imeiController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController passportController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Registration"),
      ),
      body: Container(
        margin: EdgeInsets.all(15),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: imeiController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: "IMEI",
                    counterText: "",
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.black54),
                  ),
                  maxLength: 16,
                  validator: (value) =>
                      value!.isEmpty ? 'IMEI cannot be empty' : null,
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: firstNameController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: "First Name",
                    counterText: "",
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.black54),
                  ),
                  maxLength: 16,
                  validator: (value) =>
                      value!.isEmpty ? 'First Name cannot be empty' : null,
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  controller: lastNameController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: "Last Name",
                    counterText: "",
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.black54),
                  ),
                  maxLength: 16,
                  validator: (value) =>
                      value!.isEmpty ? 'Last Name cannot be empty' : null,
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  readOnly: true,
                  controller: dateController,
                  style: const TextStyle(color: Colors.black),
                  onTap: () async {
                    DateTime? date = await Utils().selectDate(context);
                    if (date != null) {
                      age = ((DateTime.now().difference(date).inDays) / 365)
                          .toInt();
                      print(age.toInt());
                      String formattedDate =
                          DateFormat("dd/MM/yyyy").format(date);
                      dateController.text = "${formattedDate}";
                      setState(() {});
                    }
                  },
                  decoration: const InputDecoration(
                    labelText: "Date of Birth",
                    counterText: "",
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.black54),
                  ),
                  maxLength: 16,
                  validator: (value) =>
                      value!.isEmpty ? 'Date of Birth cannot be empty' : null,
                  keyboardType: TextInputType.number,
                ),
                age > 18
                    ? TextFormField(
                        controller: passportController,
                        style: const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                          labelText: "Passport Number",
                          counterText: "",
                          fillColor: Colors.white,
                          labelStyle: TextStyle(color: Colors.black54),
                        ),
                        maxLength: 16,
                        validator: (value) => age > 18
                            ? (value!.isEmpty
                                ? 'Passport Number cannot be empty'
                                : null)
                            : null,
                        keyboardType: TextInputType.number,
                      )
                    : SizedBox(),
                TextFormField(
                  controller: emailController,
                  style: const TextStyle(color: Colors.black),
                  decoration: const InputDecoration(
                    labelText: "Email",
                    counterText: "",
                    fillColor: Colors.white,
                    labelStyle: TextStyle(color: Colors.black54),
                  ),
                  maxLength: 16,
                  validator: (value) =>
                      value!.isNotEmpty ? Utils().validateEmail(value) : null,
                  keyboardType: TextInputType.number,
                ),
                GestureDetector(
                  onTap: () async {
                    var photo = await ImagePicker()
                        .pickImage(source: ImageSource.camera);
                    if (photo != null) {
                      imageFile = File(photo.path);
                    }
                    setState(() {});
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    margin: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blueAccent)),
                    child: (imageFile.path != null && imageFile.path.isNotEmpty)
                        ? Image.file(
                            File(imageFile.path),
                            fit: BoxFit.cover,
                          )
                        : Icon(Icons.add),
                  ),
                ),
                MaterialButton(
                  minWidth: MediaQuery.of(context).size.width,
                  color: Colors.blueAccent,
                  onPressed: () => validateForm(),
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  getInfo() async {
    print(Platform.operatingSystem);
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
  }

  validateForm() {
    if (!_formKey.currentState!.validate()) return;

    if (imageFile.path.isEmpty) {
      final snackBar = SnackBar(
        content: const Text('Please add the image'),
        action: SnackBarAction(
          label: 'Close',
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return;
    }

    insertData();
  }

  insertData() async {
    //intitialize database
    var db = await Database.getDatabase();

    //check location permission and get user position
    var position;
    try{
      position = await _determinePosition();
    }catch(e){
      print(e);
    }

    var fName = firstNameController.value.text;
    var lName = lastNameController.value.text;
    var imei = imeiController.value.text;
    var dob = dateController.value.text;
    var email = emailController.value.text;
    var passport = passportController.value.text;
    var latitude = position!=null?position.latitude:0.0;
    var longitude = position!=null?position.longitude:0.0;

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
    Navigator.pop(context, user);
  }

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
}
