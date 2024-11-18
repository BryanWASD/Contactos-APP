import 'package:bloc/bloc.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:flutterpwa/data/dtos/response/create_contact_response_dto.dart';
import 'package:flutterpwa/data/local/db_helper.dart';
import 'package:flutterpwa/data/main/api_data.dart';
import 'package:flutterpwa/data/models/contact_model.dart';
import 'package:meta/meta.dart';

part 'get_contacts_state.dart';

class GetContactsCubit extends Cubit<GetContactsState> {
  final LocalDatabaseHelper dbHelper;

  GetContactsCubit(this.dbHelper) : super(GetContactsInitial());

  Future<void> getContacts() async {
    emit(GetContactsLoading());

    try {
      // Primero intentamos obtener los contactos locales.
      final List<ContactModel> localContacts =
          await dbHelper.getLocalContacts();
      final List<ContactsResponseDto> localResponseDtos =
          localContacts.map((contact) => contact.toResponseDto()).toList();

      if (localResponseDtos.isNotEmpty) {
        emit(GetContactsSuccess(localResponseDtos));
      } else {
        emit(GetContactsEmpty());
      }

      // Verificamos la conectividad.
      final connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult != ConnectivityResult.none) {
        // Intentamos obtener contactos desde la API.
        final dio = Dio();
        final client = ApiClient(dio);

        try {
          final List<ContactsResponseDto> apiContacts =
              await client.getContacts();

          if (apiContacts.isNotEmpty) {
            // Guardamos los contactos de la API en la base de datos local.
            await dbHelper.saveContacts(apiContacts);
            emit(GetContactsSuccess(apiContacts));
          } else {
            emit(GetContactsEmpty());
          }
        } catch (apiError) {
          // Si falla la API, no emitimos un error, ya hemos emitido los datos locales.
          print('Error al obtener contactos desde la API: $apiError');
        }
      }
    } catch (localError) {
      // Si falla la obtención de datos locales, emitimos un error.
      print('Error al obtener contactos locales: $localError');
      emit(GetContactsError());
    }
  }
}
