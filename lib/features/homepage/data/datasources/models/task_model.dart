import '../../../domain/entities/task.dart';

class TaskModel extends Task {
  TaskModel({
    required int locationId,
    required String locationName,
    required String locationLangitude,
    required String locationLongitude,
    required List<TaskDateModel> tasksDate,
  }) : super(
          locationId: locationId,
          locationName: locationName,
          locationLangitude: locationLangitude,
          locationLongitude: locationLongitude,
          tasksDate: tasksDate,
        );

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      locationId: json['location_id'] ?? 0,
      locationName: json['location_name'] ?? '',
      locationLangitude: json['location_langitude'] ?? '',
      locationLongitude: json['location_longitude'] ?? '',
      tasksDate: List<TaskDateModel>.from(
        json['tasks_date'].map((taskDate) => TaskDateModel.fromJson(taskDate)),
      ),
    );
  }
}

class TaskDateModel extends TaskDate {
  TaskDateModel({
    required int date,
    required String statusKunjungan,
    required String timeStamp,
    required String fotoKunjungan,
  }) : super(
          date: date,
          statusKunjungan: statusKunjungan,
          timeStamp: timeStamp,
          fotoKunjungan: fotoKunjungan,
        );

  factory TaskDateModel.fromJson(Map<String, dynamic> json) {
    return TaskDateModel(
      date: json['date'] ?? 0,
      statusKunjungan: json['status_kunjungan'] ?? '',
      timeStamp: json['time_stamp'] ?? '',
      fotoKunjungan: json['foto_kunjungan'] ?? '',
    );
  }
}
