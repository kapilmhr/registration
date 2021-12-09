import 'dart:async';

import 'package:floor/floor.dart';
import 'package:register_app/database/dao.dart';
import 'package:register_app/model/userdata.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
part 'userdatabase.g.dart';

@Database(version: 1, entities: [UserData])
abstract class UserDatabase extends FloorDatabase{
  UserDao get userDao;
}