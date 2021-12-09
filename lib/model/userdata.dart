
import 'package:floor/floor.dart';

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

  UserData(this.id,this.firstName, this.lastName, this.imei, this.date, this.email,
      this.passportNo, this.image);
}