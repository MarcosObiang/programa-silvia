// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductEntity _$ProductEntityFromJson(Map<String, dynamic> json) =>
    ProductEntity(
      productName: json['productName'] as String,
      productId: json['productId'] as String,
      productCount: json['productCount'] as int,
      productsOut: json['productsOut'] as int,
      productsIn: json['productsIn'] as int,
      initialCount: json['initialCount'] as int,
    )
      ..productCreationDate = json['productCreationDate'] == null
          ? null
          : DateTime.parse(json['productCreationDate'] as String)
      ..productSelected = json['productSelected'] as bool?
      ..isSearchSugestion = json['isSearchSugestion'] as bool? ?? false;

Map<String, dynamic> _$ProductEntityToJson(ProductEntity instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'productId': instance.productId,
      'productCount': instance.productCount,
      'productsOut': instance.productsOut,
      'productsIn': instance.productsIn,
      'initialCount': instance.initialCount,
      'productCreationDate': instance.productCreationDate?.toIso8601String(),
      'productSelected': instance.productSelected,
      'isSearchSugestion': instance.isSearchSugestion,
    };
