import 'package:json_annotation/json_annotation.dart';

part 'reportDetailsEntity.g.dart';

@JsonSerializable(includeIfNull: true)
class ReportDetailsEntity {
  String changedBy;
  int productCountBeforeChange;
  int productCountAfterChange;
  DateTime changeDateTime;
  String changeType;
  String? productId;

  Map<String, dynamic>? departments;
  ReportDetailsEntity(
      {required this.changedBy,
      required this.productCountBeforeChange,
      required this.productCountAfterChange,
      required this.changeDateTime,
      required this.changeType,
      required this.departments,
      required this.productId});

  factory ReportDetailsEntity.fromJson(Map<String, dynamic> e) {
    return _$ReportDetailsEntityFromJson(e);
  }

  Map<String, dynamic> toJson({required ReportDetailsEntity instance}) {
    return _$ReportDetailsEntityToJson(instance);
  }
}
