class SemesterModel {
  String? year;
  final String? semesterName;
  String? semesterId;

  SemesterModel(
      {required this.year,
      required this.semesterName,
      required this.semesterId});

  factory SemesterModel.fromMap(
    String id,
    Map<String, dynamic> map,
  ) {
    return SemesterModel(
      year: map["year"],
      semesterId: id,
      semesterName: map['sem_name'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {"year": year, "sem_name": semesterName, "sem_id": semesterId};
  }
}
