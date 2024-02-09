import 'package:json_annotation/json_annotation.dart';
import 'package:stockcontrollerterminal/features/productReport/reportDetailsEntity.dart';
part 'productRepoEntity.g.dart';

@JsonSerializable()
class ProductReportEntity {
  String? productId;
  String? productName;
  String? departmentId;
  DateTime? fromDate;
  DateTime? toDate;
  String? reportType;
  List<ReportDetailsEntity>? reportDetails;

  ProductReportEntity({required this.reportDetails});

  factory ProductReportEntity.fromMap(Map<String, dynamic> json) {
    return _$ProductReportEntityFromJson(json);
  }

  Map<String, dynamic> toJson({required ProductReportEntity instance}) {
    return _$ProductReportEntityToJson(instance);
  }
}
