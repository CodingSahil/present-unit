import 'package:equatable/equatable.dart';
import 'package:present_unit/models/college_registration/college_registration_models.dart';

class Course extends Equatable {
  const Course({
    required this.id,
    required this.name,
    required this.duration,
    required this.admin,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as num,
      name: json['name'] as String,
      duration: json['duration'] as num,
      admin: json['admin'] != null
          ? Admin.fromJson(json['admin'] as Map<String, dynamic>)
          : null,
    );
  }

  Course copyWith({
    num? id,
    String? name,
    num? duration,
    Admin? admin,
  }) {
    return Course(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      admin: admin ?? this.admin,
    );
  }

  final num id;
  final String name;
  final num duration;
  final Admin? admin;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      if (admin != null) 'admin': admin!.toJson(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        duration,
        admin,
      ];
}
