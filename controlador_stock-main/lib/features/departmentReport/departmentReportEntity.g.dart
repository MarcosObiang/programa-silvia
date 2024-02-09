// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'departmentReportEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartmentReportEntity _$DepartmentReportEntityFromJson(
        Map<String, dynamic> json) =>
    DepartmentReportEntity(
      departmentId: json['departmentId'] as String,
      departmentName: json['departmentName'] as String,
      fromDate: DateTime.parse(json['fromDate'] as String),
      toDate: DateTime.parse(json['toDate'] as String),
      reportDetails: (json['reportDetails'] as List<dynamic>)
          .map((e) =>
              DepartmentReportDetailsEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DepartmentReportEntityToJson(
        DepartmentReportEntity instance) =>
    <String, dynamic>{
      'departmentId': instance.departmentId,
      'departmentName': instance.departmentName,
      'fromDate': instance.fromDate.toIso8601String(),
      'toDate': instance.toDate.toIso8601String(),
      'reportDetails': instance.reportDetails,
    };
