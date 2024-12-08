import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // Base URL của backend
  final String baseUrl = 'https://email.huynhnhathao.site/api/v1/email/';

  // Hàm POST đăng ký người dùng
  Future<Map<String, dynamic>> signUp({
    required String fullName,
    required String email,
    required String mailAddress,
    required String password,
    required String phone,
  }) async {
    final url = Uri.parse('${baseUrl}users/sign-up');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "full_name": fullName,
        "email": email,
        "mail_address": mailAddress,
        "password": password,
        "phone": phone,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to sign up');
    }
  }

  // Hàm POST để phục hồi mật khẩu
  Future<void> recoveryPassword(String phone) async {
    final url = Uri.parse('${baseUrl}users/recovery-pasword');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"phone": phone}),
    );

    if (response.statusCode != 204) {
      throw Exception('Failed to recover password');
    }
  }

  // Hàm POST đăng nhập người dùng
  Future<Map<String, dynamic>> signIn({
    required String phone,
    required String password,
  }) async {
    final url = Uri.parse('${baseUrl}users/sign-in');
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "phone": phone,
        "password": password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to sign in');
    }
  }

  // Hàm POST để bật 2 bước xác minh
  Future<Map<String, dynamic>> enableTwoStepVerification(String accessToken) async {
    final url = Uri.parse('${baseUrl}users/enable-two-step-verification');
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to enable two-step verification');
    }
  }

  // Hàm POST xác minh 2 bước
  Future<Map<String, dynamic>> verifyTwoStepVerification({
    required String accessToken,
    required String token,
  }) async {
    final url = Uri.parse('${baseUrl}users/verify-token');
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json"
      },
      body: jsonEncode({"token": token}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to verify two-step verification');
    }
  }

  // Hàm PUT cập nhật mật khẩu
  Future<Map<String, dynamic>> updatePassword({
    required String accessToken,
    required String password,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final url = Uri.parse('${baseUrl}users/update-pasword');
    final response = await http.put(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "password": password,
        "newPassword": newPassword,
        "confirmPassword": confirmPassword,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update password');
    }
  }

  // Hàm PUT cập nhật thông tin người dùng
  Future<Map<String, dynamic>> updateUserInfo({
    required String accessToken,
    required String fullName,
    required String email,
    required String phone,
  }) async {
    final url = Uri.parse('${baseUrl}users/update-information');
    final response = await http.put(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "full_name": fullName,
        "email": email,
        "phone": phone,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to update user info');
    }
  }

  // Hàm POST tạo nhãn
  Future<Map<String, dynamic>> createLabel({
    required String accessToken,
    required String name,
    String? color,
    String? description,
  }) async {
    final url = Uri.parse('${baseUrl}labels/');
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "name": name,
        "color": color,
        "description": description,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create label');
    }
  }

  // Hàm GET lấy danh sách nhãn
  Future<List<Map<String, dynamic>>> getLabels({
    required String accessToken,
  }) async {
    final url = Uri.parse('${baseUrl}labels');
    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data['data']);
    } else {
      throw Exception('Failed to fetch labels');
    }
  }

  // Hàm PUT để cập nhật nhãn
Future<Map<String, dynamic>> updateLabel({
  required String accessToken,
  required String labelId,
  required String name,
  String? color,
  String? description,
}) async {
  final url = Uri.parse('${baseUrl}labels/$labelId');
  final response = await http.put(
    url,
    headers: {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json"
    },
    body: jsonEncode({
      "name": name,
      "color": color,
      "description": description,
    }),
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to update label');
  }
}

// Hàm DELETE để xóa nhãn
Future<Map<String, dynamic>> deleteLabel({
  required String accessToken,
  required String labelId,
}) async {
  final url = Uri.parse('${baseUrl}labels/$labelId');
  final response = await http.delete(
    url,
    headers: {
      "Authorization": "Bearer $accessToken",
      "Content-Type": "application/json"
    },
  );

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to delete label');
  }
}

   // Hàm POST để upload tệp đính kèm
  Future<Map<String, dynamic>> uploadAttachment({
    required String accessToken,
    required File file,
  }) async {
    final url = Uri.parse('${baseUrl}attchemnts/');

    try {
      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer $accessToken'
        ..headers['Content-Type'] = 'multipart/form-data'
        ..files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();

      if (response.statusCode == 201) {
        final responseBody = await response.stream.bytesToString();
        return jsonDecode(responseBody);
      } else {
        throw Exception('Failed to upload attachment');
      }
    } catch (e) {
      throw Exception('Error occurred while uploading attachment: $e');
    }
  }

  // Hàm DELETE để xóa tệp đính kèm
Future<Map<String, dynamic>> deleteAttachment({
  required String accessToken,
  required String urlId,
}) async {
  final url = Uri.parse('${baseUrl}attchemnts/$urlId');

  try {
    final response = await http.delete(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode({"url_id": urlId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to delete attachment');
    }
  } catch (e) {
    throw Exception('Error occurred while deleting attachment: $e');
  }
}

  // Hàm POST để gửi tin nhắn nháp
  Future<Map<String, dynamic>> sendDraftMessage({
    required String accessToken,
    required String messageId,
    required String conversationId,
    String? subject,
    String? body,
    List<String>? attachments,
    List<String>? to,
    List<String>? cc,
    List<String>? bcc,
  }) async {
    final url = Uri.parse('${baseUrl}mail-box/darf-message');

    // Xây dựng body của request
    final Map<String, dynamic> requestBody = {
      "message_id": messageId,
      "conversation_id": conversationId,
      "subject": subject ?? '',
      "body": body ?? '',
      "attachments": attachments ?? [],
      "to": to ?? [],
      "cc": cc ?? [],
      "bcc": bcc ?? [],
    };

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(requestBody),
      );

      if (response.statusCode == 201) {
        // Nếu thành công, trả về dữ liệu phản hồi
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to send draft message');
      }
    } catch (e) {
      throw Exception('Error occurred while sending draft message: $e');
    }
  }

  // Hàm POST gửi tin nhắn
  Future<Map<String, dynamic>> sendMessage({
    required String accessToken,
    required String messageId,
    required String conversationId,
    required String subject,
    required String body,
    required List<String> to,
    List<String>? cc,
    List<String>? bcc,
  }) async {
    final url = Uri.parse('${baseUrl}mail-box/send');
    final response = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json"
      },
      body: jsonEncode({
        "message_id": messageId,
        "conversation_id": conversationId,
        "subject": subject,
        "body": body,
        "to": to,
        "cc": cc,
        "bcc": bcc,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to send message');
    }
  }

  Future<List<dynamic>> getListConversations(String status, String accessToken) async {
  final response = await http.get(
    Uri.parse('https://email.huynhnhathao.site/api/v1/email/conversation?status=$status'),
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );
  if (response.statusCode == 200) {
    final data = json.decode(response.body)['data'];
    return data;
  } else {
    throw Exception('Failed to load conversations');
  }
}

Future<List<dynamic>> searchConversations(String subject, {bool? hasAttachments, String? to, String? fromDate, String? toDate}) async {
  final Map<String, dynamic> searchParams = {
    "subject": subject,
    if (hasAttachments != null) "has_attachments": hasAttachments,
    if (to != null) "to": to,
    if (fromDate != null) "fromDate": fromDate,
    if (toDate != null) "toDate": toDate,
  };
  
  final response = await http.get(
    Uri.parse('https://email.huynhnhathao.site/api/v1/email/conversation'),
    headers: {
      'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
    },
    //body: json.encode(searchParams),
  );
  
  if (response.statusCode == 200) {
    final data = json.decode(response.body)['data'];
    return data;
  } else {
    throw Exception('Failed to search conversations');
  }
}


Future<void> modifyLabelInConversation(String conversationId, String labelId, String action) async {
  final response = await http.put(
    Uri.parse('https://email.huynhnhathao.site/api/v1/email/conversation/$conversationId/label?action=$action'),
    headers: {
      'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
      'Content-Type': 'application/json',
    },
    body: json.encode({"label_id": labelId}),
  );

  if (response.statusCode != 200) {
    throw Exception('Failed to modify label in conversation');
  }
}

Future<void> updateConversationStatus(String conversationId, String status) async {
  final response = await http.get(
    Uri.parse('https://email.huynhnhathao.site/api/v1/email/conversation/$conversationId?status=$status'),
    headers: {
      'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
    },
  );

  if (response.statusCode == 200) {
    print('Status updated successfully');
  } else {
    throw Exception('Failed to update conversation status');
  }
}
Future<void> replyMessage(String conversationId, String content) async {
  final response = await http.post(
    Uri.parse('https://email.huynhnhathao.site/api/v1/email/conversation/$conversationId/reply'),
    headers: {
      'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
      'Content-Type': 'application/json',
    },
    body: json.encode({"content": content}),
  );

  if (response.statusCode == 200) {
    print('Message replied successfully');
  } else {
    throw Exception('Failed to reply to message');
  }
}

Future<void> forwardMessage(String conversationId, String to, String content) async {
  final response = await http.post(
    Uri.parse('https://email.huynhnhathao.site/api/v1/email/conversation/$conversationId/forward'),
    headers: {
      'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
      'Content-Type': 'application/json',
    },
    body: json.encode({"to": to, "content": content}),
  );

  if (response.statusCode == 200) {
    print('Message forwarded successfully');
  } else {
    throw Exception('Failed to forward message');
  }
}
Future<void> discardMessage(String conversationId) async {
  final response = await http.post(
    Uri.parse('https://email.huynhnhathao.site/api/v1/email/conversation/$conversationId/discard'),
    headers: {
      'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
    },
  );

  if (response.statusCode == 200) {
    print('Message discarded successfully');
  } else {
    throw Exception('Failed to discard message');
  }
}

Future<void> enableAutoReply(String conversationId, String autoReplyMessage) async {
  final response = await http.post(
    Uri.parse('https://email.huynhnhathao.site/api/v1/email/conversation/$conversationId/auto-reply'),
    headers: {
      'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
      'Content-Type': 'application/json',
    },
    body: json.encode({"message": autoReplyMessage}),
  );

  if (response.statusCode == 200) {
    print('Auto-reply enabled successfully');
  } else {
    throw Exception('Failed to enable auto-reply');
  }
}
Future<dynamic> getConversationStatus(String conversationId) async {
  final response = await http.get(
    Uri.parse('https://email.huynhnhathao.site/api/v1/email/conversation/$conversationId'),
    headers: {
      'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
    },
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body)['data'];
    return data;
  } else {
    throw Exception('Failed to get conversation status');
  }
}

}
