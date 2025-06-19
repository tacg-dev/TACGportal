
import 'package:tacgportal/data/models/tacg_event.dart';


abstract class ITacgEventRepository {
  
  Future<List<TacgEvent>> getTacgEvents({bool forceRefresh = false});

  
  Future<void> addTacgEvent(TacgEvent event);

  
  Future<void> updateTacgEvent(TacgEvent event);

  
  Future<void> deleteTacgEvent(String eventId);
}