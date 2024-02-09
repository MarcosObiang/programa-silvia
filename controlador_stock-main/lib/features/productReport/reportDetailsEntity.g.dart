// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reportDetailsEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportDetailsEntity _$ReportDetailsEntityFromJson(Map<String, dynamic> json) =>
    ReportDetailsEntity(
      changedBy: json['changedBy'] as String,
      productCountBeforeChange: json['productCountBeforeChange'] as int,
      productCountAfterChange: json['productCountAfterChange'] as int,
      changeDateTime: DateTime.parse(json['changeDateTime'] as String),
      changeType: json['changeType'] as String,
      departments: json['departments'] as Map<String, dynamic>?,
      productId: json['productId'] as String?,
    );

Map<String, dynamic> _$ReportDetailsEntityToJson(
        ReportDetailsEntity instance) =>
    <String, dynamic>{
      'changedBy': instance.changedBy,
      'productCountBeforeChange': instance.productCountBeforeChange,
      'productCountAfterChange': instance.productCountAfterChange,
      'changeDateTime': instance.changeDateTime.toIso8601String(),
      'changeType': instance.changeType,
      'productId': instance.productId,
      'departments': instance.departments,
    };
