import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterpwa/data/dtos/response/create_contact_response_dto.dart';
import 'package:flutterpwa/presentation/pages/home/cubit/create_contact_cubit.dart';
import 'package:flutterpwa/presentation/pages/home/cubit/get_contacts_cubit.dart';

class CreateContactDialog {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  Future<void> show({
    ContactsResponseDto? contact,
    required BuildContext context,
  }) async {
    final getContactsCubit = context.read<GetContactsCubit>();
    if (contact != null) {
      _nameController.text = contact.nombre;
      _emailController.text = contact.email;
      _phoneController.text = contact.telefono;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text(contact == null ? 'Crear Contacto' : 'Actualizar Contacto'),
          content: Container(
            width: MediaQuery.sizeOf(context).width * .50,
            padding: const EdgeInsets.all(10),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(
                            labelText: 'Nombre',
                            hintText: 'Jhon Doe',
                          ),
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(15),
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese un nombre';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          controller: _phoneController,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(10),
                          ],
                          decoration: const InputDecoration(
                            labelText: 'Numero de telefono',
                            hintText: '9992112233',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese un numero de telefono';
                            }
                            if (!RegExp(r'^\d+$').hasMatch(value)) {
                              return 'El telefono solo debe contener números';
                            }
                            return null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Correo',
                            hintText: 'correo@ejemplo.com',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor ingrese un correo';
                            }
                            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                .hasMatch(value)) {
                              return 'Por favor ingrese un correo válido';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final String nombre = _nameController.text;
                  final String email = _emailController.text;
                  final String telefono = _phoneController.text;

                  if (contact == null) {
                    context
                        .read<CreateContactCubit>()
                        .createContact(nombre, email, telefono);
                    _nameController.clear();
                    _emailController.clear();
                    _phoneController.clear();
                  } else {
                    context
                        .read<CreateContactCubit>()
                        .updateContact(contact.id, nombre, email, telefono);
                    _nameController.clear();
                    _emailController.clear();
                    _phoneController.clear();
                  }

                  listener(CreateContactState state) {
                    if (state is CreateContactSuccess) {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                        getContactsCubit.getContacts();
                      }
                      context.read<GetContactsCubit>().getContacts();
                    } else if (state is CreateContactError) {
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error al crear el contacto'),
                          ),
                        );
                      }
                    }
                  }

                  context.read<CreateContactCubit>().stream.listen(listener);
                }
              },
              child: const Text('Guardar'),
            )
          ],
        );
      },
    );
  }
}
