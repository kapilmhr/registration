import 'package:register_app/database/dao.dart';
import 'package:register_app/database/userdatabase.dart';

class Database{

  static Future<UserDao> getDatabase() async{
    var db = await $FloorUserDatabase.databaseBuilder('app_database.db').build();
    return db.userDao;
  }
}