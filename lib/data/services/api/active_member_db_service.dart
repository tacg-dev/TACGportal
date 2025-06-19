import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tacgportal/data/models/active_member_db_info.dart';


Future<List<ActiveMemberDbInfo>> fetchActiveMemberDatabase() async {
  var url = "https://web-backend.vercel.app/api/sheet-data";
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