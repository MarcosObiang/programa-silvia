// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stockChangeEntity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockChangeEntity _$StockChangeEntityFromJson(Map<String, dynamic> json) =>
    StockChangeEntity(
      productName: json['productName'] as String,
      productId: json['productId'] as String,
      productCount: json['productCount'] as int,
    )
      ..amountToChange = json['amountToChange'] as int?
      ..productSelectedToBeChanged = json['productSelectedToBeChanged'] as bool?
      ..changeType = json['changeType'] as String?;

Map<String, dynamic> _$StockChangeEntityToJson(StockChangeEntity instance) =>
    <String, dynamic>{
      'productName': instance.productName,
      'productId': instance.productId,
      'productCount': instance.productCount,
      'amountToChange': instance.amountToChange,
      'productSelectedToBeChanged': instance.productSelectedToBeChanged,
      'changeType': instance.changeType,
    };
