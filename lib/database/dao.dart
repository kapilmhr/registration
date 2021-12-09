import 'package:floor/floor.dart';
import 'package:register_app/model/userdata.dart';

@dao
abstract class UserDao{
  @Query('SELECT * FROM userdata')
  Future<List<UserData>> getAllUsers();

  @insert
  Future<void> insertPerson(UserData userData);
}