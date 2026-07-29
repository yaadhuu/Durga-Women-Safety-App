import 'package:dio/dio.dart';
import 'app_models.dart';
import 'api_client.dart';

class AppService {
  // Contacts
  static Future<List<Contact>> getContacts() async {
    final response = await ApiClient.instance.dio.get('/contacts/');
    return (response.data as List).map((x) => Contact.fromJson(x)).toList();
  }

  static Future<Contact> createContact(String name, String phone, String? relation) async {
    final response = await ApiClient.instance.dio.post(
      '/contacts/',
      data: {'name': name, 'phone': phone, 'relation': relation},
    );
    return Contact.fromJson(response.data);
  }

  static Future<void> deleteContact(String id) async {
    await ApiClient.instance.dio.delete('/contacts/$id');
  }

  // SOS
  static Future<SOSAlert> triggerSOS(double? lat, double? lng) async {
    final response = await ApiClient.instance.dio.post(
      '/sos/trigger',
      data: {'latitude': lat, 'longitude': lng},
    );
    return SOSAlert.fromJson(response.data);
  }

  // Threat
  static Future<ThreatResponse> analyzeThreat(String text) async {
    final response = await ApiClient.instance.dio.post(
      '/threat/analyze',
      data: {'text': text},
    );
    return ThreatResponse.fromJson(response.data);
  }

  // Evidence
  static Future<void> uploadEvidence(String filePath) async {
    String fileName = filePath.split('/').last;
    FormData formData = FormData.fromMap({
      "file": await MultipartFile.fromFile(filePath, filename: fileName),
    });
    await ApiClient.instance.dio.post('/evidence/upload', data: formData);
  }
}
