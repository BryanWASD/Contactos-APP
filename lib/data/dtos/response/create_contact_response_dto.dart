import 'package:json_annotation/json_annotation.dart';
part 'create_contact_response_dto.g.dart';

@JsonSerializable()
class ContactsResponseDto {
  ContactsResponseDto({
    required this.id,
    required this.nombre,
    required this.email,
    required this.telefono,
  });
  @JsonKey(name: '_id')
  final String id;
  final String nombre;
  final String email;
  final String telefono;

  factory ContactsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ContactsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$ContactsResponseDtoToJson(this);
}
