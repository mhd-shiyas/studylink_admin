import 'package:flutter/material.dart';
import 'package:studylink_admin/repositories/home_repository.dart';

import '../models/semester_model.dart';
import '../models/subject_model.dart';

class HomeController with ChangeNotifier {
  final HomeRepository _homeRepository = HomeRepository();

  List<Map<String, dynamic>> _departmentModel = [];
  List<Map<String, dynamic>>? get department => _departmentModel;

  bool _isLoading = false;
  bool get isloading => _isLoading;

  Future<void> fetchDepartment() async {
    _isLoading = true;
    notifyListeners();

    _departmentModel = await _homeRepository.getDepartment();

    _isLoading = false;
    notifyListeners();
  }

  List<SemesterModel>? _semesters = [];
  List<SemesterModel>? get semesters => _semesters;

  bool _semesterisLoading = false;
  bool get isSemesterLoading => _semesterisLoading;

  Future<void> fetchSemesters(
    String departmentId,
    String year,
  ) async {
    _semesterisLoading = true;
    notifyListeners();

    _semesters = await _homeRepository.fetchSemesters(departmentId, year);

    _semesterisLoading = false;
    notifyListeners();
  }

  List<SubjectModel>? _subjects = [];
  List<SubjectModel>? get subjects => _subjects;

  bool _isSubjectLoading = false;
  bool get isSubjectLoading => _isSubjectLoading;

  Future<void> fetchSubject(String semesterId) async {
    _isSubjectLoading = true;
    notifyListeners();

    _subjects = await _homeRepository.fetchSubjects(semesterId);

    _isSubjectLoading = false;
    notifyListeners();
  }
}
