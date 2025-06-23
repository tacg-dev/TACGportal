import 'package:json_annotation/json_annotation.dart';

part 'active_member_db_info.g.dart';

@JsonSerializable()
class ActiveMemberDbInfo {
  @JsonKey(name: "Any Other links Be sure to adhere to format with commas and newlines - \nlinkedin1, https://linkedin.com/jondoe\nportfolio, https://portfolio.com/jondoe\n...")
  final Map<String, String>? otherLinks;

  @JsonKey(name: 'Classification (based on graduation date)')
  final String classification;

  @JsonKey(name: 'Description about yourself to help you stand out')
  final String description;

  @JsonKey(name: 'Email Address')
  final String emailAddress;

  @JsonKey(name: 'Expected Graduation Date')
  final String expectedGraduationDate;

  @JsonKey(name: 'First Name')
  final String firstName;

  @JsonKey(name: 'Last Name')
  final String lastName;

  @JsonKey(name: 'Major')
  final String major;

  @JsonKey(name: 'Personal Email Address')
  final String personalEmail;

  @JsonKey(name: 'Phone Number (xxx) xxx-xxxx')
  final String phoneNumber;

  @JsonKey(name: 'Please upload a PDF copy of your resume.')
  final String resumeUrl;

  @JsonKey(name: 'Professional Headshots')
  final String headshotUrl;

  @JsonKey(name: 'TAMU Email Address ')
  final String tamuEmail;

  @JsonKey(name: 'Timestamp')
  final String timestamp;

  @JsonKey(name: 'Officer Role')
  final String? role; // Optional field for role, if needed

  ActiveMemberDbInfo({
    this.role,
    this.otherLinks,
    required this.classification,
    required this.description,
    required this.emailAddress,
    required this.expectedGraduationDate,
    required this.firstName,
    required this.lastName,
    required this.major,
    required this.personalEmail,
    required this.phoneNumber,
    required this.resumeUrl,
    required this.headshotUrl,
    required this.tamuEmail,
    required this.timestamp,
  });

  factory ActiveMemberDbInfo.fromJson(Map<String, dynamic> json) => 
      _$ActiveMemberDbInfoFromJson(json);

  Map<String, dynamic> toJson() => _$ActiveMemberDbInfoToJson(this);

  @override
  String toString() {
    return 'ActiveMemberDbInfo{firstName: $firstName, lastName: $lastName, classification: $classification, major: $major}';
  }
}