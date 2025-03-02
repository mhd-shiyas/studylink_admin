import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _pendingRequests = [];

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get pendingRequests => _pendingRequests;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  // Fetch pending teacher requests from Firestore
  Future<void> fetchPendingRequests() async {
    setLoading(true);
    try {
      final snapshot =
          await _firestore.collection('teachers_pending_approvals').get();
      List<Map<String, dynamic>> requests = [];

      // For each pending request, fetch more details from the 'teachers' collection
      for (var doc in snapshot.docs) {
        var teacherId = doc.id;
        var teacherDoc =
            await _firestore.collection('teachers').doc(teacherId).get();

        if (teacherDoc.exists) {
          requests.add({
            'teacherId': teacherId,
            'name': teacherDoc['name'],
            'department': teacherDoc['department'],
            'email': doc['email'],
            'status': doc['status'] ?? 'Pending',
          });
        }
      }

      _pendingRequests = requests;
      setLoading(false);
      notifyListeners();
    } catch (e) {
      setLoading(false);
      throw Exception('Failed to load requests: $e');
    }
  }

  // Approve a teacher request
  Future<void> approveRequest(String teacherId) async {
    setLoading(true);
    try {
      await _firestore
          .collection('teachers_pending_approvals')
          .doc(teacherId)
          .update({'status': 'Approved'});
      await _firestore
          .collection('teachers')
          .doc(teacherId)
          .update({'approvel': true});
      await _firestore
          .collection('teachers_pending_approvals')
          .doc(teacherId)
          .delete();

      setLoading(false);
      fetchPendingRequests(); // Refresh the list
    } catch (e) {
      setLoading(false);
      throw Exception('Failed to approve request: $e');
    }
  }

  // Reject a teacher request
  Future<void> rejectRequest(String teacherId) async {
    setLoading(true);
    try {
      await _firestore
          .collection('teachers_pending_approvals')
          .doc(teacherId)
          .update({'status': 'Rejected'});
      await _firestore
          .collection('teachers_pending_approvals')
          .doc(teacherId)
          .delete();

      setLoading(false);
      fetchPendingRequests(); // Refresh the list
    } catch (e) {
      setLoading(false);
      throw Exception('Failed to reject request: $e');
    }
  }
}

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class AdminProvider extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // List of teacher requests
//   List<Map<String, dynamic>> teacherRequests = [];

//   // Fetch teacher requests from Firestore
//   Future<void> fetchTeacherRequests() async {
//     final snapshot =
//         await _firestore.collection('teachers_teachers_pending_approvals').get();
//     teacherRequests = snapshot.docs
//         .map((doc) => {
//               'id': doc.id,
//               ...doc.data(),
//             })
//         .toList();
//     notifyListeners();
//   }

//   // Approve or reject a teacher request
//   Future<void> updateTeacherRequest(String requestId, bool isApproved) async {
//     final status = isApproved ? 'approved' : 'rejected';
//     await _firestore
//         .collection('teachers_teachers_pending_approvals')
//         .doc(requestId)
//         .update({
//       'status': status,
//     });

//     // Refresh the requests
//     await fetchTeacherRequests();
//   }

//   // Add a semester or language to Firestore
//   Future<void> addSemesterOrLanguage(String collection, String name) async {
//     await _firestore.collection(collection).add({
//       'name': name,
//       'timestamp': FieldValue.serverTimestamp(),
//     });
//     notifyListeners();
//   }
// }
