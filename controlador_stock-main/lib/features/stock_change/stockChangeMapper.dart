import 'package:stockcontrollerterminal/Utils/interfaces/Mapper.dart';
import 'package:stockcontrollerterminal/features/stock_change/stockChangeEntity.dart';

class StockChangeMapper
    implements FromEntity<StockChangeEntity>, ToEntity<StockChangeEntity> {
  @override
  StockChangeEntity fromMap({required Map data}) {
    return StockChangeEntity.fromJson(json: data as Map<String, dynamic>);
  }

  @override
  Map<String, dynamic> toMap(StockChangeEntity data) {
    return data.toJson(stockChangeEntity: data);
  }
}
