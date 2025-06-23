import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tacgportal/data/models/active_member_db_info.dart';


Future<List<ActiveMemberDbInfo>> fetchActiveMemberDatabase(bool leaders) async {
  var url = leaders
      ? "https://web-backend.vercel.app/api/active-leader-data" 
      : "https://web-backend.vercel.app/api/sheet-data";
  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    try{
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List<dynamic> jsonActiveMembers = jsonResponse['data'];
      // for (var activeMember in jsonActiveMembers) {
      //   print(activeMember);
      //   print("----------------------");
      //   ActiveMemberDbInfo test =  ActiveMemberDbInfo.fromJson(activeMember);
      
      // }
      return jsonActiveMembers.map((activeMember) {
       return ActiveMemberDbInfo.fromJson(activeMember);
       }).toList(); 

    }catch  (e) {
      throw Exception('Failed to parse active member database : $e');
    }
  }
  else {
    throw Exception('Failed to load active member database');
  }
}


// Future<List<ActiveLeaderDbInfo>> fetchActiveLeaderDatabase() async {
//   var url = "https://web-backend.vercel.app/api/active-leader-data";
//   final response = await http.get(
//     Uri.parse(url),
//     headers: {
//       'Accept': 'application/json',
//       'Content-Type': 'application/json',
//     },
//   );

//   if (response.statusCode == 200) {
//     try{
//       final Map<String, dynamic> jsonResponse = json.decode(response.body);
//       final List<dynamic> jsonActiveLeaders = jsonResponse['data'];
//       return jsonActiveLeaders.map((activeLeader) {
//         return ActiveLeaderDbInfo.fromJson(activeLeader);
//       }).toList(); 

//     }catch (e) {
//       throw Exception('Failed to parse active leader database : $e');
//     }
//   }
//   else {
//     throw Exception('Failed to load active leader database');
//   }
// }