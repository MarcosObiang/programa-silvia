import 'package:json_annotation/json_annotation.dart';
part "stockChangeEntity.g.dart";

enum ChangeType { ADD, RETIRE, SELECT_CHANGE_TYPE }

@JsonSerializable()
class StockChangeEntity {
  String productName;
  String productId;
  int productCount;
  int? amountToChange;
  bool? productSelectedToBeChanged = false;
  String? changeType;
  StockChangeEntity({
    required this.productName,
    required this.productId,
    required this.productCount,
  });

  void selectChangeType({required ChangeType changeType}) {
    this.changeType = changeType.name;
  }

  factory StockChangeEntity.fromJson({required Map<String, dynamic> json}) {
    return _$StockChangeEntityFromJson(json);
  }

  Map<String, dynamic> toJson({required StockChangeEntity stockChangeEntity}) {
    return _$StockChangeEntityToJson(stockChangeEntity);
  }
}
