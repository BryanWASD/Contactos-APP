import 'package:json_annotation/json_annotation.dart';
part 'create_contact_request_dto.g.dart';

@JsonSerializable()
class CreateContactRequestDto {
  CreateContactRequestDto({
    required this.nombre,
    required this.email,
    required this.telefono,
  });

  final String nombre;
  final String email;
  final String telefono;

  factory CreateContactRequestDto.fromJson(Map<String, dynamic> json) =>
      _$CreateContactRequestDtoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateContactRequestDtoToJson(this);
}
