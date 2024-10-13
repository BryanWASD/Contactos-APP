import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterpwa/presentation/pages/home/cubit/create_contact_cubit.dart';
import 'package:flutterpwa/presentation/pages/home/cubit/get_contacts_cubit.dart';
import 'package:flutterpwa/presentation/pages/home/home.dart';
import 'package:flutterpwa/presentation/theme/theme.dart';
import 'package:flutterpwa/presentation/theme/util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = createTextTheme(context, 'LexendDeca');
    MaterialTheme theme = MaterialTheme(textTheme);
    // final apiClient =
    //     ApiClient(Dio(BaseOptions(contentType: "application/json")));
    return MultiBlocProvider(
      providers: [
        BlocProvider<GetContactsCubit>(
          create: (context) => GetContactsCubit(),
        ),
        BlocProvider<CreateContactCubit>(
          create: (context) => CreateContactCubit(),
        )
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
