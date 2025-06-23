// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'active_member_db_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ActiveMemberDbInfo _$ActiveMemberDbInfoFromJson(Map<String, dynamic> json) =>
    ActiveMemberDbInfo(
      role: json['Officer Role'] as String?,
      otherLinks:
          (json['Any Other links Be sure to adhere to format with commas and newlines - \nlinkedin1, https://linkedin.com/jondoe\nportfolio, https://portfolio.com/jondoe\n...']
                  as Map<String, dynamic>?)
              ?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      classification:
          json['Classification (based on graduation date)'] as String,
      description:
          json['Description about yourself to help you stand out'] as String,
      emailAddress: json['Email Address'] as String,
      expectedGraduationDate: json['Expected Graduation Date'] as String,
      firstName: json['First Name'] as String,
      lastName: json['Last Name'] as String,
      major: json['Major'] as String,
      personalEmail: json['Personal Email Address'] as String,
      phoneNumber: json['Phone Number (xxx) xxx-xxxx'] as String,
      resumeUrl: json['Please upload a PDF copy of your resume.'] as String,
      headshotUrl: json['Professional Headshots'] as String,
      tamuEmail: json['TAMU Email Address '] as String,
      timestamp: json['Timestamp'] as String,
    );

Map<String, dynamic> _$ActiveMemberDbInfoToJson(ActiveMemberDbInfo instance) =>
    <String, dynamic>{
      'Any Other links Be sure to adhere to format with commas and newlines - \nlinkedin1, https://linkedin.com/jondoe\nportfolio, https://portfolio.com/jondoe\n...':
          instance.otherLinks,
      'Classification (based on graduation date)': instance.classification,
      'Description about yourself to help you stand out': instance.description,
      'Email Address': instance.emailAddress,
      'Expected Graduation Date': instance.expectedGraduationDate,
      'First Name': instance.firstName,
      'Last Name': instance.lastName,
      'Major': instance.major,
      'Personal Email Address': instance.personalEmail,
      'Phone Number (xxx) xxx-xxxx': instance.phoneNumber,
      'Please upload a PDF copy of your resume.': instance.resumeUrl,
      'Professional Headshots': instance.headshotUrl,
      'TAMU Email Address ': instance.tamuEmail,
      'Timestamp': instance.timestamp,
      'Officer Role': instance.role,
    };
