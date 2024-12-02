import '../../domain/entities/user.dart';

class UserModel extends User {
  final int role;
  final int idRegion;
  final int idStation;
  final int? idAbsenShift;
  final String regionName;
  final String location;
  final int groupId;
  final String picture;
  final int expiredSecond;
  final String token;

  UserModel({
    required int id,
    required String name,
    required String email,
    required this.role,
    required this.idRegion,
    required this.idStation,
    this.idAbsenShift,
    required this.regionName,
    required this.location,
    required this.groupId,
    required this.picture,
    required this.expiredSecond,
    required this.token,
  }) : super(id: id, name: name, email: email);

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['data']['id'],
      name: json['data']['name'],
      email: json['data']['email'] ?? '', // Assuming email might not be present
      role: json['data']['role'],
      idRegion: json['data']['id_region'],
      idStation: json['data']['id_station'],
      idAbsenShift: json['data']['id_absen_shift'],
      regionName: json['data']['region_name'],
      location: json['data']['location'],
      groupId: json['data']['group_id'],
      picture: json['data']['picture'],
      expiredSecond: json['data']['expired_second'],
      token: json['token'],
    );
  }
}
