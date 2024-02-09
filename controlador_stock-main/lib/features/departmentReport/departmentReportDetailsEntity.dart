import 'package:json_annotation/json_annotation.dart';
part 'departmentReportDetailsEntity.g.dart';

@JsonSerializable()
class DepartmentReportDetailsEntity {
  DateTime changeDateTime;
  String changeType;
  String changedBy;
  String productId;
  String productName;
  int productCountBeforeChange;
  int productCountAfterChange;
  Map<String, dynamic>? departments;
  DepartmentReportDetailsEntity({
    required this.changedBy,
    required this.productCountBeforeChange,
    required this.productCountAfterChange,
    required this.changeDateTime,
    required this.changeType,
    required this.departments,
    required this.productId,
    required this.productName,
  });

  factory DepartmentReportDetailsEntity.fromJson(Map<String, dynamic> e) {
    return _$DepartmentReportDetailsEntityFromJson(e);
  }

  Map<String, dynamic> toJson(
      {required DepartmentReportDetailsEntity instance}) {
    return _$DepartmentReportDetailsEntityToJson(instance);
  }
}
