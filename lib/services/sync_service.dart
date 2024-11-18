import 'package:connectivity/connectivity.dart';
import 'package:flutterpwa/presentation/pages/home/cubit/create_contact_cubit.dart';

class SyncService {
  final CreateContactCubit createContactCubit;

  SyncService(this.createContactCubit);

  void listenForConnectivity() {
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result != ConnectivityResult.none) {
        createContactCubit.syncLocalContacts();
      }
    });
  }
}
