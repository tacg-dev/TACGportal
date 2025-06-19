import 'package:tacgportal/data/models/tacg_user.dart';

abstract class ITacgUserRepository {
  Future<List<TacgUser>> getUsers({bool forceRefresh = false});
  Future<void> addUser(TacgUser user);
  Future<void> updateUser(TacgUser user);
  Future<void> deleteUser(String userId);
}
