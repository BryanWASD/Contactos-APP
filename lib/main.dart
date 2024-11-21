import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterpwa/data/local/db_helper.dart';
import 'package:flutterpwa/presentation/pages/home/cubit/create_contact_cubit.dart';
import 'package:flutterpwa/presentation/pages/home/cubit/get_contacts_cubit.dart';
import 'package:flutterpwa/presentation/pages/home/home.dart';
import 'package:flutterpwa/presentation/theme/theme.dart';
import 'package:flutterpwa/presentation/theme/util.dart';
import 'package:flutterpwa/services/sync_service.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

void main() async {
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  } else {
    databaseFactory = databaseFactoryFfi;
  }
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: const FirebaseOptions(
  //       apiKey: "AIzaSyDBkkhgbVh8xYDLpuuS2q1ivVF5AxJzF-I",
  //       authDomain: "flutter-3c0eb.firebaseapp.com",
  //       projectId: "flutter-3c0eb",
  //       storageBucket: "flutter-3c0eb.firebasestorage.app",
  //       messagingSenderId: "291649233099",
  //       appId: "1:291649233099:web:51a9c362e35a836e013b4e",
  //       measurementId: "G-B64YMB9D5Z"),
  // ); // Inicializar Firebase
  // //added
  // await FirebaseMessaging.instance.requestPermission(); // Pedir permisos
  // await FirebaseMessaging.instance
  //     .subscribeToTopic("all"); // Suscribirse a un tópico
  // //added
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, 'LexendDeca');
    MaterialTheme theme = MaterialTheme(textTheme);
    final dbHelper = LocalDatabaseHelper();

    final createContactCubit = CreateContactCubit(dbHelper);
    final getContactsCubit = GetContactsCubit(dbHelper);

    final syncService = SyncService(createContactCubit);
    syncService.listenForConnectivity();

    return MultiBlocProvider(
      providers: [
        BlocProvider<GetContactsCubit>(
          create: (context) => getContactsCubit,
        ),
        BlocProvider<CreateContactCubit>(
          create: (context) => createContactCubit,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Contactos',
        themeMode: ThemeMode.system,
        theme: theme.light(),
        darkTheme: theme.dark(),
        home: const MyHomePage(),
      ),
    );
  }
}
