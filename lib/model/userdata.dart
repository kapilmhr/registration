
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
  String platform = "";
  double latitude = 0.0;
  double longitude = 0.0;

  UserData(this.id,this.firstName, this.lastName, this.imei, this.date, this.email,
      this.passportNo, this.image,this.platform,this.latitude,this.longitude);
}