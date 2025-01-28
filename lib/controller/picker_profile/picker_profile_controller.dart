import 'dart:convert';

import 'package:solitaire_picker/constants/constant.dart';
import 'package:solitaire_picker/model/user_model.dart';
import 'package:solitaire_picker/services/http_service.dart';
import 'package:solitaire_picker/utils/app_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:io';

class PickerProfileController {
  final HttpService _httpService = HttpService();

  Future<UserModel> getPickerProfile() async {
    const url = "/api/v1/pickers/profile";

    final response = await _httpService.request(url, method: HttpMethod.get);

    AppPreferences.setHasFingerprint(
        response['data']['hasFingerprint'] ?? false);
    AppPreferences.setHasNfc(response['data']['hasNfcCard'] ?? false);
    AppPreferences.setToken(response['data']['token']);
    AppPreferences.setUserId(response['data']['id']);
    AppPreferences.setName(response['data']['name']);
    AppPreferences.setEmail(response['data']['email']);
    AppPreferences.setPhone(response['data']['phone']);
    AppPreferences.setStatus(response['data']['status']);
    AppPreferences.setAvgRating(response['data']['avgRating'] ?? 0);

    return UserModel.fromJson(response['data']);
  }

  Future<void> updatePickerProfile(UserModel user, {File? imageFile}) async {
    final token = AppPreferences.getToken();
    const url = "/api/v1/pickers/profile";

    final request =
        http.MultipartRequest('PUT', Uri.parse("${AppUrls.baseUrl}$url"));

    // Add text fields
    request.fields['name'] = user.name ?? '';
    request.fields['email'] = user.email ?? '';
    request.fields['phone'] = user.phone ?? '';
    request.fields['address'] = user.address ?? '';

    // Add image file if provided
    if (imageFile != null) {
      final imageStream = http.ByteStream(imageFile.openRead());
      final imageLength = await imageFile.length();

      final multipartFile = http.MultipartFile(
        'avatar',
        imageStream,
        imageLength,
        filename: imageFile.path.split('/').last,
        contentType: MediaType(
            'image', 'jpeg'), // Adjust content type based on your needs
      );

      request.files.add(multipartFile);
    }

    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
    });

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print(response.body);
    } else {
      var data = jsonDecode(response.body);
      throw Exception(data['message']);
    }
  }

  Future<void> enableFingerprint(bool value) async {
    final token = AppPreferences.getToken();
    const url = "/api/v1/pickers/toggle-fingerprint";
    final response = await _httpService.request(
      url,
      method: HttpMethod.patch,
      additionalHeaders: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      data: {
        "enable": value,
      },
    );
    AppPreferences.setHasFingerprint(
        response['data']['hasFingerprint'] ?? false);
  }

  Future<void> enableNfc(bool value, String nfcCardId) async {
    final token = AppPreferences.getToken();
    const url = "/api/v1/pickers/toggle-nfc";

    final response = await _httpService.request(
      url,
      method: HttpMethod.patch,
      additionalHeaders: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
      data: value == true
          ? {"enable": value, "nfcCardId": nfcCardId}
          : {"enable": value},
    );
    AppPreferences.setHasNfc(response['data']['hasNfcCard'] ?? false);
  }
}
