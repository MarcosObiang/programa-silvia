import 'package:json_annotation/json_annotation.dart';
part 'departmentEntity.g.dart';

@JsonSerializable()
class DepartmentEntity {
  DateTime departmentCreationDate;
  String departmentName;
  String departmentId;
  @JsonKey(defaultValue: 0)
  int? productWithdrawlCount;
  @JsonKey(defaultValue: 0)
  int? productAddCount;
  @JsonKey(defaultValue: false)
  bool isDepartmenSelectedInTable = false;
  DepartmentEntity({
    required this.departmentCreationDate,
    required this.departmentName,
    required this.departmentId,
  });

  factory DepartmentEntity.fromJson({required Map<String, dynamic> json}) {
    return _$DepartmentEntityFromJson(json);
  }

  Map<String, dynamic> toJson({required DepartmentEntity instance}) {
    return _$DepartmentEntityToJson(instance);
  }
}
