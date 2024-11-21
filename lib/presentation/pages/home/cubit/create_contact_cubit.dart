import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutterpwa/data/dtos/request/create_contact_request_dto.dart';
import 'package:flutterpwa/data/local/db_helper.dart';
import 'package:flutterpwa/data/main/api_data.dart';
import 'package:flutterpwa/data/models/contact_model.dart';
import 'package:flutterpwa/services/notifications_servide.dart';
import 'package:meta/meta.dart';

part 'create_contact_state.dart';

class CreateContactCubit extends Cubit<CreateContactState> {
  final LocalDatabaseHelper dbHelper;

  CreateContactCubit(this.dbHelper) : super(CreateContactInitial());

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

      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        // Guardar contacto localmente
        final localContact = ContactModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          nombre: nombre,
          email: email,
          telefono: telefono,
        );
        await dbHelper.insertContact(localContact);
        notifyUserCreation(nombre);
        emit(CreateContactSuccess());
      } else {
        // Guardar contacto directamente en el servidor
        await client.createContact(contact);
        notifyUserCreation(nombre);
        emit(CreateContactSuccess());
      }
    } catch (e) {
      emit(CreateContactError());
    }
  }

  void notifyUserCreation(String userName) async {
    bool hasPermission = await WebNotification.requestPermission();

    if (hasPermission) {
      WebNotification.showNotification(
        'Usuario creado',
        'El usuario $userName ha sido creado con éxito.',
      );
    } else {
      print('El usuario no concedió permiso para notificaciones.');
    }
  }

  Future<void> syncLocalContacts() async {
    final localContacts = await dbHelper.getLocalContacts();
    for (var contact in localContacts) {
      final request = CreateContactRequestDto(
        nombre: contact.nombre,
        email: contact.email,
        telefono: contact.telefono,
      );
      await ApiClient(Dio()).createContact(request);
      await dbHelper.deleteContact(contact.id);
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
