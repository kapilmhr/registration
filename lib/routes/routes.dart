import 'package:flutter/material.dart';
import 'package:register_app/model/userdata.dart';

import '../screens/registration_screen.dart';

class Routes {
  Future<dynamic> navigateToRegistration(context) async{
    return await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegistrationScreen()),
    );
  }
}