// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductModelImpl _$$ProductModelImplFromJson(Map<String, dynamic> json) =>
    _$ProductModelImpl(
      id: json['id'] as String?,
      name: json['name'] as String,
      category:
          CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      price: json['price'] as num,
      stock: json['stock'] as num,
      imageUrl: json['imageUrl'] as String,
      description: json['description'] as String?,
      avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0.0,
      featured: json['featured'] as bool? ?? false,
      available: json['available'] as bool? ?? true,
      discount: json['discount'] as int? ?? 0,
    );

Map<String, dynamic> _$$ProductModelImplToJson(_$ProductModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'category': instance.category.toJson(),
      'price': instance.price,
      'stock': instance.stock,
      'imageUrl': instance.imageUrl,
      'description': instance.description,
      'avgRating': instance.avgRating,
      'featured': instance.featured,
      'available': instance.available,
      'discount': instance.discount,
    };
