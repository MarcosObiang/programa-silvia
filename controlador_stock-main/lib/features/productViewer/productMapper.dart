import 'package:stockcontrollerterminal/Utils/interfaces/Mapper.dart';
import 'ProductEntity.dart';

class ProductMapper implements FromEntity<ProductEntity> {
  @override
  Map<String, dynamic> toMap(ProductEntity data) {
    return data.toJson(product: data);
  }
}
