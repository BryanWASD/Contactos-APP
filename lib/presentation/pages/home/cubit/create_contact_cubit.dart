import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterpwa/data/dtos/request/create_contact_request_dto.dart';
import 'package:flutterpwa/data/main/api_data.dart';
import 'package:meta/meta.dart';

part 'create_contact_state.dart';

class CreateContactCubit extends Cubit<CreateContactState> {
  CreateContactCubit() : super(CreateContactInitial());

  void createContact(String nombre, String email, String telefono) async {
    emit(CreateContactLoading());
    try {
      final dio = Dio();
      final client = ApiClient(dio);

      final contact = CreateContactRequestDto(
        nombre: nombre,
        email: email,
        telefono: telefono,
      );
      await client.createContact(contact);
      emit(CreateContactSuccess());
    } catch (e) {
      emit(CreateContactError());
    }
  }

  void updateContact(
      String id, String nombre, String email, String telefono) async {
    emit(CreateContactLoading());
    try {
      final dio = Dio();
      final client = ApiClient(dio);
      final request = CreateContactRequestDto(
          nombre: nombre, email: email, telefono: telefono);
      await client.updateContact(id, request);
      emit(CreateContactSuccess());
    } catch (e) {
      emit(CreateContactError());
    }
  }

  void deleteEvent(String id) async {
    emit(CreateContactLoading());
    try {
      final dio = Dio();
      final client = ApiClient(dio);
      await client.deleteContact(id);
      emit(CreateContactSuccess());
    } catch (e) {
      emit(CreateContactError());
    }
  }
}
