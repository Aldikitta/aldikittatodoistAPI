import '../model/profile.dart';
import 'package:http/http.dart' show Client;

class ApiService {
  final String baseUrl = "https://api.todoist.com/rest/v1/tasks";
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': 'Bearer 762e865d1083babe04c9d1aa7d34867e83784c9f'
  };
  Client client = Client();

  Future<List<Profile>> getProfiles() async {
    final response = await client.get("$baseUrl", headers: requestHeaders);
    if (response.statusCode == 200) {
      return profileFromJson(response.body);
    } else {
      return null;
    }
  }

  Future<bool> createProfile(Profile data) async {
    final response = await client.post(
      "$baseUrl",
      headers: requestHeaders,
      body: profileToJson(data),
    );
    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateProfile(Profile data) async {
    final response = await client.post(
      "$baseUrl/${data.id}",
      headers: requestHeaders,
      body: profileToJson(data),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> deleteProfile(int id) async {
    final response = await client.delete(
      "$baseUrl/$id",
      headers: requestHeaders,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
