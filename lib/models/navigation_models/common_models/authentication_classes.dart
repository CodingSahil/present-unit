import 'package:present_unit/helpers/enum/common_enums.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';

class UserDetails {
  UserDetails({
    required this.admin,
    required this.userType,
  });

  Admin? admin;
  UserType? userType;
}

UserType fetchUserType({
  required String userTypeString,
}) {
  if (userTypeString == UserType.admin.toString()) {
    return UserType.admin;
  }
  if (userTypeString == UserType.faculty.toString()) {
    return UserType.faculty;
  }
  if (userTypeString == UserType.student.toString()) {
    return UserType.student;
  }
  return UserType.none;
}
