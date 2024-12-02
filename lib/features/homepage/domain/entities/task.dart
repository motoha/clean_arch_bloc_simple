class Task {
  final int locationId;
  final String locationName;
  final String locationLangitude;
  final String locationLongitude;
  final List<TaskDate> tasksDate;

  Task({
    required this.locationId,
    required this.locationName,
    required this.locationLangitude,
    required this.locationLongitude,
    required this.tasksDate,
  });
}

class TaskDate {
  final int date;
  final String statusKunjungan;
  final String timeStamp;
  final String fotoKunjungan;

  TaskDate({
    required this.date,
    required this.statusKunjungan,
    required this.timeStamp,
    required this.fotoKunjungan,
  });
}
