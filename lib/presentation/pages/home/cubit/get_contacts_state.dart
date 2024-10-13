part of 'get_contacts_cubit.dart';

@immutable
abstract class GetContactsState {
  final List<ContactsResponseDto>? contacts;

  const GetContactsState({this.contacts});
}

final class GetContactsInitial extends GetContactsState {}

final class GetContactsLoading extends GetContactsState {}

final class GetContactsSuccess extends GetContactsState {
  final List<ContactsResponseDto>? newContacts;
  const GetContactsSuccess(this.newContacts) : super(contacts: newContacts);
}

final class GetContactsError extends GetContactsState {}

final class GetContactsEmpty extends GetContactsState {}
