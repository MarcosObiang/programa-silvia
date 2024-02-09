// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'departmentEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DepartmentEntity _$DepartmentEntityFromJson(Map<String, dynamic> json) =>
    DepartmentEntity(
      departmentCreationDate:
          DateTime.parse(json['departmentCreationDate'] as String),
      departmentName: json['departmentName'] as String,
      departmentId: json['departmentId'] as String,
    )
      ..productWithdrawlCount = json['productWithdrawlCount'] as int? ?? 0
      ..productAddCount = json['productAddCount'] as int? ?? 0
      ..isDepartmenSelectedInTable =
          json['isDepartmenSelectedInTable'] as bool? ?? false;

Map<String, dynamic> _$DepartmentEntityToJson(DepartmentEntity instance) =>
    <String, dynamic>{
      'departmentCreationDate':
          instance.departmentCreationDate.toIso8601String(),
      'departmentName': instance.departmentName,
      'departmentId': instance.departmentId,
      'productWithdrawlCount': instance.productWithdrawlCount,
      'productAddCount': instance.productAddCount,
      'isDepartmenSelectedInTable': instance.isDepartmenSelectedInTable,
    };
