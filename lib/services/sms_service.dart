import 'package:dio/dio.dart';
import 'dart:convert';

class SmsService {
  final String accountSid = 'AC2dde7729996c5d4c0c356c435a0b96dc';
  final String authToken = '685ce87e1b5035fc8dcbd08da615bd8d';
  final String twilioNumber = '+51925688434';

  Future<void> sendSms(String to, String message) async {
    final dio = Dio();
    final url = 'https://api.twilio.com/2010-04-01/Accounts/$accountSid/Messages.json';

    try {
      final response = await dio.post(
        url,
        data: {
          'From': twilioNumber,
          'To': '+51$to',
          'Body': message,
        },
        options: Options(
          headers: {
            'Authorization': 'Basic ${base64Encode(utf8.encode('$accountSid:$authToken'))}',
          },
        ),
      );

      print('Código de respuesta: ${response.statusCode}');
      print('Respuesta de Twilio: ${response.data}');
    } catch (e) {
      print('Error al enviar el mensaje: $e');
    }
  }
}
