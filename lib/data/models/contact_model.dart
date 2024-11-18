import 'package:flutterpwa/data/dtos/request/create_contact_request_dto.dart';
import 'package:flutterpwa/data/dtos/response/create_contact_response_dto.dart';

class ContactModel {
  final String id;
  final String nombre;
  final String email;
  final String telefono;

  ContactModel({
    required this.id,
    required this.nombre,
    required this.email,
    required this.telefono,
  });

  ContactsResponseDto toResponseDto() {
    return ContactsResponseDto(
      id: id,
      nombre: nombre,
      email: email,
      telefono: telefono,
    );
  }

  factory ContactModel.fromDto(ContactsResponseDto dto) {
    return ContactModel(
      id: dto.id,
      nombre: dto.nombre,
      email: dto.email,
      telefono: dto.telefono,
    );
  }

  CreateContactRequestDto toRequestDto() {
    return CreateContactRequestDto(
      nombre: nombre,
      email: email,
      telefono: telefono,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      'email': email,
      'telefono': telefono,
    };
  }

  factory ContactModel.fromMap(Map<String, dynamic> map) {
    return ContactModel(
      id: map['id'],
      nombre: map['nombre'],
      email: map['email'],
      telefono: map['telefono'],
    );
  }
}
