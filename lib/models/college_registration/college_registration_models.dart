import 'package:equatable/equatable.dart';

class College extends Equatable {
  const College({
    required this.id,
    required this.name,
    required this.email,
    required this.location,
    required this.noOfDepartments,
    required this.noOfCourses,
    required this.websiteUrl,
    this.admin,
  });

  final num id;
  final String name;
  final String email;
  final String location;
  final num noOfDepartments;
  final num noOfCourses;
  final String websiteUrl;
  final Admin? admin;

  factory College.fromJson(Map<String, dynamic> json) => College(
        id: json['id'] as num,
        name: json['name'] as String,
        email: json['email'] as String? ?? '',
        location: json['location'] as String,
        noOfDepartments: json['noOfDepartments'] as num,
        noOfCourses: json['noOfCourses'] as num,
        websiteUrl: json['websiteUrl'] as String,
        admin: json['admin'] != null
            ? Admin.fromJson(
                json['admin'] as Map<String, dynamic>,
              )
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'location': location,
        'noOfDepartments': noOfDepartments,
        'noOfCourses': noOfCourses,
        'websiteUrl': websiteUrl,
        if (admin != null) 'admin': admin?.toJson(),
      };

  College copyWith({
    num? id,
    String? name,
    String? email,
    String? location,
    num? noOfDepartments,
    num? noOfCourses,
    String? websiteUrl,
    Admin? admin,
  }) =>
      College(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        location: location ?? this.location,
        noOfDepartments: noOfDepartments ?? this.noOfDepartments,
        noOfCourses: noOfCourses ?? this.noOfCourses,
        websiteUrl: websiteUrl ?? this.websiteUrl,
        admin: admin ?? this.admin,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        location,
        noOfDepartments,
        noOfCourses,
        websiteUrl,
        admin,
      ];
}

class Admin extends Equatable {
  const Admin({
    required this.id,
    required this.email,
    required this.password,
    required this.mobileNumber,
    this.fcmToken,
    this.college,
  });

  final num id;
  final String email;
  final String password;
  final String mobileNumber;
  final String? fcmToken;
  final College? college;

  factory Admin.fromJson(Map<String, dynamic> json) => Admin(
        id: json['id'] as num,
        email: json['email'] as String,
        password: json['password'] as String,
        mobileNumber: json['mobileNumber'] as String,
        fcmToken: json['fcmToken'] as String? ?? '',
        college: json['college'] != null
            ? College.fromJson(json['college'] as Map<String, dynamic>)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'password': password,
        'mobileNumber': mobileNumber,
        if (fcmToken != null && fcmToken!.isNotEmpty) 'fcmToken': fcmToken,
        if (college != null) 'college': college!.toJson(),
      };

  Admin copyWith({
    num? id,
    String? email,
    String? password,
    String? mobileNumber,
    String? fcmToken,
    College? college,
  }) =>
      Admin(
        id: id ?? this.id,
        email: email ?? this.email,
        password: password ?? this.password,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        fcmToken: fcmToken ?? this.fcmToken,
        college: college ?? this.college,
      );

  @override
  List<Object?> get props => [
        id,
        email,
        password,
        mobileNumber,
        fcmToken,
        college,
      ];
}
