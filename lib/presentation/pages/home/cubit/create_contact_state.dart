part of 'create_contact_cubit.dart';

@immutable
abstract class CreateContactState {}

final class CreateContactInitial extends CreateContactState {}

final class CreateContactLoading extends CreateContactState {}

final class CreateContactSuccess extends CreateContactState {}

final class CreateContactError extends CreateContactState {}

final class CreateContactEmpty extends CreateContactState {}
