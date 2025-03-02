import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDataProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add Department (Firebase generates the ID)
  Future<void> addDepartment(String departmentName) async {
    try {
      DocumentReference docRef =
          await _firestore.collection('departments').add({
        'dep_name': departmentName,
        // 'year': year,
      });

      // Save the auto-generated ID in the document
      await docRef.update({'departmentId': docRef.id});

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add department: $e');
    }
  }

  Future<void> deleteDepartment(String departmentId) async {
    try {
      await _firestore.collection('departments').doc(departmentId).delete();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting department: $e');
      }
      rethrow;
    }
  }

  // Add Semester (Firebase generates the ID)
  Future<void> addSemester(
      String year, String semesterName, String departmentId) async {
    try {
      DocumentReference docRef = await _firestore.collection('semesters').add({
        'year': year,
        'sem_name': semesterName,
        "dep_id": departmentId,
      });

      // Save the auto-generated ID in the document
      await docRef.update({'sem_id': docRef.id});

      notifyListeners();
    } catch (e) {
      throw Exception('Failed to add semester: $e');
    }
  }

  Future<void> deleteSemester(String semesterId) async {
    try {
      await _firestore.collection('semesters').doc(semesterId).delete();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting department: $e');
      }
      rethrow;
    }
  }

  // Add Subject (Firebase generates the ID)
  Future<void> addSubject(String semesterId, String subjectName) async {
    try {
      DocumentReference docRef = await _firestore.collection('subjects').add({
        'sem_id': semesterId,
        'sub_name': subjectName,
      });

      // Save the auto-generated ID in the document
      await docRef.update({'sub_id': docRef.id});
    } catch (e) {
      throw Exception('Failed to add subject: $e');
    }
  }

  Future<void> deleteSubjects(String subjectId) async {
    try {
      await _firestore.collection('subjects').doc(subjectId).delete();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting department: $e');
      }
      rethrow;
    }
  }

  // Fetch Departments
  Future<List<Map<String, dynamic>>> fetchDepartments() async {
    try {
      final snapshot = await _firestore.collection('departments').get();
      return snapshot.docs
          .map((doc) =>
              {'departmentId': doc['departmentId'], 'name': doc['name']})
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch departments: $e');
    }
  }

  // Fetch Semesters by Department ID
  Future<List<Map<String, dynamic>>> fetchSemesters(String departmentId) async {
    try {
      final snapshot = await _firestore
          .collection('semesters')
          .where('departmentId', isEqualTo: departmentId)
          .get();
      return snapshot.docs
          .map((doc) => {
                'semesterId': doc['semesterId'],
                'departmentId': doc['departmentId'],
                'name': doc['name']
              })
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch semesters: $e');
    }
  }

  // Fetch Subjects by Semester ID
  Future<List<Map<String, dynamic>>> fetchSubjects(String semesterId) async {
    try {
      final snapshot = await _firestore
          .collection('subjects')
          .where('semesterId', isEqualTo: semesterId)
          .get();
      return snapshot.docs
          .map((doc) => {
                'subjectId': doc['subjectId'],
                'semesterId': doc['semesterId'],
                'name': doc['name']
              })
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch subjects: $e');
    }
  }
}
