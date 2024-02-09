import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';
part 'ProductEntity.g.dart';

@JsonSerializable()
class ProductEntity {
  String productName;
  String productId;
  int productCount;
  int productsOut;
  int productsIn;
  int initialCount;
  DateTime? productCreationDate;

  bool? productSelected = false;
  @JsonKey(defaultValue: false)
  bool isSearchSugestion = false;

  ProductEntity(
      {required this.productName,
      required this.productId,
      required this.productCount,
      required this.productsOut,
      required this.productsIn,
      required this.initialCount});

  factory ProductEntity.fromMap({required Map<String, dynamic> json}) {
    return _$ProductEntityFromJson(json);
  }

  Map<String, dynamic> toJson({required ProductEntity product}) {
    return _$ProductEntityToJson(product);
  }
}
