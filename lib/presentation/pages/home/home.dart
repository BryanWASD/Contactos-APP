import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterpwa/presentation/pages/home/cubit/create_contact_cubit.dart';
import 'package:flutterpwa/presentation/pages/home/cubit/get_contacts_cubit.dart';
import 'package:flutterpwa/presentation/pages/home/widgets/confirm_delete_dialog.dart';
import 'package:flutterpwa/presentation/pages/home/widgets/create_contact_dialog.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetContactsCubit()..getContacts(),
        ),
        BlocProvider(
          create: (context) => CreateContactCubit(),
        )
      ],
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Contactos'),
              actions: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton.icon(
                    style: TextButton.styleFrom(
                      shape: const BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(2),
                        ),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () async {
                      CreateContactDialog().show(context: context);
                    },
                    label: const Text('Agregar contacto'),
                    icon: const Icon(Icons.add),
                  ),
                )
              ],
            ),
            body: SafeArea(
              child: BlocBuilder<GetContactsCubit, GetContactsState>(
                builder: (context, state) {
                  if (state is GetContactsLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (state is GetContactsSuccess) {
                    final contacts = state.contacts;
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: contacts!.length,
                      itemBuilder: (context, index) {
                        final contact = contacts[index];
                        return ListTile(
                          leading: CircleAvatar(
                            radius: 20,
                            child: Text(
                              contact.nombre[0].toUpperCase(),
                            ),
                          ),
                          title: Text(contact.nombre),
                          subtitle:
                              Text("${contact.telefono}\n${contact.email}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () {
                                  CreateContactDialog()
                                      .show(context: context, contact: contact);
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () {
                                  ConfirmDeleteDialog()
                                      .show(context: context, id: contact.id);
                                },
                                icon: const Icon(Icons.delete),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }
                  if (state is GetContactsEmpty) {
                    return const Center(
                      child: Text('No hay datos'),
                    );
                  }
                  if (state is GetContactsError) {
                    return const Center(
                      child: Text('Hubo un error al obtener los datos'),
                    );
                  }
                  return const Center(
                    child: Text('No hay datos'),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
