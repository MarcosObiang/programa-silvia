import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

import 'departmentReportDetailsEntity.dart';
part 'departmentReportEntity.g.dart';

@JsonSerializable()
class DepartmentReportEntity {
  String departmentId;
  String departmentName;
  DateTime fromDate;
  DateTime toDate;
  @JsonKey(defaultValue: false)
  bool isReportComplete = false;
  List<DepartmentReportDetailsEntity> reportDetails;

  DepartmentReportEntity({
    required this.departmentId,
    required this.departmentName,
    required this.fromDate,
    required this.toDate,
    required this.reportDetails,
  });

  factory DepartmentReportEntity.fromJson(Map<String, dynamic> json) {
    return _$DepartmentReportEntityFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$DepartmentReportEntityToJson(this);
  }

  bool isReportDetailsFullyLoaded() {
    if (reportDetails.length % 25 == 0 && isReportComplete == true) {
      return true;
    } else {
      return false;
    }
  }
}
