import 'package:flutterpwa/domain/repositories/contact_repository.dart';

class SyncContactsUseCase {
  final ContactRepository repository;

  SyncContactsUseCase(this.repository);

  Future<void> execute() async {
    await repository.syncLocalContacts();
  }
}
