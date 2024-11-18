import 'package:connectivity/connectivity.dart';
import 'package:flutterpwa/data/local/db_helper.dart';
import 'package:flutterpwa/data/main/api_data.dart';
import 'package:flutterpwa/data/models/contact_model.dart';
import 'package:flutterpwa/domain/repositories/contact_repository.dart';

class ContactRepositoryImpl implements ContactRepository {
  final ApiClient apiClient;
  final LocalDatabaseHelper dbHelper;

  ContactRepositoryImpl(this.apiClient, this.dbHelper);

  @override
  Future<List<ContactModel>> getContacts() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return dbHelper.getLocalContacts();
    } else {
      var response = await apiClient.getContacts();
      return response.map((dto) => ContactModel.fromDto(dto)).toList();
    }
  }

  @override
  Future<void> createContact(ContactModel contact) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      await dbHelper.insertContact(contact);
    } else {
      await apiClient.createContact(contact.toRequestDto());
    }
  }

  @override
  Future<void> syncLocalContacts() async {
    var contacts = await dbHelper.getLocalContacts();
    for (var contact in contacts) {
      await apiClient.createContact(contact.toRequestDto());
      await dbHelper.deleteContact(contact.id);
    }
  }
}
