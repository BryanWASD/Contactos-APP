import 'package:flutterpwa/data/models/contact_model.dart';

abstract class ContactRepository {
  Future<List<ContactModel>> getContacts();
  Future<void> createContact(ContactModel contact);
  // Future<void> updateContact(String id, ContactModel contact);
  // Future<void> deleteContact(String id);
  // Future<List<ContactModel>> getLocalContacts();
  Future<void> syncLocalContacts();
}
