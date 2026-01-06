import 'package:json_annotation/json_annotation.dart';
import 'role.dart';

class RoleConverter implements JsonConverter<Role, Map<String, dynamic>> {
  const RoleConverter();

  @override
  Role fromJson(Map<String, dynamic> json) {
    final typeStr = json['type'] as String;
    final type = RoleType.values.firstWhere((e) => e.name == typeStr);
    
    switch (type) {
      case RoleType.civilian:
        return const CivilianRole();
      case RoleType.mafia:
        return MafiaRole(isDon: json['isDon'] as bool? ?? false);
      case RoleType.commissar:
        return const CommissarRole();
      case RoleType.doctor:
        return const DoctorRole();
      case RoleType.prostitute:
        return const ProstituteRole();
      case RoleType.maniac:
        return const ManiacRole();
      case RoleType.sergeant:
        return const SergeantRole();
      case RoleType.lawyer:
        return const LawyerRole();
      case RoleType.poisoner:
        return const PoisonerRole();
    }
  }

  @override
  Map<String, dynamic> toJson(Role role) {
    return {
      'type': role.type.name,
      if (role is MafiaRole) 'isDon': role.isDon,
    };
  }
}
