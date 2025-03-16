import 'package:present_unit/helpers/enum/common_enums.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';
import 'package:present_unit/models/faculty/faculty_model.dart';

class UserDetails {
  UserDetails({
    required this.admin,
    required this.faculty,
    required this.userType,
  });

  UserDetails copyWith({
    Admin? admin,
    Faculty? faculty,
    UserType? userType,
  }) {
    return UserDetails(
      admin: admin ?? this.admin,
      faculty: faculty ?? this.faculty,
      userType: userType ?? this.userType,
    );
  }

  factory UserDetails.clean() => UserDetails(
        admin: null,
        faculty: null,
        userType: UserType.none,
      );

  Admin? admin;
  Faculty? faculty;
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
