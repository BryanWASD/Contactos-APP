// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_contact_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateContactRequestDto _$CreateContactRequestDtoFromJson(
        Map<String, dynamic> json) =>
    CreateContactRequestDto(
      nombre: json['nombre'] as String,
      email: json['email'] as String,
      telefono: json['telefono'] as String,
    );

Map<String, dynamic> _$CreateContactRequestDtoToJson(
        CreateContactRequestDto instance) =>
    <String, dynamic>{
      'nombre': instance.nombre,
      'email': instance.email,
      'telefono': instance.telefono,
    };
