import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterpwa/data/local/db_helper.dart';
import 'package:flutterpwa/presentation/pages/home/cubit/create_contact_cubit.dart';
import 'package:flutterpwa/presentation/pages/home/cubit/get_contacts_cubit.dart';
import 'package:flutterpwa/presentation/pages/home/widgets/confirm_delete_dialog.dart';
import 'package:flutterpwa/presentation/pages/home/widgets/create_contact_dialog.dart';
import 'package:flutterpwa/services/sync_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late SyncService syncService;

  @override
  void initState() {
    super.initState();
    final createContactCubit = context.read<CreateContactCubit>();
    syncService = SyncService(createContactCubit);
    syncService.listenForConnectivity();
  }

  @override
  Widget build(BuildContext context) {
    final dbHelper = LocalDatabaseHelper();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetContactsCubit(dbHelper)..getContacts(),
        ),
        BlocProvider(
          create: (context) => CreateContactCubit(dbHelper),
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
                    if (contacts == null || contacts.isEmpty) {
                      return const Center(child: Text('No hay datos'));
                    }

                    // Ordenar los contactos alfabéticamente y agruparlos por la inicial
                    final Map<String, List<dynamic>> groupedContacts = {};
                    for (var contact in contacts) {
                      final initial = contact.nombre[0].toUpperCase();
                      groupedContacts
                          .putIfAbsent(initial, () => [])
                          .add(contact);
                    }

                    final sortedKeys = groupedContacts.keys.toList()..sort();

                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: sortedKeys.length,
                      itemBuilder: (context, index) {
                        final initial = sortedKeys[index];
                        final contactsByInitial = groupedContacts[initial]!;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              initial,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            ...contactsByInitial.map((contact) {
                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 20,
                                  child: Text(
                                    contact.nombre[0].toUpperCase(),
                                  ),
                                ),
                                title: Text(contact.nombre),
                                subtitle: Text(
                                    "${contact.telefono}\n${contact.email}"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        CreateContactDialog().show(
                                            context: context, contact: contact);
                                      },
                                      icon: const Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        ConfirmDeleteDialog().show(
                                            context: context, id: contact.id);
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        );
                      },
                    );
                  }
                  if (state is GetContactsError) {
                    return const Center(
                      child: Text('Hubo un error al obtener los datos'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
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
