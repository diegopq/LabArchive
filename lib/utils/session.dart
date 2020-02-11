import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Session {
  final key = "SESSION";
  final storage = new FlutterSecureStorage();

//para almacenar el token de manera segura
  saveToken(
    String token,
  ) async {
    final data = {
      'token': token,
      // 'expiresIn': expiresIn,
      'createdAt': DateTime.now().toString(),
    };

    await storage.write(key: key, value: jsonEncode(data));
  }

//para obtener el token
  getToken() async {
    final result = await storage.read(key: key);
    if (result != null) {
      return jsonDecode(result);
    }
    return null;
  }

  Future<void> deleteToken() async {
    await storage.delete(key: key);
  }
}
