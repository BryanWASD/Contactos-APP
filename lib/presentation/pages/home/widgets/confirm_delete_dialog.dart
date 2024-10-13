import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterpwa/presentation/pages/home/cubit/create_contact_cubit.dart';
import 'package:flutterpwa/presentation/pages/home/cubit/get_contacts_cubit.dart';

class ConfirmDeleteDialog {
  Future<void> show({
    required BuildContext context,
    required String id,
  }) async {
    final getContactsCubit = context.read<GetContactsCubit>();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('¿Deseas borrar el contacto?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<CreateContactCubit>().deleteEvent(id);

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
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
