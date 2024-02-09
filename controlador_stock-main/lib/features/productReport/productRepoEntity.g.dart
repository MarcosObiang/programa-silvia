// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'productRepoEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductReportEntity _$ProductReportEntityFromJson(Map<String, dynamic> json) =>
    ProductReportEntity(
      reportDetails: (json['reportDetails'] as List<dynamic>?)
          ?.map((e) => ReportDetailsEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..productId = json['productId'] as String?
      ..productName = json['productName'] as String?
      ..departmentId = json['departmentId'] as String?
      ..fromDate = json['fromDate'] == null
          ? null
          : DateTime.parse(json['fromDate'] as String)
      ..toDate = json['toDate'] == null
          ? null
          : DateTime.parse(json['toDate'] as String)
      ..reportType = json['reportType'] as String?;

Map<String, dynamic> _$ProductReportEntityToJson(
        ProductReportEntity instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'departmentId': instance.departmentId,
      'fromDate': instance.fromDate?.toIso8601String(),
      'toDate': instance.toDate?.toIso8601String(),
      'reportType': instance.reportType,
      'reportDetails': instance.reportDetails,
    };
