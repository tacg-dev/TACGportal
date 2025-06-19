import 'package:tacgportal/data/models/tacg_user.dart';
import 'package:tacgportal/data/repositories/interfaces/i_tacg_user_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TacgUserRepository implements ITacgUserRepository {
  List<TacgUser>? cachedUsers;

  DateTime? lastFetchDate;

  TacgUserRepository();

  @override
  Future<List<TacgUser>> getUsers({bool forceRefresh = false}) async {
    final shouldFetch = cachedUsers == null ||
        forceRefresh ||
        lastFetchDate == null ||
        DateTime.now().difference(lastFetchDate!).inMinutes > 30;

    if (shouldFetch) {
      try {
        // Get users collection from Firestore
        final QuerySnapshot querySnapshot =
            await FirebaseFirestore.instance.collection('users').get();

        // Convert each document to a TacgUser object using fromJson
        final users = querySnapshot.docs.map((doc) {
          // Merge document ID with document data
          final data = {'id': doc.id, ...doc.data() as Map<String, dynamic>};
          return TacgUser.fromJson(data);
        }).toList();
        
        // Update cache
        cachedUsers = users;
        lastFetchDate = DateTime.now();
        return users;
      } catch (e) {
        if (cachedUsers != null) {
          return cachedUsers!;
        }
        rethrow;
      }
    } else {
      return cachedUsers!;
    }
  }

  @override
  Future<void> addUser(TacgUser user) async {
    print("not for use currently");
  }

  @override
  Future<void> updateUser(TacgUser user) async {
    print("not for use currently");
  }

  @override
  Future<void> deleteUser(String userId) async {
    print("not for use currently");
  }
}
