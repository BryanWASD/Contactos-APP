import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutterpwa/data/dtos/response/create_contact_response_dto.dart';
import 'package:flutterpwa/data/main/api_data.dart';
import 'package:meta/meta.dart';

part 'get_contacts_state.dart';

class GetContactsCubit extends Cubit<GetContactsState> {
  GetContactsCubit() : super(GetContactsInitial());

  Future<void> getContacts() async {
    emit(state);
    try {
      final dio = Dio();
      final client = ApiClient(dio);

      final List<ContactsResponseDto> contacts = await client.getContacts();

      if (contacts.isNotEmpty) {
        emit(GetContactsSuccess(contacts));
      } else {
        emit(GetContactsEmpty());
      }
    } catch (e) {
      emit(GetContactsError());
    }
  }
}
