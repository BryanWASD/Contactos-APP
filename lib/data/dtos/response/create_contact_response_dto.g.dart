// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_contact_response_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ContactsResponseDto _$ContactsResponseDtoFromJson(Map<String, dynamic> json) =>
    ContactsResponseDto(
      id: json['_id'] as String,
      nombre: json['nombre'] as String,
      email: json['email'] as String,
      telefono: json['telefono'] as String,
    );

Map<String, dynamic> _$ContactsResponseDtoToJson(
        ContactsResponseDto instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'nombre': instance.nombre,
      'email': instance.email,
      'telefono': instance.telefono,
    };
