import 'package:dio/dio.dart';
import 'package:flutterpwa/data/dtos/request/create_contact_request_dto.dart';
import 'package:flutterpwa/data/dtos/response/create_contact_response_dto.dart';
import 'package:retrofit/retrofit.dart';

part 'api_data.g.dart';

@RestApi(baseUrl: 'http://localhost:5000/api')
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  @GET('/contacts')
  Future<List<ContactsResponseDto>> getContacts();

  @POST('/contacts')
  Future<void> createContact(
    @Body() CreateContactRequestDto contact,
  );

  @PUT('/contacts/{id}')
  Future<void> updateContact(
    @Path('id') String id,
    @Body() CreateContactRequestDto contact,
  );

  @DELETE('/contacts/{id}')
  Future<void> deleteContact(
    @Path('id') String id,
  );
}
