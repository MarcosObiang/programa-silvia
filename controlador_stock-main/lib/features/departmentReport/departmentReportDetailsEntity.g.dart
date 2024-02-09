// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'departmentReportDetailsEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartmentReportDetailsEntity _$DepartmentReportDetailsEntityFromJson(
        Map<String, dynamic> json) =>
    DepartmentReportDetailsEntity(
      changedBy: json['changedBy'] as String,
      productCountBeforeChange: json['productCountBeforeChange'] as int,
      productCountAfterChange: json['productCountAfterChange'] as int,
      changeDateTime: DateTime.parse(json['changeDateTime'] as String),
      changeType: json['changeType'] as String,
      departments: json['departments'] as Map<String, dynamic>?,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
    );

Map<String, dynamic> _$DepartmentReportDetailsEntityToJson(
        DepartmentReportDetailsEntity instance) =>
    <String, dynamic>{
      'changeDateTime': instance.changeDateTime.toIso8601String(),
      'changeType': instance.changeType,
      'changedBy': instance.changedBy,
      'productId': instance.productId,
      'productName': instance.productName,
      'productCountBeforeChange': instance.productCountBeforeChange,
      'productCountAfterChange': instance.productCountAfterChange,
      'departments': instance.departments,
    };
